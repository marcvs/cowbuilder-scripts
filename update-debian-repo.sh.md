# Packages

This repository provides debian packages for **deb** and **rpm** based
distributions.

## Debian Packages

To use it, you need to import the signing key:

### New Method (Debian 11 and newer)

#### 1. Download the repository key, to a location which is **writable only by root**:
Two options:

Option a) (recommended):
```
curl repo.data.kit.edu/repo-data-kit-edu-key.gpg \
        | gpg --dearmor \
        > /etc/apt/trusted.gpg.d/kitrepo-archive.gpg
```
#### 2. add one of the supported repos to your `/etc/apt/sources.list`: (one line of the two given is enough)

- [Debian/testing](/debian/testing) (one single line):

     `deb [signed-by=/etc/apt/trusted.gpg.d/kitrepo-archive.gpg] https://repo.data.kit.edu/debian/testing ./`

     `deb [signed-by=/etc/apt/trusted.gpg.d/kitrepo-archive.gpg] https://repo.data.kit.edu/debian/bookworm ./`


### Old method (Debian 11 and older)
The old method has [security drawbacks](https://www.linuxuprising.com/2021/01/apt-key-is-deprecated-how-to-add.html)

#### 1. Download the key
Three options:

Option a)

` curl repo.data.kit.edu/repo-data-kit-edu-key.gpg | gpg --dearmor > /etc/apt/trusted.gpg.d/kit-repo.gpg`

Option b)

` sudo apt-key adv --keyserver hkp://pgp.surfnet.nl --recv-keys ACDFB08FDC962044D87FF00B512839863D487A87`

Option c)

` curl repo.data.kit.edu/repo-data-kit-edu-key.gpg | apt-key add -`

Please note that the first command fails in a time-out from time to time.
In that case just use the second one.

#### 2. add one of the supported repos to your `/etc/apt/sources.list`: (one line of the two given is enough)


- [Debian/stable](/debian/stable):
    - `deb https://repo.data.kit.edu/debian/stable ./`
    - `deb https://repo.data.kit.edu/debian/bullseye ./`

- [Debian/oldstable](/debian/oldstable): 
    - `deb https://repo.data.kit.edu/debian/oldstable ./`
    - `deb https://repo.data.kit.edu/debian/buster ./`

- [Ubuntu/21.04](/ubuntu/21.04): 
    - `deb https://repo.data.kit.edu/ubuntu/21.04 ./`
    - `deb https://repo.data.kit.edu/ubuntu/hirsute ./`

- [Ubuntu/20.04](/ubuntu/20.04): 
    - `deb https://repo.data.kit.edu/ubuntu/20.04 ./`
    - `deb https://repo.data.kit.edu/ubuntu/focal ./`

- [Ubuntu/18.04](/ubuntu/18.04): 
    - `deb https://repo.data.kit.edu/ubuntu/18.04 ./`
    - `deb https://repo.data.kit.edu/ubuntu/bionic ./`

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
- [Centos Stream](https://repo.data.kit.edu/centos/centos-stream):
    - Create a [file](https://repo.data.kit.edu/data-kit-edu-centos-stream.repo) with this content in `/etc/yum.repos.d`:
        ```
        cd /etc/yum.repos.d; wget https://repo.data.kit.edu/data-kit-edu-centos-stream.repo
        ```

- [Rocky Linux 8.5](https://repo.data.kit.edu/rockylinux/8.5):
    - Create a [file](https://repo.data.kit.edu/data-kit-edu-rockylinux8.5.repo) with this content in `/etc/yum.repos.d`:
        ```
        cd /etc/yum.repos.d; wget https://repo.data.kit.edu/data-kit-edu-rockylinux8.5.repo
        ```
- [Rocky Linux 8](https://repo.data.kit.edu/rockylinux/8):
    - Create a [file](https://repo.data.kit.edu/data-kit-edu-rockylinux8.repo) with this content in `/etc/yum.repos.d`:
        ```
        cd /etc/yum.repos.d; wget https://repo.data.kit.edu/data-kit-edu-rockylinux8.repo
        ```

- [Suse tumbleweed](https://repo.data.kit.edu/opensuse/tumbleweed)
- [Suse leap 15.2](https://repo.data.kit.edu/opensuse/15.2)
- [Suse leap 15.3](https://repo.data.kit.edu/opensuse/15.3)


## Contact

Please send bug reports to packages@lists.kit.edu
