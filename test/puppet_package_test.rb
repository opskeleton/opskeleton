$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'

require 'minitest/autorun'
require_relative 'test_helper'
require 'fileutils'

class PuppetPackageTest < MiniTest::Unit::TestCase
  include FileUtils

  def setup
    Opsk::Root.start ['generate_puppet', 'foo', 'bar']
  end

  def teardown 
    rm_rf 'foo-sandbox'
  end

  def with_cwd(dir)
    Dir.chdir dir do
	yield  
    end
  end

  def test_build
    with_cwd 'foo-sandbox' do
	Opsk::Root.start ['package']
    end
    assert File.exists?('foo-sandbox/pkg/foo-sandbox-0.0.1/Puppetfile')
    assert File.exists?('foo-sandbox/pkg/foo-sandbox-0.0.1/manifests/site.pp')
    assert File.exists?('foo-sandbox/pkg/foo-sandbox-0.0.1/scripts/run.sh')
    assert File.exists?('foo-sandbox/pkg/foo-sandbox-0.0.1.tar.gz')
  end

  # def test_script_override
  #   with_cwd 'foo-sandbox' do  
  #   Opsk::Root.start ['package']
  #   end
  #   File.open('foo-sandbox/scripts', 'w') { |f| f.write(File.read('bar.txt')) } 	
  #   assert File.exists?('foo-sandbox/pkg/foo-sandbox-0.0.1/scripts/run.sh')
  # end
end
