require 'rubygems'
require 'thor'
require 'thor/group'
require 'opskeleton'


module Opsk
  class Root < Thor
    register Opsk::GeneratePuppet, 'generate_puppet', 'generate_puppet [name] [box]', 'generates opskelaton project structure'
    register Opsk::GenerateChef, 'generate_chef', 'generate_chef [name] [box]', 'generates opskelaton project structure'
    register Opsk::Package, 'package', 'package', 'packages current module for celestial'
    register Opsk::Commit, 'commit', 'commit', 'commits current module for celestial'

  end 
end

