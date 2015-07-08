$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'

require 'minitest/autorun'
require_relative 'test_helper'
require 'fileutils'
require 'git'

SANDBOX = 'commit'
ROOT = "#{SANDBOX}-sandbox/modules/foo"
class CommitTest < MiniTest::Unit::TestCase
  include FileUtils

  def setup
    Opsk::Root.start ['generate_puppet', 'commit', 'bar']
    mkdir_p(ROOT)
    g = Git.init(ROOT)
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
	 Opsk::Root.start ['commit','some message']
    end 	
    g = Git.init(ROOT)
    assert g.show.include? 'some message'
  end
end
