
module  Opsk
  class Deploy < Thor::Group
    include Thorable, Thor::Actions

    argument :repo, :type => :string, :desc => 'bintray repo'

    desc 'Deploy sandbox into bintray.com'

    def validate
	check_root
    end


    def upload
	require 'bintray_deploy'
	pkg = Opsk::Package.new
	tar =  "#{pkg.artifact_path}.tar.gz"
	base = File.basename(tar)
	if(File.exists?(tar))
	  begin
	    BintrayDeploy::Actions.new.deploy(repo, "#{pkg.meta.name}-sandbox", pkg.meta.version, tar)
	    say("deployed #{base} to http://dl.bintray.com/#{C.user}/#{repo}/#{base}")
	  rescue Exception => e
          say("failed to deploy due to #{e}")
	  end
	else
	  say('package is missing please run opsk package first')
	end
    end

  end

end

