
require 'git_clone_url'

def normalize_url(readonly,options)
  url = GitCloneUrl.parse(readonly)
  proto = options['protocol'] || 'ssh'
  port = options['port']? ":#{options['port']}" : ''
  user = options['user']? "#{options['user']}@" : ''
  "#{proto}://#{user}#{url.host}#{port}#{url.path}"
end

def add_writable(g,options)
  readonly = g.remotes.find{|r|r.name.eql?('origin')}.url
  writable = normalize_url(readonly,options)
  remote_exists = g.remotes.map {|r| r.name}.include?('writable')
  unless readonly.eql?(writable) or remote_exists
    g.add_remote('writable',writable) 
  end
end

# ruby-git cannot do this (lame)
def local_ahead?(d)
  %x{git --git-dir=#{d}/.git --work-tree=#{d}}.include?('ahead')
end

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
		g = Git.open(d)
		add_writable(g,options)
		if !options['dry'] and local_ahead?(d)
		  resp = yes?("Push #{d}? (y/n)") unless options['all']
		  if(options['all'] or resp)
		    say "pushing #{d} .."
		    g.push('writable') 
		    g.pull
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
