puppet apply --modulepath=modules:static-modules --node_terminus exec --external_nodes=`pwd`/scripts/lookup.sh --hiera_config hiera.yaml $@
