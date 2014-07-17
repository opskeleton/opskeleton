#!/usr/bin/env ruby

require 'uri'
require 'net/http'

# this is used for external node lookup in celestial puppet std provider

node = ARGV[0]
host = node.split('.').first

if(File.exists?("#{host}.yml"))
  File.open("#{host}.yml").lines.each {|l| puts l}
else
  ip = ENV['SSH_CONNECTION'].split(' ').first
  httpcall = Net::HTTP.new(ip, 8082)
  resp, data = httpcall.get2("/registry/host/type/#{node}", 'Accept' => 'application/x-yaml')
  puts resp.body
end
