puppet apply --modulepath=modules:static-modules manifests/site.pp\
  --node_terminus exec --external_nodes=`pwd`/scripts/lookup.rb --hiera_config hiera.yaml $@
