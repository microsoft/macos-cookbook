#!/usr/bin/env ruby

require File.expand_path File.dirname(__FILE__) + '/storage.rb'

volumes = MacStorage.new

if ARGV.first == '--report'
  volumes.print_storage_report
else
  puts volumes.volumes
end
