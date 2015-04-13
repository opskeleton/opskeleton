
require 'configuration'
conf = "#{ENV['HOME']}/.configuration.rb"
raise "#{conf} not found, please create a conf file with a s3 section" unless File.exists?(conf)
require conf

module  Opsk
  class DeployS3 < Thor::Group
    include Thorable, Thor::Actions

    argument :bucket, :type => :string, :desc => 'bucket'
    argument :key, :type => :string, :desc => 'key'

    desc 'Deploy sandbox into an s3 bucket' 

    def validate
	check_root
    end


    def upload
	require 'aws-sdk'
	pkg = Opsk::Package.new
	tar =  "#{pkg.artifact_path}.tar.gz"
	base = File.basename(tar)
	if(File.exists?(tar))
	  begin
	    conf = Configuration.for 's3'
	    s3 = AWS::S3.new(:access_key_id => conf.access_key, :secret_access_key => conf.secret_key)
	    s3.buckets[bucket].objects[key].write(:file => tar)
	    say("deployed #{base} to #{bucket}/#{key}")
	  rescue Exception => e
          say("failed to deploy due to #{e}")
	  end
	else
	  say('package is missing please run opsk package first')
	end
    end

  end

end

