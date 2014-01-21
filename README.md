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

[![Build Status](https://travis-ci.org/narkisr/opskeleton.png)](https://travis-ci.org/narkisr/opskeleton)

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


## Lifecycle

Opskelaton defines a simple module life cycle:

 1. Internal non reusable modules (usually specific to a client site) go under static-modules
 2. If we create a general reusable module which is ready for prime time we pull out to a new git repository.
 3. The extracted module is added back as a third party (using [librarian-puppet](https://github.com/rodjek/librarian-puppet) module which reside under module folder.

Life cycle scheme:

<img src="https://raw.github.com/narkisr/vagrant-sketching-board/master/images/module-lifecycle-black.png" width='30%' hight='50%'  alt="" />

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
