

module  Opsk
  class Push < Thor::Group
    include Thorable, Thor::Actions

    class_option :protocol, :type=> :string, :desc => 'remote ssh protocol (https or ssh)', :default => 'ssh'
    class_option :dry, :type=> :boolean, :desc => 'dry mode', :default => false
    class_option :user, :type=> :string, :desc => 'ssh protocol user'
    class_option :port, :type=> :string, :desc => 'remote repo port'
    class_option :all, :type=> :boolean, :desc => 'push all without asking', :default => false

    def validate
	check_root
    end


    def push
	Dir["modules/*"].reject{|o| not File.directory?(o)}.each do |d|
	  begin
	    if File.exists?("#{d}/.git")
		git = Opsk::Git.new(d,self)
		git.add_writable(options)
		if !options['dry'] and git.local_ahead?
		  resp = yes?("Push #{d}? (y/n)") unless options['all']
		  if(options['all'] or resp)
		    say "pushing #{d} .."
		    git.push('writable') 
		    git.pull
		  end
		end
	    end
	  rescue => e
	    say "Failed to push #{d} due to #{e}"
	  end
	end
    end


  end
end
