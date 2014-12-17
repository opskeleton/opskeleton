module Opsk 
  class GenerateChef < Thor::Group
    include Thorable, Thor::Actions

    argument :name, :type => :string, :desc => 'project name'
    argument :box, :type => :string, :desc => 'Vagrant box type'
    class_option :box_url, :type=> :string, :desc => 'vagrant box url'
    class_option :os_type, :type=> :string, :desc => 'Operating system type (bsd/linux)'
    class_option :bench_enable, :type=> :boolean, :desc => 'Control if to enable benchmarking support'

    desc 'Generate a Vagrant, Chef librarian and fpm project'

    def path 
	"#{name}-sandbox"
    end

    def create_vagrant_file
	empty_directory(path)
	template('templates/chef/vagrant.erb', "#{path}/Vagrantfile")
    end

    def create_gemfile
	template('templates/chef/Gemfile.erb', "#{path}/Gemfile")
    end

    def create_rakefile
	template('templates/chef/Rakefile.erb', "#{path}/Rakefile")
    end

    def create_version
	template('templates/chef/opsk.yaml', "#{path}/opsk.yaml")
    end

    def create_rvmrc
	remove_file("#{path}/.rvmrc")
	template('templates/ruby-gemset.erb', "#{path}/.ruby-gemset")
	template('templates/ruby-version.erb', "#{path}/.ruby-version")
    end

    def create_environment
	empty_directory("#{path}/environments")
	copy_file('templates/chef/environments/dev.rb', "#{path}/environments/dev.rb")
    end

    def create_chef_base
	empty_directory("#{path}/static-cookbooks/")
	copy_file('templates/chef/Cheffile', "#{path}/Cheffile")
	empty_directory("#{path}/roles/")
	template('templates/chef/roles.erb', "#{path}/roles/#{name}.rb")
	template('templates/chef/dna.json.erb', "#{path}/dna.json")
	copy_file('templates/chef/run.sh', "#{path}/run.sh")
	copy_file('templates/chef/solo.rb', "#{path}/solo.rb")
	copy_file('templates/chef/boot.sh', "#{path}/boot.sh")
	chmod("#{path}/run.sh", 0755)
	chmod("#{path}/boot.sh", 0755)
    end

    def readme
	template('templates/README.erb', "#{path}/README.md")
	copy_file('templates/LICENSE-2.0.txt',"#{path}/LICENSE-2.0.txt")
    end

    def travis
	template('templates/parent/travis.erb', "#{path}/.travis.yml")
    end

    def server_spec
	empty_directory("#{path}/spec")
	template('templates/parent/spec/spec_helper.erb', "#{path}/spec/spec_helper.rb")
	directory('templates/parent/spec/default', "#{path}/spec/default")
    end

    def git
	if(!File.exists?("#{path}/.git"))
	  copy_file('templates/gitignore', "#{path}/.gitignore")
	  inside(path) do
	    run('git init .')
	    run('git add -A')
	    run("git commit -m 'initial sandbox import'")
	  end
	end
    end

  end
end
