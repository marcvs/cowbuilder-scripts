# Debian Packages

This repository provides debian packages for ubuntu and debian.

To use it, you need to import the signing key:

` sudo apt-key adv --keyserver hkp://pgp.surfnet.nl --recv-keys ACDFB08FDC962044D87FF00B512839863D487A87`
or
` curl repo.data.kit.edu/key.pgp | apt-key add -`

Please note that the first command fails in a time-out from time to time.
In that case just use the second one.

And add one of the supported repos to your `/etc/apt/sources.list`:

- [Debian/testing](/debian/testing):
    - `deb http://repo.data.kit.edu/debian/testing ./`
    - or: `deb http://repo.data.kit.edu/debian/bullseye ./`

- [Debian/stable](/debian/stable): 
    - `deb http://repo.data.kit.edu/debian/stable ./`
    - or: `deb http://repo.data.kit.edu/debian/buster ./`
- [Debian/oldstable](/debian/oldstable): 
    - `deb http://repo.data.kit.edu/debian/oldstable ./`
    - or: `deb http://repo.data.kit.edu/debian/stretch ./`

- [Ubuntu/16.04](/ubuntu/16.04): 
    - `deb http://repo.data.kit.edu/ubuntu/16.04 ./`
    - or: `deb http://repo.data.kit.edu/ubuntu/xenial ./`
- [Ubuntu/18.04](/ubuntu/18.04): 
    - `deb http://repo.data.kit.edu/ubuntu/18.04 ./`
    - or: `deb http://repo.data.kit.edu/ubuntu/bionic ./`

...and don't forget to run apt-get update


Please send bug reports to packages@lists.kit.edu

