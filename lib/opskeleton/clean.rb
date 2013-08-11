module  Opsk
  class Clean < Thor::Group
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

    def create_pkg
	empty_directory('pkg')
	empty_directory(artifact)
    end

  end

end

