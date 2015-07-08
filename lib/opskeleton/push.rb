
def add_writable(g,with)
  readonly = g.remotes.find{|r|r.name.eql?('origin')}.url
  writable = readonly.gsub(/git\:\/\/*\//,with)
  remote_exists = g.remotes.map {|r| r.name}.include?('writable')
  unless readonly.eql?(writable) or remote_exists
    g.add_remote('writable',writable) 
  end
end

module  Opsk
  class Push < Thor::Group
    include Thorable, Thor::Actions

    class_option :writable_remote, :type=> :string, :desc => 'add remote write repo', :default => 'git@github.com:'
    class_option :dry, :type=> :boolean, :desc => 'dry mode', :default => false

    def validate
	check_root
    end


    def push
	Dir["modules/*"].reject{|o| not File.directory?(o)}.each do |d|
	  if File.exists?("#{d}/.git")
	    g = Git.init(d)
	    add_writable(g,options['writable_remote'])
	    if !options['dry'] and g.diff('origin').stats[:files].keys.length > 0
	      g.push('writable') 
	    end
	  end
	end
    end


  end
end
