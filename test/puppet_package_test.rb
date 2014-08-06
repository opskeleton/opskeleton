$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'

require 'minitest/autorun'
require_relative 'test_helper'
require 'fileutils'

class PuppetPackageTest < MiniTest::Unit::TestCase
  include FileUtils

  def setup
    Opsk::Root.start ['generate_puppet', 'foo', 'bar']
    FileUtils.touch('foo-sandbox/Gemfile.lock')
    FileUtils.mkdir('foo-sandbox/modules')
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

  def test_script_override
    File.open('foo-sandbox/opsk.yaml', 'a') do |file|
	file.puts '    - scripts'
    end
    Dir.mkdir('foo-sandbox/scripts/')
    File.open('foo-sandbox/scripts/run.sh', 'w') { |f| f.write('my script') } 	
    with_cwd 'foo-sandbox' do  
	Opsk::Root.start ['package']
    end
    File.open('foo-sandbox/pkg/foo-sandbox-0.0.1/scripts/run.sh', 'r') { |f| 
	assert_equal(f.read , 'my script')
    } 	
  end
end
