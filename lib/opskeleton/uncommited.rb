

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

  class Uncommited < Thor::Group
    include Thorable, Thor::Actions

    def validate
	check_root
    end


    def uncommited
	Dir["modules/*"].reject{|o| not File.directory?(o)}.each do |d|
	  if File.exists?("#{d}/.git")
	    begin
		cg = Opsk::Git.new(d,self)
		if cg.changed?
		  say "Listing changes for #{d}:\n\n"
		  cg.report
		end
	    rescue => e 
		say "Failed to check uncommited under #{d} due to #{e}"
	    end
	  end
	end
    end
  end
end
