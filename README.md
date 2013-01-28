Intro
==========

Opskelaton is an opinionated bootstrap tool for local sandboxes project that uses/creates:

 * A vagrant file matching OS
 * RVM (creates an .rvmrc with a matching gemset) 
 * bundler (with dependencies defined)
 * librarian-puppet for puppet module depdency managment
 * basic folder strucuture (
  * static-module for currently developed modules and modules for imported ones
  * run.sh (for simple running of puppet within the sandbox)
  * License and README

See it in action [here](https://www.youtube.com/watch?v=LNlHC54Ej8c).

Usage
=========

```bash
 $ opsk generate name box-type
```
