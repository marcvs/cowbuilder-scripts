# Installation
## How to setup the build machine:
- install build essentials 
```
apt-get install cowbuilder build-essentials
```

- clone cowbuilder-scripts:
```
git clone git@github.com:marcvs/cowbuilder-scripts
```

- add /usr/sbin:$HOME/cowbuilder-scripts to PATH

- create the pbuilderrc config


- copy deootstrap from testing:
```
scp /usr/share/debootstrap/scripts/bionic root@repo.data.kit.edu://usr/share/debootstrap/scripts/bionic
```

- the keyring for bionic is a little strange to obtain

## Automagically install build environments
- currently supported: stretch, buster, bullseye, xenial, bionic
```
cow-create-all.sh
```

## oidc-agent specific setups:

- install build dependencies for oidc-agent
```
apt-get install libcurl4-openssl-dev libsodium18 libseccomp-dev libmicrohttpd-dev libsodium-dev help2man
```

- create the dependencies in var/cache/pbuilder:
```
deps
├── stretch-adm64
└── xenial-amd64
    ├── oidc-agent
    │   ├── libsodium18_1.0.11-2_amd64.deb
    │   ├── libsodium-dbg_1.0.11-2_amd64.deb
    │   ├── libsodium-dev_1.0.11-2_amd64.deb
    │   └── Packages
    └── unused-deps
        ├── libseccomp2_2.3.1-2.1_amd64.deb
        ├── libseccomp-dev_2.3.1-2.1_amd64.deb
        └── seccomp_2.3.1-2.1_amd64.deb
```

# Regular operation:

## Update the build environments:
- cow-update-all.sh

## Build oidc-agent:
- in oidc-agent-deb/oidc-agent: 
```
    git pull
    debuild -uc -us
    cd ..
    cow-build-oidc-all.sh <oidc-agent.....dsc>
```
  Logs go to `build-<distro>.log`

- Results will be in /var/cache/pbuilder/
    
## Copy files to the debian repo:

- `publish-oidc.sh <version, e.g. 2.0.3>`
  - Files are now in the debian repo and in the github output dir.
    To update the repo, you need access to the repo signing key.
    For the time being this is only marcus.
