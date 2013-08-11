module  Opsk
  class Clean < Thor::Group
    include Thorable, Thor::Actions

    def meta 
	 OpenStruct.new(YAML.load_file('opsk.yml'))
    end

    def name 
     	File.basename(Dir.getwd)
    end

    def cleanup
	remove_dir('pkg')
	remove_dir("#{name}-#{meta.version}")
    end

  end

end

