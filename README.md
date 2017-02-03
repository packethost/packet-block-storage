# packet-block-storage

----
## Quick overview
This utility/helper script is made available to assist in  the attachment and detachment of Packet block storage volumes and is currently in testing. Use at your own risk and always have a backup/snapshot just in case!

# Features
* Attach block storage block devices
* Detach block storage block devices
* Configure multipath for HA
* Validate block device creation

# Dependencies

**Ubuntu/Debian**:

    apt-get install open-iscsi multipath-tools


**CentOS**:

    yum -y install iscsi-initiator-utils device-mapper-multipath

## Installation

**Using git:**

    sudo su -
    git clone git@github.com:promaethius/packet-block-storage.git
    cp ./packet-block-storage/packet-block-storage-* /usr/bin/
    chmod u+x /usr/bin/packet-block-storage-*

**or**

**Using wget**

    sudo su -
    wget -O /usr/bin/packet-block-storage-attach https://raw.githubusercontent.com/promaethius/packet-block-storage/master/packet-block-storage-attach
    wget -O /usr/bin/packet-block-storage-detach https://raw.githubusercontent.com/promaethius/packet-block-storage/master/packet-block-storage-detach
    chmod u+x /usr/bin/packet-block-storage-*

## Usage

**Attach a volume**

1. Create a volume under the Storage tab in your Packet.net portal account
2. Click on the storage volume, select the server you wish to attach the volume to and click on Attach.
3. Execute packet-block-storage-attach from within the OS on the server in question
4. Partition the block device at /dev/mapper/\{volume\_name\_here\} disk using parted, fdisk, etc
5. Make a filesystem on the block device
6. Mount the block device on the mount point of you choice

Example:

    [root@cent7-pbs-client dlaube]# packet-block-storage-attach
    Block device /dev/mapper/volume-9ab99df5 is available for use
    Block device /dev/mapper/volume-7eab8fc1 is available for use

**Detach a volume**

1. Unmount the filesystem on any block storage volume that may be in use
2. Execute packet-block-storage-detach from within the OS on the server in question
3. Click on the storage volume from the storage tab within your Packet.net project and click on Detach

Example:

    [root@cent7-pbs-client dlaube]# packet-block-storage-detach

