#!/usr/bin/env bash

# Script to gather some useful system info and slap it on the
# desktop as a background image in Mac OS X.
#
# Requires ImageMagick installed with GhostScript to run.
# If you have HomeBrew[http://Brew.sh] installed you can simply
#   $ brew install imagemagick ghostscript

### Configuration
#####################################################################

# We need to explicitly set the PATH because launchd only looks at the
# Mac OS X default PATH in 10.10
export PATH=/usr/local/bin:/usr/local/sbin:$PATH

# Commandline options. This defines the usage page, and is used to parse cli
# opts & defaults from. The parsing is unforgiving so be precise in your syntax
read -r -d '' usage <<-'EOF'
  -t         Generate a test image without changing the background.
  -d         Enables debug mode
  -l         Redirect all output to the log file
  -h         This page
EOF

# Create a date-stamped log file in user's logs directory
LOG_DIR="$(stat -f "%N" ~/Library/Logs)/com.microsoft.bginfo"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/$(date).log"
touch "$LOG_FILE"

# Enable some primitive logging
function log { printf "%s\n" "${@}" >> "$LOG_FILE"; }

# Set magic variables for current FILE & DIR
__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
__file="${__dir}/$(basename "${BASH_SOURCE[0]}")"

log "Current Directory: $__dir" "File Name: $__file"

function help
{
  echo "" 1>&2
  echo " $*" 1>&2
  echo "" 1>&2
  echo "  ${usage}" 1>&2
  echo "" 1>&2
  exit 1
}

# -- Returns specified field value from system_profiler
#  - Arg1: system_profiler data type string (i.e. SPSoftwareDataType)
#  - Arg2: Field name of value to be returned
function get_system_profile
{
  system_profiler "$1" 2> /dev/null |
  grep "$2" |
  awk -F': ' '{ print $2 }'
}

# -- Returns rounded number
#  - Arg1: Number or Calculation to be rounded
#  - Arg2: Decimal places to round
#    We need this to calculate font sizes relative to display resolution. Only
#    works on positive numbers - http://stempell.com/2009/08/rechnen-in-bash/
function round
{
  echo $( printf %.$2f $( echo "scale=$2; (((10^$2)*$1)+0.5)/(10^$2)" | bc ))
}

# # # # # # # # # # # # # # # # # # # # # # # #
#                                             #
# Grab data needed for the desktop background #
#                                             #
# # # # # # # # # # # # # # # # # # # # # # # #
function retrieve_system_info
{
  # Some manual delay to prevent script from running before display
  # resolution is set at startup
  sleep 5

  # Select only the digits and the 'x' between them, then delete spaces for a nice
  # usable 1280x800 style format
  display_resolution=$(
    get_system_profile SPDisplaysDataType 'Resolution' |
    egrep -o '^[[:digit:]]{3,4}\sx\s[[:digit:]]{3,4}' |
    tr -d ' '
  )
  log "Display Resolution: $display_resolution"

  display_height=$(echo "$display_resolution" | egrep -o "[[:digit:]]{3,4}$")

  bg_pointsize=$(round "$display_height*0.022" 0)

  os_version=$(get_system_profile SPSoftwareDataType 'System Version')

  model_id=$(
    get_system_profile SPHardwareDataType 'Model Identifier' |
    awk '{ print "("$1")" }'
  )

  serial_number=$(get_system_profile SPHardwareDataType 'Serial Number')

  # http://apple.stackexchange.com/questions/98080/can-a-macs-model-year-be-determined-via-terminal-command
  # This Apple URL when provided with the last 3 digits of a serial number will
  # return an XML document with an element named <configCode> that contains the
  # official Apple model name for that machine.
  model_name=$(
    apple_url='http://support-sp.apple.com/sp/product/?cc='
    curl "$apple_url$(echo "$serial_number" | cut -c 9-)" |
    sed 's|.*<configCode>\(.*\)</configCode>.*|\1|' |
    tr -d '()'
  )

  memory=$(
    get_system_profile SPHardwareDataType 'Memory' |
    awk '{ print $1" "$2" RAM" }'
  )

  ip_address=$(
    get_system_profile SPNetworkDataType 'IPv4 Addresses' |
    awk '{ print $1 }'
  )

  mac_address=$(ifconfig en0 | awk '/ether/ { print $2}') || true

  # Small ruby script to parse data from system_profiler SPStorageDataType
  # into a easier-for-me-to-use format
  storage_report=$("$__dir"/macstorage.sh --report)

  boot_volume=$(
    diskutil info / |
    grep Volume\ Name: |
    cut -c 30-
  ) || true

  cpu_info=$(
    system_profiler SPHardwareDataType 2> /dev/null |
    awk -F': ' '{
      if ($1 ~ /Processor Name|Processor Speed|Cores/) printf "%s ", $2;
    } END { print "Cores" }'
  )

  computer_name=$(scutil --get LocalHostName)

  # This part is still untested. Bruce gave me this defaults read.
  checked_out_to=$(
    defaults read com.microsoft.macbu.infra.exclient 'Owners EMail' |
    awk '{ print "Checked out to: "$1 }'
  ) || true

  xcode_version=$(xcodebuild -version 2> /dev/null | head -n 1) || true

  # Regex demystified: 1 to 3 digits followed by a dot, then repeat that pattern
  # twice more
  mono_version=$(
    mono --version 2> /dev/null |
    egrep -o 'version [[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}' |
    awk '{ print "Mono "$2 }'
  ) || true
}

function bg_color
{
  if [ "$boot_volume" = "ChangeOS" ]; then
    echo "rgb(65,55,55)"
  else
    echo "rgb(90,90,95)"
  fi
}

function xcode_mono_versions
{
  if [ -z "$xcode_version" ] || [ -z "$mono_version" ]; then
    echo "$xcode_version" "$mono_version"
  else
    echo "$xcode_version & $mono_version"
  fi
}

# -- Formats each piece of data on its very own new line
function background_text
{
  printf %"s\n" " " "$model_name $model_id" "$cpu_info | $memory" \
  "$ip_address | $mac_address" "$serial_number" " " "$(xcode_mono_versions)" \
  " " "Volume: (Available / Capacity)" "- - - - - - - - - - - - - - - - - - -" \
  "$storage_report"
}

# -- Read more about this usage of ImageMagick at http://www.imagemagick.org/Usage/text/
function generate_image
{
  convert -verbose -background "$(bg_color)" -fill ivory2 -interline-spacing 15 \
  -size "$display_resolution" -gravity center -pointsize "$bg_pointsize" \
  caption:"$(background_text)" \
  "$__dir/image.gif"
}

function generate_header
{
  top_padding=$(round "$display_height*0.07" 0)
  header_pointsize=$(round "$bg_pointsize*1.875" 0)
  header_2_padding=$((top_padding + header_pointsize + 5))
  header_3_padding=$((header_2_padding + header_pointsize + 5))
  log "========= HEADER LOGGING ========="
  log "BG Point Size: $bg_pointsize"
  log "Top Padding: $top_padding"
  log "Header Point Size: $header_pointsize"
  log "Header 2 Padding: $header_2_padding"
  log "Header 3 Padding: $header_3_padding"
  log "========= END HEADER LOG ========="

  convert "$__dir/image.gif" -verbose -font Helvetica -pointsize "$header_pointsize" -draw \
  "gravity north fill ivory2 text 0,$top_padding '$computer_name' \
  fill ivory2 text 0,$header_2_padding '$os_version' \
  fill ivory2 text 0,$header_3_padding '$checked_out_to'" "$__dir/final_bg.gif"

  rm "$__dir/image.gif"
}

# -- Uses a snippet of AppleScript to set the desktop background
#    and restarts the Dock to refresh the desktop
function set_desktop_background
{
  path_to_image="$__dir/final_bg.gif"
  log "Image Path: $path_to_image"
  osascript -e "tell application \"System Events\" to set picture of every desktop to \"$path_to_image\""
  killall Dock
}

function main
{
  echo "Starting BGInfo"
  echo "==============="
  echo ""
  retrieve_system_info
  generate_image
  generate_header

  if [ "$TEST_MODE" -eq 1 ]; then
    open final_bg.gif
  else
    set_desktop_background
  fi

  cat "$LOG_FILE" > "$LOG_DIR/BGInfo.log"
}

### Parse commandline options
#####################################################################

# Translate usage string -> getopts arguments, and set $arg_<flag> defaults
while read line; do
  opt="$(echo "${line}" |awk '{print $1}' |sed -e 's#^-##')"
  if ! echo "${line}" |egrep '\[.*\]' >/dev/null 2>&1; then
    init="0" # it's a flag. init with 0
  else
    opt="${opt}:" # add : if opt has arg
    init=""  # it has an arg. init with ""
  fi
  opts="${opts}${opt}"

  varname="arg_${opt:0:1}"
  if ! echo "${line}" |egrep '\. Default=' >/dev/null 2>&1; then
    eval "${varname}=\"${init}\""
  else
    match="$(echo "${line}" |sed 's#^.*Default=\(\)#\1#g')"
    eval "${varname}=\"${match}\""
  fi
done <<< "${usage}"

# Reset in case getopts has been used previously in the shell.
OPTIND=1

# Overwrite $arg_<flag> defaults with the actual CLI options
while getopts "${opts}" opt; do
  line="$(echo "${usage}" |grep "\-${opt}")"

  [ "${opt}" = "?" ] && help "Invalid use of script: $* "
  varname="arg_${opt:0:1}"
  default="${!varname}"

  value="${OPTARG}"
  if [ -z "${OPTARG}" ] && [ "${default}" = "0" ]; then
    value="1"
  fi

  eval "${varname}=\"${value}\""
  echo "cli arg ${varname} = ($default) -> ${!varname}"
done

shift $((OPTIND-1))

[ "$1" = "--" ] && shift


### Switches (like -d for debugmode, -h for showing helppage)
#####################################################################

# debug mode
if [ "${arg_d}" = "1" ]; then
  set -o xtrace
fi

# testing mode
if [ "${arg_t}" = "1" ]; then
  TEST_MODE=1
else
  TEST_MODE=0
fi

# Redirect output to log file
if [ "${arg_l}" = "1" ]; then
  exec 2>> "$LOG_FILE"
fi

# help mode
if [ "${arg_h}" = "1" ]; then
  # Help exists with code 1
  help "Help using ${0}"
fi

### Runtime
#####################################################################

# Exit on error. Append ||true if you expect an error.
# set -e is safer than #!/bin/bash -e because that is neutralised if
# someone runs your script like `bash yourscript.sh`
set -o errexit
set -o nounset

# Bash will remember & return the highest exitcode in a chain of pipes.
# This way you can catch the error in case mysqldump fails in `mysqldump |gzip`
set -o pipefail

### Start the Program ###
main
