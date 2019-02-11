# Debian Packages

This repository provides debian packages for ubuntu and debian.

To use it, you need to import the signing key:

`
sudo apt-key adv --keyserver hkp://pgp.surfnet.nl --recv-keys ACDFB08FDC962044D87FF00B512839863D487A87`

And add one of the supported repos to your `/etc/apt/sources.list`:

- [Debian/stable](/debian/stable): 
    - `deb http://repo.data.kit.edu/debian/stable ./`
    - or: `deb http://repo.data.kit.edu/debian/stretch ./`

- [Debian/testing](/debian/testing):
    - `deb http://repo.data.kit.edu/debian/testing ./`
    - or: `deb http://repo.data.kit.edu/debian/buster ./`

- [Ubuntu/16.04](/ubuntu/16.04): 
    - `deb http://repo.data.kit.edu/ubuntu/16.04 ./`
    - or: `deb http://repo.data.kit.edu/ubuntu/xenial ./`
- [Ubuntu/18.04](/ubuntu/18.04): 
    - `deb http://repo.data.kit.edu/ubuntu/18.04 ./`
    - or: `deb http://repo.data.kit.edu/ubuntu/bionic ./`

...and don't forget to run apt-get update


Please send bug reports to packages@lists.kit.edu

