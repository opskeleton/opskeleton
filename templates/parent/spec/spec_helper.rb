require 'serverspec'
require 'pathname'
require 'net/ssh'

include SpecInfra::Helper::Ssh
include SpecInfra::Helper::DetectOS

def run(cmd)
  unless(system(cmd, out: $stdout, err: :out))
    puts 'Failed to setup vagrant machine'
    exit 1
  end
end

RSpec.configure do |c|
  c.before :suite do
    c.host  = ENV['TARGET_HOST']
    c.ssh.close if c.ssh
    options = Net::SSH::Config.for(c.host)
    if(!ENV['LOCAL'])
	run("vagrant destroy #{c.host} -f")
	run("vagrant up #{c.host}")
      config = `vagrant ssh-config #{c.host}`
      sshhost =  sshuser = ''
      if config != ''
        config.each_line do |line|
          if match = /HostName (.*)/.match(line)
            sshhost = match[1]
          elsif  match = /User (.*)/.match(line)
            sshuser = match[1]
          elsif match = /IdentityFile (.*)/.match(line)
            options[:keys] =  [match[1].gsub(/"/,'')]
          elsif match = /Port (.*)/.match(line)
            options[:port] = match[1]
          end
        end
      end
    else
      sshhost = 'localhost' 
      sshuser = 'vagrant' 
    end
    c.ssh = Net::SSH.start(sshhost, sshuser, options)
  end

  c.after :suite do
    c.host  = ENV['TARGET_HOST']
    run("vagrant destroy #{c.host} -f")
  end
end
