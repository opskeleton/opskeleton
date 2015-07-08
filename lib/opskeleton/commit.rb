module  Opsk
  class Commit < Thor::Group
    include Thorable, Thor::Actions

    class_option :message, :type=> :string, :desc => 'optional commit message'

    def validate
	check_root
    end

    def commit
	Dir["modules/*"].reject{|o| not File.directory?(o)}.each do |d|
	  g = Git.init(d)
	  if g.status.changed.keys.length > 0
	   if message
	     g.commit_all(message) 
	   else 
	     puts 'please provide commit message'
	     g.commit_all(gets) 
	   end
	  end
	end
    end

  end
end
