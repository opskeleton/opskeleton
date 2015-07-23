require 'git_clone_url'

module  Opsk
  class Git
    extend Forwardable


    def initialize(d,thor)
	@g = ::Git.open(d)
	@thor = thor
    end

    def_delegator :@g, :push, :push
    def_delegator :@g, :pull, :pull

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

    def master_commit(d,options)
	resp = @thor.yes? "Commit the changes under #{d}? (y/n)" unless options['all']
	if(options['all'] or resp)
	  @g.checkout('master')
	  if options['message']
	    @g.commit_all(options['message']) 
	  else 
	    @thor.say 'Commit message:'
	    @g.commit_all(STDIN.gets.chomp) 
	  end
	end

    end

    def normalize_url(readonly,options)
	url = GitCloneUrl.parse(readonly)
	proto = options['protocol'] || 'ssh'
	port = options['port']? ":#{options['port']}" : ''
	user = options['user']? "#{options['user']}@" : ''
	"#{proto}://#{user}#{url.host}#{port}#{url.path}"
    end

    def add_writable(options)
	readonly = @g.remotes.find{|r|r.name.eql?('origin')}.url
	writable = normalize_url(readonly,options)
	remote_exists = @g.remotes.map {|r| r.name}.include?('writable')
	unless readonly.eql?(writable) or remote_exists
	  @g.add_remote('writable',writable) 
	end
    end

    # ruby-git cannot do this (lame)
    def local_ahead?
	%x{git --git-dir=#{@d}/.git --work-tree=#{@d}}.include?('ahead')
    end
  end
end
