
GIT_PROTO = { ssh:'git@', https: 'https://' }

def add_pre(url)
  res = url.split('/')	
  res[0] = "#{res[0]}:"
  res.join('/')
end

def add_writable(g,proto)
  readonly = g.remotes.find{|r|r.name.eql?('origin')}.url
  writable = readonly.gsub(/git\:\/\//,GIT_PROTO[proto])
  writable = add_pre(writable) if proto.eql?(:ssh)
  remote_exists = g.remotes.map {|r| r.name}.include?('writable')
  unless readonly.eql?(writable) or remote_exists
    g.add_remote('writable',writable) 
  end
end

module  Opsk
  class Push < Thor::Group
    include Thorable, Thor::Actions

    class_option :protocol, :type=> :string, :desc => 'remote ssh protocol (https or ssh)', :default => 'ssh'
    class_option :dry, :type=> :boolean, :desc => 'dry mode', :default => false
    class_option :all, :type=> :boolean, :desc => 'push all without asking', :default => false

    def validate
	check_root
    end


    def push
	Dir["modules/*"].reject{|o| not File.directory?(o)}.each do |d|
	  if File.exists?("#{d}/.git")
	    g = Git.init(d)
	    add_writable(g,options['protocol'].to_sym)
	    if !options['dry'] and g.diff('origin').stats[:files].keys.length > 0
		resp = yes?("push #{d}? (y/n)") unless options['all']
		if(options['all'] or resp)
		  say "Pushing #{d} .."
		  g.push('writable') 
		  g.pull
		end
	    end
	  end
	end
    end


  end
end
