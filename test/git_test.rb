$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'

require 'minitest/autorun'
require_relative 'test_helper'
require 'fileutils'
require 'git'

SANDBOX = 'commit'
ROOT = "#{SANDBOX}-sandbox/modules/foo"
class GitTest < MiniTest::Unit::TestCase
  include FileUtils

  def setup
    Opsk::Root.start ['generate_puppet', 'commit', 'bar']
    mkdir_p(ROOT)
    mkdir_p("#{SANDBOX}-sandbox/modules/non-git")
    g = Git.init(ROOT)
    g.add_remote('origin','git://github.com/foo/bar.git') 
    touch("#{ROOT}/bla.txt")
    g.add('bla.txt')
    g.commit_all('message')
    open("#{ROOT}/bla.txt", 'a') { |f| f.puts 'Hello, world.'}
  end

  def teardown 
    rm_rf "#{SANDBOX}-sandbox"
  end

  def with_cwd(dir)
    Dir.chdir dir do
	yield  
    end
  end

  def test_commit
    with_cwd "#{SANDBOX}-sandbox" do
	 Opsk::Root.start ['commit', '--message', 'some message', '--all', 'true']
    end 	
    g = Git.init(ROOT)
    assert g.show.include? 'some message'
  end

  def test_writeable
    with_cwd "#{SANDBOX}-sandbox" do
	 Opsk::Root.start ['push', '--dry', 'true']
    end 	
    g = Git.init(ROOT)
    assert g.remotes.length == 2
  end

  def test_urls
    git = Opsk::Git.new('.',nil)
    readonly = 'git://github.com/pulling-strings/puppet-jdk.git'
    norm = git.normalize_url(readonly,{})
    assert norm == 'ssh://github.com/pulling-strings/puppet-jdk.git'
    norm = git.normalize_url(readonly,{'protocol' => 'https','port' => '1234'})
    assert norm == 'https://github.com:1234/pulling-strings/puppet-jdk.git' 
    norm = git.normalize_url(readonly,{'user' => 'ronen', 'protocol' => 'ssh','port' => '1234'})
    assert norm == 'ssh://ronen@github.com:1234/pulling-strings/puppet-jdk.git' 
  end
end
