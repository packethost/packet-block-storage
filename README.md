# packet-block-storage

----
## Quick overview
This utility assists in the attachment and detachment of Packet block storage volumes. Use at your own risk and always have a backup/snapshot just in case!

# Availability
The packet-block storage utility is pre-installed on the following Packet operating systems:
* CentOS
* Ubuntu
* Debian
* OpenSUSE
* Redhat Enterprise Linux
* SLES 12 SP3

It also will function on any operating system distribution that supports each of the following:

* An init system, one of: [systemd](https://github.com/systemd/systemd) or [openrc](https://wiki.gentoo.org/wiki/OpenRC) 
* A package installation system, one of the following with the correct packages: 
    * [apt](https://wiki.debian.org/Apt) with `jq`, `open-iscsi`, `multipath-tools`
    * [yum](https://wiki.centos.org/PackageManagement/Yum) with `jq` (in base or epel), `iscsi-initiator-utils`, `device-mapper-multipath` 
    * [Alpine packages](https://wiki.alpinelinux.org/wiki/Alpine_Linux_package_management) with `jq`, `open-iscsi`, `multipath-tools`

It also is available as a Docker image at `packethost/packet-block-storage`. See below for docker run modes.

# Features
* Attach block storage block devices
* Detach block storage block devices
* Configure multipath for HA
* Validate block device creation

# Dependencies
These dependencies are required only if running at the host level. If you are running it in a docker container, then you need not install these dependencies.

**Ubuntu/Debian**:

    apt-get install open-iscsi multipath-tools jq


**CentOS**:

    yum -y install iscsi-initiator-utils device-mapper-multipath jq

## Installation

There are several ways to install it:

* `git`
* `wget`
* `docker`

### git

```
    sudo su -
    git clone git@github.com:packethost/packet-block-storage.git
    cp ./packet-block-storage/packet-block-storage-* /usr/bin/
    chmod u+x /usr/bin/packet-block-storage-*
```


### wget

```
    sudo su -
    wget -O /usr/bin/packet-block-storage-attach https://raw.githubusercontent.com/packethost/packet-block-storage/master/packet-block-storage-attach
    wget -O /usr/bin/packet-block-storage-detach https://raw.githubusercontent.com/packethost/packet-block-storage/master/packet-block-storage-detach
    chmod u+x /usr/bin/packet-block-storage-*
```

### docker

```
docker pull packethost/packet-block-storage
```

## Usage

**Attach a volume**

1. Create a volume under the Storage tab in your Packet.net portal account
2. Click on the storage volume, select the server you wish to attach the volume to and click on Attach.
3. Execute packet-block-storage-attach from within the OS on the server in question
4. Partition the block device at /dev/mapper/\{volume\_name\_here\} disk using parted, fdisk, etc
5. Make a filesystem on the block device
6. Mount the block device on the mount point of you choice

Example :

    [root@cent7-pbs-client dlaube]# packet-block-storage-attach
    Block device /dev/mapper/volume-9ab99df5 is available for use
    Block device /dev/mapper/volume-7eab8fc1 is available for use

**IMPORTANT NOTE:** Consider using the "-m queue" flag when attaching storage to configure multipath queuing. If block storage becomes unreachable, the option "fail" results in FS read-only and "queue" will keep IO in memory buffer until reachable. See "-h" for usage details.



**Detach a volume**

1. Unmount the filesystem on any block storage volume that may be in use
2. Execute packet-block-storage-detach from within the OS on the server in question
3. Click on the storage volume from the storage tab within your Packet.net project and click on Detach

Example:

    [root@cent7-pbs-client dlaube]# packet-block-storage-detach

## Docker
The utility can be run as a docker container:

```
docker run -d -v /dev:/dev -v /lib/modules:/lib/modules --privileged packethost/packet-block-storage 
```

When run as a docker container, it will _not_ attach any storage volumes. It _only_ will:

1. Check that the multipath kernel module is loaded and, if not, attempt to load it.
2. Configure iscsi and multipath
3. Launch any background processes necessary, i.e. `iscsid` and `multipathd`.

It is expected that other processes will attach volumes.

In this mode, it is useful to run as a `DaemonSet` for kubernetes.

When running as a docker daemon, it has several unique requirements:

* Run with `--privileged` flag, or at least the minimum capabilities necessary.
* `/dev` MUST be mapped into the container.
* `/lib/modules` SHOULD be mapped into the container, so that it can attempt to load the `dm_multipath` kernel module. If you already have this module loaded and running, this mapping is unnecessary..

