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
    end

  end

end

