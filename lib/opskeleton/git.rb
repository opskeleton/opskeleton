require 'git_clone_url'

module  Opsk
  class Git
    extend ::Forwardable


    def initialize(d,thor)
	@d = d
	@g = ::Git.open(d)
	@thor = thor
    end

    def_delegator :@g, :push, :push
    def_delegator :@g, :pull, :pull

    def changed?
	res = git_run('status')
	%w(modified deleted untracked).detect{|c| res.include?(c)}
    end

    def report
	%i(changed added untracked deleted).each do |state|
	  res = @g.status.send(state)
	  if(res.length > 0)
	    @thor.say "#{state} files:\n\n"
	    res.each do |k,v|
		@thor.say "- #{k}"
	    end
	    @thor.say "\n"
	  end
	end
    end

    def remaster
	Dir.chdir @d do
	  git_run('stash','.')
	  git_run('checkout master','.')
	  git_run('stash apply stash@\{0\}','.')
	end
    end

    def master_commit(options)
	resp = @thor.yes? "Commit the changes under #{@d}? (y/n)" unless options['all']
	if(options['all'] or resp)
	  remaster
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
	git_run('status').include?('ahead')
    end

    def git_run(cmd,parent=nil)
	dir = parent || @d
	res = %x{git --git-dir=#{dir}/.git --work-tree=#{dir} #{cmd}}
	if $? != 0	
	  raise Exception.new("Failed to run #{cmd} due to #{res}")
	end
	res
    end
  end
end
