# Packages

This repository provides debian packages for ubuntu, debian, and centos.

## Debian Packages

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

- [Ubuntu/20.04](/ubuntu/20.04): 
    - `deb http://repo.data.kit.edu/ubuntu/20.04 ./`
    - or: `deb http://repo.data.kit.edu/ubuntu/focal ./`

- [Ubuntu/18.04](/ubuntu/18.04): 
    - `deb http://repo.data.kit.edu/ubuntu/18.04 ./`
    - or: `deb http://repo.data.kit.edu/ubuntu/bionic ./`

...and don't forget to run apt-get update



## RPM Packages
To use it, [this](/repo-data-kit-edu-key.gpg) signing key is used: 

- [Centos 8](https://repo.data.kit.edu/centos/centos8):
    - Create a [file](http://repo.data.kit.edu/data-kit-edu-centos8.repo) with this content in `/etc/yum.repos.d`:
        ```
        cd /etc/yum.repos.d; wget http://repo.data.kit.edu/data-kit-edu-centos8.repo
        ```

- [Centos 7](https://repo.data.kit.edu/centos/centos7):
    - Create a [file](http://repo.data.kit.edu/data-kit-edu-centos7.repo) with this content in `/etc/yum.repos.d`:
        ```
        cd /etc/yum.repos.d; wget http://repo.data.kit.edu/data-kit-edu-centos7.repo
        ```


## Contact

Please send bug reports to packages@lists.kit.edu
