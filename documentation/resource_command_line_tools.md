# command_line_tools

The [``command_line_tools``](https://github.com/Microsoft/macos-cookbook/blob/master/resources/command_line_tools.rb) resource manages the state of a single Xcode Command Line Tools installation, and will only install the latest version for the current running version of macOS.

## Syntax

```ruby
command_line_tools 'name' do
  compile_time true, false # defaults to false if not specified
  action Symbol # defaults to :install if not specified
end
```

where:

- ``command_line_tools`` is the resource.
- ``name`` is the name given to the resource block.
- ``action`` identifies which steps the chef-client will take to bring the node into the desired state.
- ``compile_time`` is the property available to this resource.

## Actions

The ``command_line_tools`` resource has the following actions:

``:install``

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Default. Install Command Line Tools from Apple. Takes no action if any version has previously been installed on the system. 

``:upgrade``

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Check for an updated version of Command Line Tools and install them if available. 

``:nothing``

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;This resource block does not act unless notified by another resource to take action. Once notified, this resource block either runs immediately or is queued up to run at the end of the Chef Client run.

## Properties

``compile_time``

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;**Ruby Type:** true, false | **Default Value:** ``false``

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Install the Xcode Command Line Tools at compile time.

## Examples

### Install Xcode Command Line Tools

```ruby
command_line_tools 'random_name'
```

If running **macOS 10.14.2**, it will install **'Command Line Tools (macOS Mojave version 10.14) for Xcode-10.14'** via the `softwareupdate` utility.
