

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
	    begin
		git = Opsk::Git.new(d,self)
		if git.changed?
		  say "Listing changes for #{d}:\n\n"
		  git.report
		  git.master_commit(d,options)
		end
	    rescue => e 
		say "Failed to commit #{d} due to #{e}"
	    end
	  end
	end
    end

  end
end
