require 'serverspec'
require 'pathname'
require 'net/ssh'

include SpecInfra::Helper::Ssh
include SpecInfra::Helper::DetectOS

RSpec.configure do |c|
  c.before :all do
    c.host  = ENV['TARGET_HOST']
    c.ssh.close if c.ssh
    options = Net::SSH::Config.for(c.host)
    user    = 'vagrant'
    vagrant_up = `vagrant up #{c.host}`
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
    
    c.ssh = Net::SSH.start(sshhost, sshuser, options)
  end
end
