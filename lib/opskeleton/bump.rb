module  Opsk
  class Bump < Thor::Group
    include Thorable, Thor::Actions

    argument :version, :type => :string, :desc => 'new version number'

    def meta 
	 OpenStruct.new(YAML.load_file('opsk.yaml'))
    end

    def bump
      new_meta = meta
	new_meta.version = version
	File.open('opsk.yaml', 'w') {|f| f.write(new_meta.marshal_dump.to_yaml)}
    end

  end

end

