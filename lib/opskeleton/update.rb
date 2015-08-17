module  Opsk
  class Update < Thor::Group
    include Thorable, Thor::Actions
    class_option :module, :type=> :string, :desc => 'module to update'

    def update
	Dir["./*"].reject{|o| not File.directory?(o)}.each do |d|
	  resp = yes?("Update #{d}? (y/n)") unless options['all']
	  if File.exists?("#{d}/Puppetfile") and resp
	    inside(d) do
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

