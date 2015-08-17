module  Opsk
  class Update < Thor::Group
    include Thorable, Thor::Actions
    class_option :module, :type=> :string, :desc => 'module to update'

    def validate
	check_root
    end


    def meta 
	OpenStruct.new(YAML.load_file('opsk.yaml'))
    end

    def name 
	File.basename(Dir.getwd)
    end

    def update
	inside('vendor') do
	  Dir["./*"].reject{|o| not File.directory?(o)}.each do |d|
	    resp = yes?("Update #{d}? (y/n)") unless options['all']
	    if File.exists?("#{d}/Puppetfile") and resp
		run("librarian-puppet update #{options['module']}")
	    end
	    resp = yes?("Commit Puppetfile.lock#{d}? (y/n)") unless options['all']
	    if resp
		git = Opsk::Git.new(d,self)
		git.add("#{d}/Puppetfile.lock")
		git.commit("Opsk: updating #{options['module']}")
		git.push
	    end
	  end
	end
    end

  end

end

