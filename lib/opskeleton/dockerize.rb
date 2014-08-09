module Opsk 
  class Dockerize < Thor::Group
    include Thorable, Thor::Actions

    desc 'Creates a docker image using the current opsk sandbox'

    def create_dockerfile
	empty_directory('docker')
	template("templates/#{type_of}/docker.erb", "docker/Dockerfile")
    end

  end
end
