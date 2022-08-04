# Packages

This repository provides debian packages for **deb** and **rpm** based
distributions.

## Install
#### Debian
```
    apt-get install oidc-agent
```
#### RPM
```
    yum install oidc-agent
```

# Repositories
To use apt or yum, you need to enable the repository for your linux
distribution:

## Debian Packages

To use it, you need to import the signing key:

### Debian 11 and newer

#### 1. Download the repository key, to a location which is **writable only by root**:
```
curl repo.data.kit.edu/repo-data-kit-edu-key.gpg \
        | gpg --dearmor \
        > /etc/apt/trusted.gpg.d/kitrepo-archive.gpg
```
#### 2. add one of the supported repos to your `/etc/apt/sources.list`:

- [Debian/testing](https://repo.data.kit.edu/debian/testing):

     `deb [signed-by=/etc/apt/trusted.gpg.d/kitrepo-archive.gpg] https://repo.data.kit.edu/debian/testing ./`

- [Debian/bookworm](https://repo.data.kit.edu/debian/bookworm):
     `deb [signed-by=/etc/apt/trusted.gpg.d/kitrepo-archive.gpg] https://repo.data.kit.edu/debian/bookworm ./`


### Debian 11 and older
This method has [security drawbacks](https://www.linuxuprising.com/2021/01/apt-key-is-deprecated-how-to-add.html)

#### 1. Download the key
Three options:

- Option a): 
        ```
        curl repo.data.kit.edu/repo-data-kit-edu-key.gpg |  
            gpg --dearmor > /etc/apt/trusted.gpg.d/kit-repo.gpg
        ```

- Option b): `sudo apt-key adv --keyserver hkp://pgp.surfnet.nl --recv-keys ACDFB08FDC962044D87FF00B512839863D487A87`

- Option c): `curl repo.data.kit.edu/repo-data-kit-edu-key.gpg | apt-key add -`


#### 2. add one of the supported repos to your `/etc/apt/sources.list`: (one line of the two given is enough)


- [Debian/stable](https://repo.data.kit.edu//debian/stable): - `deb https://repo.data.kit.edu/debian/stable ./`

- [Debian/oldstable](https://repo.data.kit.edu//debian/oldstable): - `deb https://repo.data.kit.edu/debian/oldstable ./`

- [Ubuntu/22.10](https://repo.data.kit.edu//ubuntu/22.10): - `deb https://repo.data.kit.edu/ubuntu/22.10 ./`

- [Ubuntu/22.04](https://repo.data.kit.edu//ubuntu/22.04): - `deb https://repo.data.kit.edu/ubuntu/22.04 ./`

- [Ubuntu/21.04](https://repo.data.kit.edu//ubuntu/21.04): - `deb https://repo.data.kit.edu/ubuntu/21.04 ./`

- [Ubuntu/20.04](https://repo.data.kit.edu//ubuntu/20.04): - `deb https://repo.data.kit.edu/ubuntu/20.04 ./`

- [Ubuntu/18.04](https://repo.data.kit.edu//ubuntu/18.04): - `deb https://repo.data.kit.edu/ubuntu/18.04 ./`

...and don't forget to run apt-get update



## RPM Packages
<!--To use it, [this](https://repo.data.kit.edu/repo-data-kit-edu-key.gpg) signing key is used: -->

Depending on your Distro, run:

- [Centos 8](https://repo.data.kit.edu/centos/centos8):
        ```
        cd /etc/yum.repos.d; wget https://repo.data.kit.edu/data-kit-edu-centos8.repo
        ```

- [Centos 7](https://repo.data.kit.edu/centos/centos7):
        ```
        cd /etc/yum.repos.d; wget https://repo.data.kit.edu/data-kit-edu-centos7.repo
        ```
- [Centos Stream](https://repo.data.kit.edu/centos/centos-stream):
        ```
        cd /etc/yum.repos.d; wget https://repo.data.kit.edu/data-kit-edu-centos-stream.repo
        ```

- [Rocky Linux 8.5](https://repo.data.kit.edu/rockylinux/8.5):
        ```
        cd /etc/yum.repos.d; wget https://repo.data.kit.edu/data-kit-edu-rockylinux8.5.repo
        ```
- [Rocky Linux 8](https://repo.data.kit.edu/rockylinux/8):
        ```
        cd /etc/yum.repos.d; wget https://repo.data.kit.edu/data-kit-edu-rockylinux8.repo
        ```


- [Suse tumbleweed](https://repo.data.kit.edu/opensuse/tumbleweed)
- [Suse leap 15.2](https://repo.data.kit.edu/opensuse/15.2)
- [Suse leap 15.3](https://repo.data.kit.edu/opensuse/15.3)


## Contact

Please send bug reports to packages@lists.kit.edu
