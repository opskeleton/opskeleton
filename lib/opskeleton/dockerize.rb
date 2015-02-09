module Opsk 
  class Dockerize < Thor::Group
    include Thorable, Thor::Actions

    argument :from, :type => :string, :desc => 'Which source image to use'
    argument :os_type, :type=> :string, :desc => 'Flavor of container Ubuntu/Centos'


    desc 'Creates a docker image using the current opsk sandbox'

    def validate
	check_root
    end


    def create_dockerfiles
	empty_directory('dockerfiles')
	machines.each {|m|
	  empty_directory("dockerfiles/#{m}/")
	  template("templates/#{type_of}/docker/#{os_type}_docker.erb", "dockerfiles/#{m}/Dockerfile")
	}
    end

    def fig
	template("templates/fig.yml.erb", 'fig.yml')
    end

  end
end
