module  Opsk
  class Package < Thor::Group
    include Thorable, Thor::Actions

    argument :version, :type => :string, :desc => "package version"

    # def create_build
	# empty_directory('build')
	# directory ".", "build"
    # end

    def create_pkg
	puts "here"
	empty_directory('pkg')
    end

    def create_scripts
	empty_directory('scripts')
	%w(lookup.sh run.sh).each  do |s|
	  template("templates/scripts/#{s}", "scripts/#{s}")
	  chmod("scripts/#{s}", 0755)
	end

    end

    def package
	name = File.basename(Dir.getwd)
	ignored = IO.readlines('.gitignore').map(&:chomp)
	ignored.delete('modules')
	excludes = ignored.map{|f| "'#{f}'"}.join(" --exclude=") << ' --exclude-backups --exclude-vcs --exclude=pkg'
	run("tar --exclude=#{excludes} -czf pkg/#{name}.tar.gz ../#{name} > /dev/null", :verbose => false)
    end

  end

end

