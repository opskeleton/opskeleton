module  Opsk
  class Package < Thor::Group
    include Thorable, Thor::Actions

    def meta 
	 OpenStruct.new(YAML.load_file('opsk.yml'))
    end

    def name 
     	File.basename(Dir.getwd)
    end

    def artifact
    	"#{name}-#{meta.version}"
    end

    def create_build
	empty_directory(artifact)
	path = Dir.getwd
	directory path , artifact , :verbose => false
	empty_directory("#{artifact}/scripts")
	%w(lookup.sh run.sh).each  do |s|
	  template("templates/scripts/#{s}", "#{artifact}/scripts/#{s}")
	  chmod("#{artifact}/scripts/#{s}", 0755)
	end
	template('templates/puppet/site.erb', "#{artifact}/manifests/site.pp")
    end

    def create_pkg
	empty_directory('pkg')
    end

    def package
	ignored = IO.readlines('.gitignore').map(&:chomp)
	ignored.delete('modules')
	excludes = ignored.map{|f| "'#{f}'"}.join(" --exclude=") << ' --exclude-backups --exclude-vcs --exclude=pkg'
	run("tar --exclude=#{excludes} -czf pkg/#{artifact}.tar.gz #{artifact} > /dev/null", :verbose => false)
    end

  end

end

