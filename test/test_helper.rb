require 'rubygems'
require 'thor'
require 'thor/group'
require 'opskeleton'


module Opsk
  class Root < Thor
    register Opsk::Generate, 'generate', 'generate [name] [box]', 'generates opskelaton project structure'
    register Opsk::Package, 'package', 'package', 'packages current module for celestial'

    end 
end

