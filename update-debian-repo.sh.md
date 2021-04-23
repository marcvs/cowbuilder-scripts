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

- Centos 8: [https://repo.data.kit.edu/centos/centos8](https://repo.data.kit.edu/centos/centos8):
    - Create a file file with this content in `/etc/yum.repos.d`:
        ```
        [repo-data-kit-edu]
        name=repo-data.kit.edu
        baseurl=http://repo.data.kit.edu/centos/centos8
        gpgcheck=1
        enabled=1
        gpgkey=https://repo.data.kit.edu/repo-data-kit-edu.gpg
        ```
        The gpg-key is [here](/repo-data-kit-edu-key.gpg)

- Centos 7: [https://repo.data.kit.edu/centos/centos7](https://repo.data.kit.edu/centos/centos7)
    - Create a file file with this content in `/etc/yum.repos.d`:
        ```
        [repo-data-kit-edu]
        name=repo-data.kit.edu
        baseurl=http://repo.data.kit.edu/centos/centos7
        gpgcheck=1
        enabled=1
        gpgkey=https://repo.data.kit.edu/repo-data-kit-edu.gpg
        ```
        The gpg-key is [here](/repo-data-kit-edu-key.gpg)


## Contact

Please send bug reports to packages@lists.kit.edu
