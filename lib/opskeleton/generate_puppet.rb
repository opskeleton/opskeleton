module Opsk 
  class GeneratePuppet < Thor::Group
    include Thorable, Thor::Actions

    argument :name, :type => :string, :desc => 'project name'
    argument :box, :type => :string, :desc => 'Vagrant box type'
    class_option :box_url, :type=> :string, :desc => 'vagrant box url'
    class_option :os_type, :type=> :string, :desc => 'Operating system type (bsd/linux)'

    desc 'Generate a Vagrant, Puppet librarian and fpm project'

    def path 
	"#{name}-sandbox"
    end

    def create_vagrant_file
	empty_directory(path)
	case options['os_type'] 
	when 'bsd'
	  template('templates/vagrant_bsd.erb', "#{path}/Vagrantfile")
	else
	  template('templates/vagrant.erb', "#{path}/Vagrantfile")
	end
    end

    def create_gemfile
	copy_file('templates/gemfile', "#{path}/Gemfile")
    end

    def create_rakefile
	copy_file('templates/Rakefile', "#{path}/Rakefile")
    end

    def create_version
	template('templates/opsk.yml', "#{path}/opsk.yml")
    end

    def create_rvmrc
	remove_file("#{path}/.rvmrc")
	template('templates/ruby-gemset.erb', "#{path}/.ruby-gemset")
	template('templates/ruby-version.erb', "#{path}/.ruby-version")
    end

    def create_puppet_base
	empty_directory("#{path}/static-modules/")
	empty_directory("#{path}/manifests/")
	template('templates/puppetfile.erb', "#{path}/Puppetfile")
	template('templates/puppet/default.erb', "#{path}/manifests/default.pp")
	copy_file('templates/puppet/run.sh', "#{path}/run.sh")
	copy_file('templates/puppet/boot.sh', "#{path}/boot.sh")
	chmod("#{path}/run.sh", 0755)
	chmod("#{path}/boot.sh", 0755)
    end

    def create_heira
	hieradata = "#{path}/hieradata/"
	empty_directory(hieradata)
	%w(common virtualbox physical).each do |env|
	  copy_file('templates/clean.yaml', "#{hieradata}/#{env}.yaml")
	end

	copy_file('templates/hiera.yaml', "#{path}/hiera.yaml")
	copy_file('templates/hiera_vagrant.yaml', "#{path}/hiera_vagrant.yaml")
    end

    def readme
	template('templates/README.erb', "#{path}/README.md")
	copy_file('templates/LICENSE-2.0.txt',"#{path}/LICENSE-2.0.txt")
    end

    def travis
	template('templates/parent/travis.erb', "#{path}/.travis.yml")
    end

    def server_spec
	directory('templates/parent/spec', "#{path}/spec")
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
