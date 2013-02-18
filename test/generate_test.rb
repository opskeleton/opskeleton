$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'

require 'minitest/autorun'
require_relative 'test_helper'
require 'fileutils'

class GenerateTest< MiniTest::Unit::TestCase
  include FileUtils

  def setup
    Opsk::Root.start ['generate', 'foo', 'bar']
  end

  def teardown 
    rm_rf 'foo-sandbox'
  end

  def test_version
    assert File.exists?('foo-sandbox/opsk.yml')
  end

end
