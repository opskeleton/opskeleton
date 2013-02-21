puppet apply --modulepath=modules:static-modules manifests/site.pp\
  --node_terminus exec --external_nodes=`pwd`/scripts/lookup.sh --hiera_config hiera.yaml $@
