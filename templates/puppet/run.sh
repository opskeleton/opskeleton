puppet apply --modulepath=modules:static-modules manifests/default.pp --hiera_config hiera.yaml $@
