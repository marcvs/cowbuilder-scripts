# Packages

This repository provides debian packages for ubuntu, debian, and centos.

## Debian Packages

To use it, you need to import the signing key:

` curl repo.data.kit.edu/key.pgp > /etc/apt/trusted.gpg.d/kit-repo.gpg`
or
` sudo apt-key adv --keyserver hkp://pgp.surfnet.nl --recv-keys ACDFB08FDC962044D87FF00B512839863D487A87`
or
` curl repo.data.kit.edu/key.pgp | apt-key add -`

Please note that the first command fails in a time-out from time to time.
In that case just use the second one.

And add one of the supported repos to your `/etc/apt/sources.list`:

- [Debian/testing](/debian/testing):
    - `deb https://repo.data.kit.edu/debian/testing ./`
    - or: `deb https://repo.data.kit.edu/debian/bookworm ./`

- [Debian/stable](/debian/stable):
    - `deb https://repo.data.kit.edu/debian/stable ./`
    - or: `deb https://repo.data.kit.edu/debian/bullseye ./`

- [Debian/oldstable](/debian/oldstable): 
    - `deb https://repo.data.kit.edu/debian/oldstable ./`
    - or: `deb https://repo.data.kit.edu/debian/buster ./`

- [Ubuntu/21.04](/ubuntu/21.04): 
    - `deb https://repo.data.kit.edu/ubuntu/21.04 ./`
    - or: `deb https://repo.data.kit.edu/ubuntu/hirsute ./`

- [Ubuntu/20.04](/ubuntu/20.04): 
    - `deb https://repo.data.kit.edu/ubuntu/20.04 ./`
    - or: `deb https://repo.data.kit.edu/ubuntu/focal ./`

- [Ubuntu/18.04](/ubuntu/18.04): 
    - `deb https://repo.data.kit.edu/ubuntu/18.04 ./`
    - or: `deb https://repo.data.kit.edu/ubuntu/bionic ./`

...and don't forget to run apt-get update



## RPM Packages
To use it, [this](https://repo.data.kit.edu/repo-data-kit-edu-key.gpg) signing key is used: 

- [Centos 8](https://repo.data.kit.edu/centos/centos8):
    - Create a [file](https://repo.data.kit.edu/data-kit-edu-centos8.repo) with this content in `/etc/yum.repos.d`:
        ```
        cd /etc/yum.repos.d; wget https://repo.data.kit.edu/data-kit-edu-centos8.repo
        ```

- [Centos 7](https://repo.data.kit.edu/centos/centos7):
    - Create a [file](https://repo.data.kit.edu/data-kit-edu-centos7.repo) with this content in `/etc/yum.repos.d`:
        ```
        cd /etc/yum.repos.d; wget https://repo.data.kit.edu/data-kit-edu-centos7.repo
        ```

- [Suse tumbleweed](https://repo.data.kit.edu/suse/opensuse-tumbleweed)
- [Suse leap 15.2](https://repo.data.kit.edu/suse/opensuse-leap-15.2)
- [Suse leap 15.3](https://repo.data.kit.edu/suse/opensuse-leap-15.3)


## Contact

Please send bug reports to packages@lists.kit.edu
