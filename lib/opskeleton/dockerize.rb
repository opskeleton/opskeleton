module Opsk 
  class Dockerize < Thor::Group
    include Thorable, Thor::Actions

    argument :from, :type => :string, :desc => 'Which source image to use'
    argument :os_type, :type=> :string, :desc => 'Flavor of container Ubuntu/Centos'


    desc 'Creates a docker image using the current opsk sandbox'

    def create_dockerfile
	template("templates/#{type_of}/docker/#{os_type}_docker.erb", 'Dockerfile')
    end

    def docker_build
	template("templates/docker_build.erb", 'docker_build.sh')
	chmod('docker_build.sh', 0755)
    end

  end
end
