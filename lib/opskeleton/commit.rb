module  Opsk
  class Commit < Thor::Group
    include Thorable, Thor::Actions

    class_option :message, :type=> :string, :desc => 'optional commit message'

    def validate
	check_root
    end

    def commit
	Dir["modules/*"].reject{|o| not File.directory?(o)}.each do |d|
	  if File.exists?("#{d}/.git")
	    g = Git.init(d)
	    if g.status.changed.keys.length > 0
		puts "Changes found for #{d}:\n\n"
		puts "#{g.show}\n"
		g.checkout('master')
		if options['message']
		  g.commit_all(options['message']) 
		else 
		  puts 'Please provide commit message:'
		  g.commit_all(STDIN.gets.chomp) 
		end
	    end
	  end
	end
    end

  end
end
