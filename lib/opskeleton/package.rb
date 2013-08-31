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

    def artifact_path
    	"pkg/#{name}-#{meta.version}"
    end

    def create_build
	empty_directory(artifact_path)
      path = Dir.getwd
	directory path, artifact_path, :verbose => false
	empty_directory("#{artifact_path}/scripts")
	%w(lookup.rb run.sh).each  do |s|
	  template("templates/scripts/#{s}", "#{artifact_path}/scripts/#{s}")
	  chmod("#{artifact_path}/scripts/#{s}", 0755)
	end
	template('templates/puppet/site.erb', "#{artifact_path}/manifests/site.pp")
    end

    def create_pkg
	empty_directory('pkg')
    end

    def package
	ignored = IO.readlines('.gitignore').map(&:chomp)
	ignored.delete('modules')
	excludes = ignored.map{|f| "'#{f}'"}.join(" --exclude=") << ' --exclude-backups --exclude-vcs --exclude=pkg'
	tar = "#{artifact}.tar.gz"
	input = artifact
	inside('pkg') do
	  run("tar --exclude=#{excludes} -czf #{tar} #{input}") 
	end
    end

  end

end

