<img src="https://raw.github.com/narkisr/vagrant-sketching-board/master/images/opskeleton.png" width='100%' hight='100%'  alt="" />

# Intro

Opskelaton is an opinionated bootstrap tool for local Sandbox projects.

Opskeleton aims to solve the following common issues:
 * Devops develop Puppet modules on master machines which results with 'It works on my (machine) master' approach.
 * Implicit/Missing dependencies, like ruby version used, operating system, gems, third party puppet module
 * Manual steps in setting up puppet modules and local sandboxes (like installing third party code).
 * Non standard layout, projects missing README and LICENSE files, no clear separation between developed and dependant code.
 * No clear development guidelines, for example extracting general modules and exporting them.
 
Opskeleton comes to solve these issues by introducing a decentralized development workflow with pre-defined layout, packaging and dependency management.

See it in action [here](https://www.youtube.com/watch?v=LNlHC54Ej8c).

[![Build Status](https://travis-ci.org/opskeleton/opskeleton.png)](https://travis-ci.org/opskeleton/opskeleton)


# Usage

## Installation

Perquisites (on Ubuntu):

* Vagrant 1.6.x
* RVM
* Ruby 1.9.x

```bash 
 $ rvm use system
 $ sudo gem install opskeleton
``` 

Now Follow either [Chef](chef.md) or [Puppet](puppet.md).

# Boxes
Opskeleton recommends the use of [box-cutter](https://github.com/box-cutter) in order to create Vagrant boxes in a consistent manner (as no free hosting solution currently exist):
```bash
# make sure to have latest packer
$ packer version
Packer v0.6.0
$ git clone git@github.com:box-cutter/ubuntu-vm.git
$ cd ubuntu-vm
# Edit Makefile.local
$ cat Makefile.local
# Makefile.local
CM := puppet
CM_VERSION := 3.6.1
$ make virtualbox/ubuntu1404
```
A useful convention for Box names:

```bash
ubuntu-14.04_puppet-3.6.1 ([os]-[version]_[provisioner]-[version])
```

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
