# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'opskeleton/version'

Gem::Specification.new do |gem|
  gem.name          = "opskeleton"
  gem.version       = Opskeleton::VERSION
  gem.authors       = ["narkisr"]
  gem.email         = ["narkisr@gmail.com"]
  gem.description   = %q{A generator for ops projects that include vagrant puppet and fpm}
  gem.summary       = %q{A generator for ops projects that include vagrant puppet and fpm}
  gem.homepage      = "https://github.com/narkisr/opskeleton"
  gem.add_dependency('thor')
  gem.add_dependency('bintray_deploy')
  gem.add_development_dependency('puppet')
  gem.add_development_dependency('chef')
  gem.add_development_dependency('rspec-puppet')
  gem.add_development_dependency('puppetlabs_spec_helper', '>= 0.1.0')
  gem.add_development_dependency('pry')

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
