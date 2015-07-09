
def report(g)
  %i(changed added untracked).each do |state|
    say "#{state} files:\n\n"
    g.status.send(state).each do |k,v|
	say "- #{k}"
    end
    say "\n"
  end
end

module  Opsk
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
	    g = Git.init(d)
	    if g.status.changed.keys.length > 0
		say "Listing changes for #{d}:\n\n"
		report(g)
		resp = yes? "Commit the changes under #{d}? (y/n)\n\n" unless options['all']
		if(options['all'] or resp)
		  g.checkout('master')
		  if options['message']
		    g.commit_all(options['message']) 
		  else 
		    say 'Please provide commit message:\n'
		    g.commit_all(STDIN.gets.chomp) 
		  end
		end
	    end
	  end
	end
    end


  end
end
