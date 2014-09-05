# Intro

Opskelaton fully supports Chef based sandboxes it offers similar features to the Puppet based sandboxes with additional support for roles, environments and cookbooks.

# Usage

Creating out first sandbox

```bash
$ opsk generate_chef redis ubuntu-14.04
$ cd redis-sandbox
```

## Layout

Opskelaton creates the complete folder structure fine tuned to match best practices:

Folder layout:

<img src="https://github.com/opskeleton/opskeleton/blob/master/img/chef-layout.png" width='30%' hight='50%'  alt="" />


## Cookbook lifecycle

Opskelaton defines a simple cookbook life cycle:

 1. Internal non reusable cookbooks (usually specific to a client site) go under static-cookbooks
 2. If we create a general reusable cookbook which is ready for prime time we pull out to a new git repository.
 3. The extracted cookbook is added back as a third party (using [librarian-chef](https://github.com/applicationsonline/librarian-chef) cookbook which resides under cookbooks folder).

Life cycle scheme:

<img src="https://github.com/opskeleton/opskeleton/blob/master/img/chef-cycle.png" width='30%' hight='50%'  alt="" />

Creating new (cookbooks) modules is easy as:

```bash
$ opsk cookbook foo
```

## Testing

Opskelaton supports testing/linting:

* Static cookbook testing that includes rspec and food-critic. (TBD)
* Integration testing using [serverspec](http://serverspec.org/) and Vagrant.

```bash
# running serverspec
$ rake spec
```

## Packaging 
Opskelaton fully supports deployment and portable execution of sandboxes on non Vagrant environments:

```bash
$ opsk generate_chef foo ubuntu-14.04.
$ cd foo-sandbox
# The package version file
$ cat opsk.yaml

--- 
  version: '0.0.1'
  name: redis
  includes: 
    - Cheffile
    - cookbooks
    - static-cookbooks
    - dna.json
    - environments
    - Gemfile
    - Gemfile.lock
    - opsk.yaml
    - roles
    - LICENSE-2.0.txt
    - run.sh
    - boot.sh
    - solo.rb

# post bundle and gem install ..
$ opsk package
	create  pkg/foo-sandbox-0.0.1
	create  pkg/foo-sandbox-0.0.1/scripts
	create  pkg/foo-sandbox-0.0.1/scripts/lookup.rb
	 chmod  pkg/foo-sandbox-0.0.1/scripts/lookup.rb
	create  pkg/foo-sandbox-0.0.1/scripts/run.sh
	 chmod  pkg/foo-sandbox-0.0.1/scripts/run.sh
	 exist  pkg
$ ls pkg
foo-sandbox-0.0.1  foo-sandbox-0.0.1.tar.gz
```
The packaging process creates a portable tar file that can be run on any machine with chef-solo installed via the bundled run.sh:

```bash 
$ tar -xvzf foo-sandbox-0.0.1.tar.gz
$ cd foo-sandbox-0.0.1 
# expects to get the chef environment
$ sudo ./run.sh dev
```


## Deployment

The packaged tar files can be consumed using any tool and protocol however http is recommended, opsk has built in support for deploying public sandboxes into bintray:

```bash 
$ opsk package
$ opsk deploy <bintray-repo>
deployed foo-sandbox-0.0.1.tar.gz to http://dl.bintray.com/narkisr/<bintray-repo>/foo-sandbox-0.0.1.tar.gz
```

Make sure to  [configure](https://github.com/narkisr/bintray-deploy#usage) configure the bintray API key.

## Updating

Keeping you box up to date with latest opsk version is easy, just re-generate it again and resolve conflicts by answering y/n:
```bash
# Moving to latest opsk
$ gem update opskeleton
# foo box already exists
$ opsk generate_chef foo <vagrant-box>
 exist  foo-sandbox
    conflict  foo-sandbox/Vagrantfile
Overwrite /home/ronen/code/foo-sandbox/Vagrantfile? (enter "h" for help) [Ynaqdh]
```

## Vagrant
Opskeleton generates a Vagrant file with couple of enhancements:
 
* CHEF_ENV (default dev) for setting chef environment.
* Default role (sandbox name) created under roles/{type}.rb
* static-cookbooks/cookbooks roles/environments folders are set.


