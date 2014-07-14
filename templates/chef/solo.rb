file_cache_path "#{Dir.pwd}/chef"
cookbook_path ["#{Dir.pwd}/cookbooks","#{Dir.pwd}/static-cookbooks"]
role_path "#{Dir.pwd}/roles/"
log_level :info
log_location STDOUT
