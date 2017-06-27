resource_name :systemsetup
default_action :run

BASE_COMMAND = '/usr/sbin/systemsetup'.freeze

property :get, Array
property :set, Hash

action :run do
  if new_resource.get
    get.each do |flag|
      execute BASE_COMMAND do
        command "#{BASE_COMMAND} -get#{flag}"
        live_stream true
      end
    end
  end


  if new_resource.set
    set.each do |flag, setting|
      execute BASE_COMMAND do
        command "#{BASE_COMMAND} -set#{flag} #{setting}"
      end
    end
  end
end
