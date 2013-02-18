module Opsk 
  class Generate < Thor::Group
    include Thorable, Thor::Actions

    argument :name, :type => :string, :desc => "project name"
    argument :box, :type => :string, :desc => "Vagrant box type"

    desc "Generate a Vagrant, Puppet librarian and fpm project"

    def path 
	"#{name}-sandbox"
    end

    def create_vagrant_file
	empty_directory(path)
	template('templates/vagrant.erb', "#{path}/Vagrantfile")
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
	template('templates/rvmrc.erb', "#{path}/.rvmrc")
    end

    def create_puppet_base
	empty_directory("#{path}/static-modules/")
	empty_directory("#{path}/manifests/")
	template('templates/puppetfile.erb', "#{path}/Puppetfile")
	template('templates/default.erb', "#{path}/manifests/default.pp")
	copy_file('templates/run.sh', "#{path}/run.sh")
	chmod("#{path}/run.sh", 0755)
    end

    def create_heira
	hieradata = "#{path}/hieradata/"
	empty_directory(hieradata)
	%w(common virtualbox physical).each do |env|
	  copy_file('templates/clean.yaml', "#{hieradata}/#{env}.yaml")
	end

	copy_file('templates/hiera.yaml', "#{path}/hiera.yaml")
    end

    def readme
	template('templates/README.erb', "#{path}/README.md")
	copy_file('templates/LICENSE-2.0.txt',"#{path}/LICENSE-2.0.txt")
    end

    def git
	copy_file('templates/gitignore', "#{path}/.gitignore")
	inside(path) do
	  run('git init .')
	  run('git add -A')
	  run("git commit -m 'initial sandbox import'")
	end
    end
  end
end
