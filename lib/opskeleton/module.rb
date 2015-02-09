module Opsk 
  class Module < Thor::Group
    include Thorable, Thor::Actions

    argument :name, :type => :string, :desc => 'module name'

    desc 'Generate an rspec enabled Puppet module'

    def validate
	check_root
    end


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
      rakefile = "static-modules/#{name}/Rakefile"
      remove_file(rakefile)
	template('templates/module/Rakefile.erb',rakefile)
    end

   def spec_helper
     spec_helper = "static-modules/#{name}/spec/spec_helper.rb"
     remove_file(spec_helper)
     template('templates/module/spec_helper.rb',spec_helper)
   end
  end
end
