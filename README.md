Intro
==========

Opskelaton is an opinionated bootstrap tool for local Sandbox projects.

Opsk aims to solve the following common issues:
 * Devops develop Puppet modules on master machines which results with 'It works on my (machine) master' approach.
 * Implicit/Missing dependencies, like ruby version used, operating system, gems, third party puppet module
 * Manual steps in setting up puppet modules and local sandboxes (like installing third party code).
 * Non standard layout, projects missing README and LICENSE files, no clear seperation between developed and depdendant code.
 * No clear development guidelines, for example extracting general modules and exporting them.
 




See it in action [here](https://www.youtube.com/watch?v=LNlHC54Ej8c).

Usage
=========

```bash
 $ opsk generate name box-type
```

Opskelaton creates the complete folder structure fine tuned to match best practices:

Folder layout:

![](https://raw.github.com/narkisr/vagrant-sketching-board/master/images/opsk-folders.png)


