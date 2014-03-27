require 'rake'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = 'spec/*/*_spec.rb'
end

task :default => :spec

task :modspec do
    FileList["static-modules/**/Rakefile"].each do |project|
        Rake::Task.clear
        load project
        dir = project.pathmap("%d")
        Dir.chdir(dir) do
          spec_task = Rake::Task[:spec]
          spec_task.invoke()
        end
    end
end

require 'puppet-lint/tasks/puppet-lint'
PuppetLint.configuration.ignore_paths =['modules/**/*']
PuppetLint.configuration.send("disable_80chars")
