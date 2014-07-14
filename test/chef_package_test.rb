$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'

require 'minitest/autorun'
require_relative 'test_helper'
require 'fileutils'

class ChefPackageTest < MiniTest::Unit::TestCase
  include FileUtils

  def setup
    Opsk::Root.start ['generate_chef', 'foo', 'bar']
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
   assert File.exists?('foo-sandbox/pkg/foo-sandbox-0.0.1/Cheffile')
   assert File.exists?('foo-sandbox/pkg/foo-sandbox-0.0.1/roles/foo.rb')
   assert File.exists?('foo-sandbox/pkg/foo-sandbox-0.0.1/dna.json')
   assert File.exists?('foo-sandbox/pkg/foo-sandbox-0.0.1.tar.gz')
  end

end
