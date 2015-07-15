

module  Opsk
  class CommitGit
    def initialize(d,options,thor)
	@g = Git.init(d)
	@options = options
	@thor = thor
    end

    def changed?
	@g.status.changed.keys.length > 0
    end

    def report
	%i(changed added untracked).each do |state|
	  @thor.say "#{state} files:\n\n"
	  @g.status.send(state).each do |k,v|
	    @thor.say "- #{k}"
	  end
	  @thor.say "\n"
	end
    end

    def master_commit(d)
	resp = @thor.yes? "Commit the changes under #{d}? (y/n)" unless @options['all']
	if(@options['all'] or resp)
	  @g.checkout('master')
	  if @options['message']
	    @g.commit_all(@options['message']) 
	  else 
	    @thor.say 'Commit message:'
	    @g.commit_all(STDIN.gets.chomp) 
	  end
	end

    end
  end

  class Commit < Thor::Group
    include Thorable, Thor::Actions

    class_option :message, :type=> :string, :desc => 'optional commit message'
    class_option :all, :type=> :boolean, :desc => 'commit all', :default => false

    def validate
	check_root
    end


    def commit
	Dir["modules/*"].reject{|o| not File.directory?(o)}.each do |d|
	  if File.exists?("#{d}/.git")
	    begin
		cg = Opsk::CommitGit.new(d,options,self)
		if cg.changed?
		  say "Listing changes for #{d}:\n\n"
		  cg.report
		  cg.master_commit(d)
		end
	    rescue => e 
		say "Failed to commit #{d} due to #{e}"
	    end
	  end
	end
    end

  end
end
