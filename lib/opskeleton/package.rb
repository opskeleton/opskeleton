module  Opsk
  class Package < Thor::Group
    include Thorable, Thor::Actions

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
	meta.includes.each {|f| 
	  if(File.directory?("#{path}/#{f}"))
	    directory "#{path}/#{f}", "#{artifact_path}/#{f}", :verbose => false
	  elsif(File.exists?("#{path}/#{f}"))
	    copy_file "#{path}/#{f}", "#{artifact_path}/#{f}"
	  else
	    raise Exception.new("#{f} not found please validate opks.yaml includes section")
	  end
	}
	unless(File.exists?("#{artifact_path}/manifests/site.pp"))
	  template('templates/puppet/site.erb', "#{artifact_path}/manifests/site.pp")
	end
    end

    def scripts
	empty_directory("#{artifact_path}/scripts")
	files = {:puppet => %w(lookup.rb run.sh) , :chef => [] }
	files[type_of].each  do |s|
	  unless(File.exists?("#{artifact_path}/scripts/#{s}"))
	    template("templates/#{type_of}/scripts/#{s}", "#{artifact_path}/scripts/#{s}")
	    chmod("#{artifact_path}/scripts/#{s}", 0755)
	  end
	end
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

