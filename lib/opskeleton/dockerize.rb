module Opsk 
  class Dockerize < Thor::Group
    include Thorable, Thor::Actions

    argument :from, :type => :string, :desc => 'which source image to use'
    argument :os_type, :type=> :string, :desc => 'Ubuntu/Centos'


    desc 'Creates a docker image using the current opsk sandbox'

    def create_dockerfile
	template("templates/#{type_of}/#{os_type}_docker.erb", 'Dockerfile')
    end

  end
end
