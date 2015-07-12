require "bundler/gem_tasks"

require 'rake/testtask'

Rake::TestTask.new do |t|
    t.pattern = "test/*_test.rb"
    t.verbose = true
end

namespace :asciidoc do

  desc 'create asciidoc'
  task :create do
    sh 'asciidoctor -a docinfo -a stylesheet! -o dist/latest/index.html docs/doc.adoc'
  end

  desc 'publish ascciidoc to gh-pages'
  task :publish => [:create] do
    sh 'ghp-import -m "Generate documentation" -b gh-pages dist/'
    sh 'git push origin gh-pages'
  end

  desc 'clear asciidoc'
  task :clear do
    rm_rf 'dist'
  end
end

