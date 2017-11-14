# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'opskeleton/version'

Gem::Specification.new do |gem|
  gem.name          = "opskeleton"
  gem.version       = Opskeleton::VERSION
  gem.authors       = ["narkisr"]
  gem.email         = ["narkisr@gmail.com"]
  gem.description   = %q{Managing services lifecycle from Development to production using Vagrant and Puppet}
  gem.summary       = %q{Managing services lifecycle from Development to production using Vagrant and Puppet}
  gem.homepage      = "https://github.com/narkisr/opskeleton"
  gem.add_dependency('thor')
  gem.add_dependency('bintray_deploy')
  gem.add_dependency('aws-sdk', '~> 2')
  gem.add_dependency('net-scp')
  gem.add_dependency('git')
  gem.add_dependency('git_clone_url', '~> 1.0')
  gem.add_development_dependency('puppet','=4.10.8')
  gem.add_development_dependency('rspec-puppet')
  gem.add_development_dependency('librarian-puppet', '= 2.1.0')
  gem.add_development_dependency('puppetlabs_spec_helper', '>= 0.1.0')
  gem.add_development_dependency('asciidoctor')
  gem.add_development_dependency('pygments.rb')
  gem.add_development_dependency('guard', '= 2.13.0')
  gem.add_development_dependency('guard-shell')
  gem.add_development_dependency('guard-minitest')
  
  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
