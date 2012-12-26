#!/usr/bin/env ruby

require 'rubygems'
require 'thor'
require 'thor/group'

module  Opsk 
  class Generator < Thor::Group
    include Thor::Actions

    # Define arguments and options
    argument :name
    argument :box

    def self.source_root
	File.dirname(__FILE__)
    end

    def create_vagrant_file
	template('templates/vagrant.erb', 'Vagrantfile')
    end

  end
end


module Opsk
  class Root < Thor
    register Opsk::Generator, 'generate', 'generate name box', 'generates opskelaton project structure'
  end 
end

Opsk::Root.start
