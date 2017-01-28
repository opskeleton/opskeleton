<img src="https://raw.github.com/narkisr/vagrant-sketching-board/master/images/opskeleton.png" width='100%' hight='100%'  alt="" />

# Intro

Opskelaton is an opinionated bootstrap tool for local Sandbox projects, it aims to solve the following common issues:

* Developing Puppet modules on master machines which results with 'It works on my master' approach.
* Large monolithic Puppet code bases, code isn't modular or reusable.
* Implicit/Missing dependencies including: Ruby version, OS, gems, modules.
* Manual steps in setting up and maintaining such projects.
* Non standard layout, projects missing README and LICENSE files, no clear separation between developed and dependant code.
* Lacking development guidelines (for example extracting general modules and exporting them).
* No continues build, linting and testing, provisioning code is second class citizen.
 
Opskeleton comes to solve these issues by introducing a decentralized development work flow with pre-defined layout, packaging and dependency management.

For [Usage](http://opskeleton.github.io/opskeleton/latest/) and more info please follow the [docs](http://opskeleton.github.io/opskeleton/latest/).

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
