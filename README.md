<img src="https://raw.github.com/narkisr/vagrant-sketching-board/master/images/opskeleton.png" width='100%' hight='100%'  alt="" />

# Intro

Opskelaton is an opinionated bootstrap tool for local Sandbox projects.

Opskeleton aims to solve the following common issues:
 * Developing Puppet/Chef modules/cookbooks on master machines which results with 'It works on my master/server' approach.
 * Large monolithic Puppet/Chef code bases, code isn't modular or reusable.
 * Implicit/Missing dependencies, like ruby version used, operating system, gems, third party modules/cookbooks.
 * Manual steps in setting up modules/cookbooks and local sandboxes (like installing third party code).
 * Non standard layout, projects missing README and LICENSE files, no clear separation between developed and dependant code.
 * No clear development guidelines, for example extracting general modules and exporting them, no deployment packaging or general testing guide.
 * No continues build, linting and testing, provisioning code is second class citizen.
 
Opskeleton comes to solve these issues by introducing a decentralized development work flow with pre-defined layout, packaging and dependency management.

[![Build Status](https://travis-ci.org/opskeleton/opskeleton.png)](https://travis-ci.org/opskeleton/opskeleton)


# Usage

## Installation

Perquisites (on Ubuntu):

* Vagrant 1.7.x
* RVM
* Ruby 2.1.x

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
