require 'yaml'

# For working with the output of `system_profiler SPStorageDataType`
class MacStorage
  attr_reader :volumes

  CURR_DIR = File.expand_path File.dirname(__FILE__)

  def initialize(options = {})
    if options[:file]
      storage_data = options[:file]
    else
      system "system_profiler SPStorageDataType > #{CURR_DIR}/storage_data.txt"
      storage_data = "#{CURR_DIR}/storage_data.txt"
    end

    storage_yml = "#{CURR_DIR}/storage_data.yml"
    File.open(storage_yml, 'w') do |file|
      file.puts yamlize(storage_data)
    end

    @volumes = YAML.load_file storage_yml
    system "rm #{storage_yml} #{storage_data}"
  end

  def internal_volumes
    volumes.select do |volume|
      (volume['Physical Volumes'] &&
      volume['Physical Volumes'].all? do |_, disk_properties|
        disk_properties['Internal']
      end) || (volume['Physical Drive'] && volume['Physical Drive']['Internal'])
    end
  end

  def print_storage_report
    internal_volumes.each do |volume|
      puts "#{volume['Volume Name']}: " \
      "#{strip_bytes(volume['Available'])} " \
      "/ #{strip_bytes(volume['Capacity'])}" \
      "#{' [BOOT]' if volume['Mount Point'] == '/'}"
    end
    nil
  end

  # Takes the output of a `system_profiler SPStorageDataType` & makes a few
  # tweaks to turn it into a YAML readable format.
  def yamlize(storage_file)
    IO.readlines(storage_file).map.with_index do |line, index|
      # Insert a --- at the top of the file
      if index == 0
        '---'

      # In the sys profiler output, only volume names start with 4 spaces.
      # This searches for those lines and converts them to the start of a YAML
      # array, labels the volume name with the key 'Volume Name', and removes
      # trailing colon after the volume name - http://rubular.com/r/Nyzgsok34L
      elsif line =~ /^\s{4}\S+.*$/
        line.delete(':').gsub('    ', '- Volume Name: ')

      # Removes 4 leading spaces from any line that begins with > 6 spaces
      elsif line =~ /^\s{6,}\S+.*$/
        line[4..-1]

      # Only serves purpose of maintaining blank lines
      else
        line
      end
    end
  end

  private

  def strip_bytes(storage_string)
    storage_string.gsub(/\s\(.+\)$/, '')
  end
end
