
require 'configuration'
conf = "#{ENV['HOME']}/.configuration.rb"
raise "#{conf} not found, please create a conf file with a scp section" unless File.exists?(conf)
require conf

module  Opsk
  class DeployScp < Thor::Group
    include Thorable, Thor::Actions

    argument :dest, :type => :string, :desc => 'dest'

    desc 'Deploy sandbox into a remote ssh server'

    def validate
	check_root
    end


    def upload
	require 'net/scp'
	pkg = Opsk::Package.new
	tar =  "#{pkg.artifact_path}.tar.gz"
	base = File.basename(tar)
	if(File.exists?(tar))
	  begin
	    conf = Configuration.for('scp').send(dest.to_sym)
          port = conf.port || '22'
	    Net::SSH.start(conf.host, conf.user, :port => port) do |session|
            session.scp.upload!(tar, conf.dest)
          end
	    say("deployed #{base} to #{conf.user}@#{conf.host}:#{conf.dest}")
	  rescue Exception => e
	    say("failed to deploy due to #{e}")
	  end
	else
	  say('package is missing please run opsk package first')
	end
    end

  end

end

