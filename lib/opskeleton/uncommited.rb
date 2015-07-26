

module  Opsk
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
