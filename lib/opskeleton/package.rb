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
	unless(File.exists?("#{artifact_path}/manifests/site.pp"))
	  template('templates/puppet/site.erb', "#{artifact_path}/manifests/site.pp")
	end
    end

    def scripts
	type = :puppet if File.exists?("#{artifact_path}/Puppetfile")
	type = :chef if File.exists?("#{artifact_path}/Cheffile")
	raise Exception.new('not matching provisoner type found') if type.nil?
	empty_directory("#{artifact_path}/scripts")
      files = {:puppet => %w(lookup.rb run.sh) , :chef => [] }
	files[type].each  do |s|
	  unless(File.exists?("#{artifact_path}/scripts/#{s}"))
	    template("templates/#{type}/scripts/#{s}", "#{artifact_path}/scripts/#{s}")
	    chmod("#{artifact_path}/scripts/#{s}", 0755)
	  end
	end
    end

    def create_pkg
	empty_directory('pkg')
    end

    def package
	ignored = IO.readlines('.gitignore').map(&:chomp)
	ignored.delete('modules')
	ignored.delete('cookbooks')
	excludes = ignored.map{|f| "'#{f}'"}.join(" --exclude=") << ' --exclude-backups --exclude-vcs --exclude=pkg'
	tar = "#{artifact}.tar.gz"
	input = artifact
	inside('pkg') do
	  run("tar --exclude=#{excludes} -czf #{tar} #{input} >> /dev/null" , :verbose => false) 
	end
    end

  end

end

