<img src="https://raw.github.com/narkisr/vagrant-sketching-board/master/images/opskeleton.png" width='100%' hight='100%'  alt="" />

# Intro

Opskelaton is an opinionated bootstrap tool for local Sandbox projects.

Opsk aims to solve the following common issues:
 * Devops develop Puppet modules on master machines which results with 'It works on my (machine) master' approach.
 * Implicit/Missing dependencies, like ruby version used, operating system, gems, third party puppet module
 * Manual steps in setting up puppet modules and local sandboxes (like installing third party code).
 * Non standard layout, projects missing README and LICENSE files, no clear separation between developed and dependant code.
 * No clear development guidelines, for example extracting general modules and exporting them.
 

See it in action [here](https://www.youtube.com/watch?v=LNlHC54Ej8c).

[![Build Status](https://travis-ci.org/opskeleton/opskeleton.png)](https://travis-ci.org/opskeleton/opskeleton)

Usage
=========

Perquisites (on Ubuntu):

* Vagrant 1.4.x
* RVM
* Ruby 1.9.x

```bash 
 $ rvm use system
 $ sudo gem install opskeleton
``` 

Creating out first sandbox

```bash
 $ rvm use system 
 # parameters include name vagrant-box
 $ opsk generate redis ubuntu-13.10
 $ cd redis-sandbox
 $ bundle install 
 $ librarian-puppet install 
 $ vagrant up 
```

## Layout

Opskelaton creates the complete folder structure fine tuned to match best practices:

Folder layout:

<img src="https://raw.github.com/narkisr/vagrant-sketching-board/master/images/opsk-folders.png" width='30%' hight='50%'  alt="" />


## Module lifecycle

Opskelaton defines a simple module life cycle:

 1. Internal non reusable modules (usually specific to a client site) go under static-modules
 2. If we create a general reusable module which is ready for prime time we pull out to a new git repository.
 3. The extracted module is added back as a third party (using [librarian-puppet](https://github.com/rodjek/librarian-puppet) module which reside under module folder.

Life cycle scheme:

<img src="https://raw.github.com/narkisr/vagrant-sketching-board/master/images/module-lifecycle-black.png" width='30%' hight='50%'  alt="" />

Creating new (static) modules is easy as:

```bash
$ opsk module foo
```

Each generated module will contain puppet-rspec with matching Rakefile (see [testing](https://github.com/opskeleton/opskeleton#testing)).

## Testing

Opskelaton supports two levels of testing:

* Static module testing that includes rspec and linting.
* Integration testing using [serverspec](http://serverspec.org/) and Vagrant.

```bash
# linting all static modules
$ rake lint
# rspecing 
$ rake modspec
# running serverspec
$ rake spec
```

## Packaging 

Opskelaton fully supports deployment and portable execution of sandboxes on non Vagrant environments:

```bash
$ opsk generate foo ubuntu-13.10
$ cd foo-sandbox
# The package version file
$ cat opsk.yaml
--- 
  version: '0.0.1'
  name: foo

# post bundle and gem install ..
$ opsk package
      create  pkg/foo-sandbox-0.0.1
      create  pkg/foo-sandbox-0.0.1/scripts
      create  pkg/foo-sandbox-0.0.1/scripts/lookup.rb
       chmod  pkg/foo-sandbox-0.0.1/scripts/lookup.rb
      create  pkg/foo-sandbox-0.0.1/scripts/run.sh
       chmod  pkg/foo-sandbox-0.0.1/scripts/run.sh
      create  pkg/foo-sandbox-0.0.1/manifests/site.pp
       exist  pkg
$ ls pkg
foo-sandbox-0.0.1  foo-sandbox-0.0.1.tar.gz
```
The packaging process creates a portable tar file that can be run on any machine with puppet installed via the bundled run.sh:

```bash 
$ tar -xvzf foo-sandbox-0.0.1.tar.gz
$ cd foo-sandbox-0.0.1 
$ sudo ./run.sh
```

An external node classifier based runner is also available under scripts/run.sh, this runner expects to get a <hostname>.yaml input file with the required node classes.


## Deployment

The packaged tar files can be consumed using any tool and protocol however http is recommended, opsk has built in support for deploying public sandboxes into bintray:

```bash 
$ opsk package
$ opsk deploy <bintray-repo>
deployed foo-sandbox-0.0.1.tar.gz to http://dl.bintray.com/narkisr/<bintray-repo>/foo-sandbox-0.0.1.tar.gz
```

Make sure to  [configure](https://github.com/narkisr/bintray-deploy#usage) configure the bintray API key.
# Copyright and license

Copyright [2013] [Ronen Narkis]

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

  [http://www.apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0)

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
