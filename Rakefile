# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require(File.join(File.dirname(__FILE__), 'config', 'boot'))

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require(File.join(File.dirname(__FILE__), 'lib', 'myconfig'))

require 'tasks/rails'

myconfig = Myconfig.instance
myconfig.load_config()

namespace 'server' do
  namespace 'devel' do
    desc 'Start up devel mongrel servers.'
    task :start do
      (0..myconfig.mongrel_number_processes-1).each do |i| 
        server_start(i+1, 'development', myconfig.mongrel_start_port + i)
      end
    end

    desc 'Stop up devel mongrel servers.'
    task :stop do
      (0..myconfig.mongrel_number_processes-1).each do |i| 
        mongrel_stop(i+1)
      end
    end
    
    desc 'Get pids of devel mongrel servers'
    task :status do
      (1..myconfig.mongrel_number_processes).each do |id|
        puts "mongrel-#{id}: " + mongrel_process_running?(id).to_s
      end
      system('ps auxwww|grep mongrel|grep -v grep|grep -v rake')
    end
    
    desc 'Nagios devel mongrel check'
    task :nagios do
      msg = ''
      error_msg = ''
      status_bool = true
      (1..myconfig.mongrel_number_processes).each do |id|
        if (mongrel_process_running?(id))
          msg += "mongrel-#{id} running, "
        else
          error_msg += "mongrel-#{id} down, "
        end
      end
      if (error_msg.length > 0)
        puts error_msg
        exit 2
      else
        puts msg
        exit 0
      end
    end
  end
  
end


def mongrel_process_running?(id)
  begin
    pid = IO.read("#{RAILS_ROOT}/log/mongrel-#{id}.pid")
  rescue
    #puts "pid file does not exist. #{$!}"
    return false
  end
  
  begin
    Process.getpgid(pid.to_i)
  rescue
    #puts "pid #{pid} does not exist. #{$!}"
    return false
  end
  
  return true
end

def server_start(id, env, port)
  mkdir 'log' if !File.directory?('log')
  cmd = "ruby  start -d -p #{port} -e #{env} -P log/mongrel-#{id}.pid"
  puts cmd
  system(cmd)
end

def mongrel_stop(id)
  cmd = "mongrel_rails stop -P log/mongrel-#{id}.pid"
  puts cmd
  system(cmd)
end
