module Opsk 
  class Module < Thor::Group
    include Thorable, Thor::Actions

    argument :name, :type => :string, :desc => 'module name'

    desc 'Generate an rspec enabled Puppet module'

    def create_module
	inside('static-modules') do
	  run("puppet module generate puppet-#{name}")
	  run("mv puppet-#{name} #{name}")
	end
    end

    def rspec
     inside("static-modules/#{name}/") do
	 run("rspec-puppet-init")
     end
    end

    def create_rakefile
	template('templates/module/Rakefile', "static-modules/#{name}")
    end

  end
end
