module  Opsk
  class Clean < Thor::Group
    include Thorable, Thor::Actions

    def meta 
	 OpenStruct.new(YAML.load_file('opsk.yaml'))
    end

    def name 
     	File.basename(Dir.getwd)
    end

    def cleanup
	remove_dir('pkg')
	if(File.exists?('dockerfiles'))
	  images = Dir['dockerfiles/*'].select{|file| File.ftype(file) == 'directory'}
	  images.each do |path|
	    if(File.ftype(path) == 'directory')
		remove_dir("#{path}/pkg")
	    end
	  end
	end
    end

  end

end

