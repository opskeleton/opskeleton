


module  Opsk
  class DeployS3 < Thor::Group
    include Thorable, Thor::Actions

    argument :bucket, :type => :string, :desc => 'bucket'
    argument :path, :type => :string, :desc => 'path'

    desc 'Deploy sandbox into an s3 bucket' 

    def validate
	check_root
    end

    def load_conf
	require 'configuration'
	conf = "#{ENV['HOME']}/.configuration.rb"
	raise "#{conf} not found, please create a conf file with a s3 section" unless File.exists?(conf)
	require conf   	
    end

    def upload
	require 'aws-sdk'
	pkg = Opsk::Package.new
	tar =  "#{pkg.artifact_path}.tar.gz"
	base = File.basename(tar)
	if(File.exists?(tar))
	  begin
	    conf = Configuration.for 's3'
	    Aws.config.update({
		region: conf.region,
		credentials: Aws::Credentials.new(conf.access_key, conf.secret_key),
	    })
	    s3 = Aws::S3::Resource.new
	    s3.bucket(bucket).object("#{path}/#{base}").upload_file(tar)
	    say("deployed #{base} to #{bucket}/#{path}/#{base}")
	  rescue Exception => e
	    say("failed to deploy due to #{e}")
	  end
	else
	  say('package is missing please run opsk package first')
	  exit(1)
	end
    end

  end

end

