require 'bintray_deploy'

module  Opsk
  class Deploy < Thor::Group
    include Thorable, Thor::Actions

    argument :repo, :type => :string, :desc => 'bintray repo'

    desc 'Deploy sandbox into bintray.com'

    def upload
	pkg = Opsk::Package.new
	if(File.exists?(pkg.artifact_path))
        BintrayDeploy::Actions.new.deploy(repo, "#{pkg.meta.name}-sandbox", pkg.meta.version, pkg.artifact_path)
	else
	  say('package is missing please run opsk package first')
	end
    end

  end

end

