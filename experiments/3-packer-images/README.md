How to automate building local virtual machines with Packer
===========================================================

We will learn how to create a disk image base on a remote iso disk image. Auto install packages and configure a virtual machine with a small configuration file. Setup another disk image, this time, the source would have a different format.

There are multiple ways to build a virtual machine for experiments.
One of the easiest ways is to use [Packer].
[Packer] has a big list of integrations: cloud providers, virtual machines, and containers.

# Table of Contents

1. [Preparation](#preparation)
1. [Step 1 - Building a base image](#step-1---building-a-base-image)
1. [Step 2 - Building a docker image](#step-3---building-a-docker-image)
1. [Conclusion](#conclusion)
1. [References](#references)

# Preparation

- Install [Packer] in your environment. There are multiple [options](https://www.packer.io/intro/getting-started/install.html).
- In this tutorial, I am going to use [Qemu], but you can port examples to any other [Packer builders](https://www.packer.io/docs/builders/index.html).

## Step 1 - Building a base image

In this step, I show you how to install [Centos] with preinstall packages.

### Build configuration file

Before start, visit the documentation page of [Packer Qemu builder].
There is a basic example with all the required options.
I created a modified version and saved to [`centos.json`](https://github.com/miry/samples/tree/packer-build-automate/experiments/3-packer-images/):

```json
{
  "variables": {
    "centos_password": "centos",
    "version": "1908"
  },

  "builders": [
    {
      "vm_name": "centos-packer.qcow2",

      "iso_urls": [
        "iso/CentOS-7-x86_64-Minimal-{{ user `version` }}.iso",
        "http://mirror.de.leaseweb.net/centos/7/isos/x86_64/CentOS-7-x86_64-Minimal-{{ user `version` }}.iso"
      ],
      "iso_checksum_url": "http://mirror.de.leaseweb.net/centos/7/isos/x86_64/sha256sum.txt",
      "iso_checksum_type": "sha256",
      "iso_target_path": "iso",
      "output_directory": "output-centos",
      "ssh_username": "centos",
      "ssh_password": "{{ user `centos_password` }}",
      "ssh_wait_timeout": "20m",
      "http_directory": "http",
      "boot_command": [
        "<tab> text ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ks.cfg<enter><wait>"
      ],
      "boot_wait": "2s",
      "shutdown_command": "echo '{{ user `centos_password` }}' | sudo -S /sbin/halt -h -p",
      "type": "qemu",
      "headless": true,
      "memory": "4096",
      "cpus": 4
    }
  ]
}
```

Main changes:

- Use [`iso_urls`](https://www.packer.io/docs/builders/qemu.html#iso_urls), instead of [`iso_url`](https://www.packer.io/docs/builders/qemu.html#iso_url).
It tries to download one by one from the provided list. It allows reusing files that already downloaded.
- Set [`headless`](https://www.packer.io/docs/builders/qemu.html#headless) to `true` to hide [Qemu] window.
For debugging purposes, you can change it to `false`.
- Important option [`http_directory`](https://www.packer.io/docs/builders/qemu.html#http_directory).

[Packer] helps us to run a `HTTP` web server for the automation [Linux] setup process.
With this option, I specified where is the root web dir located.
In the case of [Centos], we rely on [Kickstart2] to automate the installation process.
It works in tandem with `boot_command`, where we specify `IP` and
port of our HTTP web server and the path to [Kickstart2] config file `ks.cfg`.

To make it works, create a new file `ks.cfg` under catalog `http`:

```
install
cdrom
lang en_US.UTF-8
keyboard us
unsupported_hardware
network --bootproto=dhcp
firewall --disabled
authconfig --enableshadow --passalgo=sha512
selinux --permissive
timezone UTC
bootloader --location=mbr
text
skipx
zerombr
clearpart --all --initlabel
autopart
auth  --useshadow  --enablemd5
firstboot --disabled
reboot
rootpw MAGICROOTPASSWORD
user --name=centos --groups=centos --password=centos

%packages --ignoremissing --excludedocs
@Base
@Core
@Development Tools
-@Graphical Internet
openssl-devel
readline-devel
zlib-devel
kernel-devel
wget
curl
%end

%post
yum install -y epel-release
yum update -y
yum install -y httping iftop iperf3 ivpsadm net-tools nmap-ncat ntp sysstat tcpdump telnet tmux tree vim wireshark yum-plugin-fastestmirror yum-utils zsh

sudo systemctl enable ntpd

# sudo
echo "centos ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# ssh key
mkdir /home/centos/.ssh
cat <<EOF >> /home/centos/.ssh/authorized_keys
<Your SSH public key>
EOF

chmod 0700 -R /home/centos/.ssh
chown centos:centos -R /home/centos/.ssh
sed -i "s/^.*requiretty/#Defaults requiretty/" /etc/sudoers
%end
```

Change passwords and authorize your SSH public key.

It is ready to start building a new image.

### Run building centos image task

```shell
$ packer build centos.json
==> qemu: Retrieving ISO
==> qemu: Trying iso/CentOS-7-x86_64-Minimal-1908.iso
...
==> Builds finished. The artifacts of successful builds are:
--> qemu: VM files in directory: output-centos
```

The image's path is `output-centos/centos-packer.qcow2`.

### Testing the base image

Run [Qemu] with attached our disk image as root volume.

```shell
$ qemu-system-x86_64 -name centos-packer \
                -netdev user,id=user.0,hostfwd=tcp::4141-:22 \
                -device virtio-net,netdev=user.0 \
                -drive file=output-centos/centos-packer.qcow2,if=virtio,cache=writeback,discard=ignore,format=qcow2 \
                -machine type=pc,accel=kvm \
                -smp cpus=4,sockets=4 \
                -m 4096M \
                -display sdl
```

For accessing the machine, use port forwarding from `localhost:4141` to remote `22`.

```shell
$ ssh centos@localhost -p 4141 -i <path/to/ssh.key>
...
[centos@localhost ~]$ cat .ssh/authorized_keys
<Your SSH public key>

[centos@localhost ~]$ sudo whoami
root
```

You can check logs of [Centos] installation:

```shell
$ sudo less /var/log/anaconda/ks-script-*.log
```

## Step 2 - Building a docker image

In this step, you are going to learn how to create a new disk image base on the existing one.
As the previous step, create a packer config [`docker.json`](https://github.com/miry/samples/tree/packer-build-automate/experiments/3-packer-images/):

```json
{
  "builders": [
    {
      "vm_name": "docker-packer.qcow2",

      "disk_image": true,
      "iso_url": "output-qemu/centos-packer-1908.qcow2",
      "iso_checksum_type": "none",

      "output_directory": "output-docker-image",

      "ssh_username": "centos",
      "ssh_password": "centos",
      "ssh_pty": true,
      "ssh_wait_timeout": "2m",

      "shutdown_command": "echo 'centos' | sudo -S /sbin/halt -h -p",

      "type": "qemu",
      "headless": true,
      "memory": "8192",
      "cpus": 4
    }
  ],
  "post-processors": null,
  "provisioners": [
    {
      "type": "shell",
      "scripts": [
        "{{template_dir}}/docker.sh"
      ]
    }
  ]
}
```

There 2 main options are different from first config: [`disk_image`](https://www.packer.io/docs/builders/qemu.html#disk_image) and [`provisioners`](https://www.packer.io/docs/provisioners/index.html).
In the `provisioners` section, you should specify the provision script. Create a sample [`docker.sh`](https://github.com/miry/samples/tree/packer-build-automate/experiments/3-packer-images/) file, mentioned in the config:

```shell
#!/usr/bin/env bash

set -euo pipefail

sudo yum install -y docker
sudo systemctl enable docker
```

After all config and provision script is ready, run:

### Run building docker image task

```shell
$ packer build docker.json
qemu output will be in this color.

Warnings for build 'qemu':

* A checksum type of 'none' was specified. Since ISO files are so big,
a checksum is highly recommended.

==> qemu: Retrieving ISO
==> qemu: Trying output-centos/centos-packer.qcow2
...
==> qemu: Connected to SSH!
==> qemu: Provisioning with shell script: docker.sh
...
    qemu: Complete!
==> qemu: Gracefully halting virtual machine...
==> qemu: Converting hard drive...
Build 'qemu' finished.

==> Builds finished. The artifacts of successful builds are:
--> qemu: VM files in directory: output-docker
```

The result saved to `output-docker/docker-packer.qcow2`.

### Testing the docker image

```shell
$ qemu-system-x86_64 -name docker-packer \
              -netdev user,id=user.0,hostfwd=tcp::4141-:22 \
              -device virtio-net,netdev=user.0 \
              -drive file=output-docker/docker-packer.qcow2,if=virtio,cache=writeback,discard=ignore,format=qcow2 \
              -machine type=pc,accel=kvm \
              -smp cpus=4,sockets=4 \
              -m 4096M \
              -display sdl
```

Login to the instance and check access to docker:

```shell
$ ssh centos@localhost -p 4141 -i <path/to/ssh.key>
...
[centos@localhost ~]$ sudo docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
```

## Conclusion

[Packer] can automate building not just clouds, but also local virtual machines.
Build images base on `raw` disk images or `iso`, as straightforward the write bash scripts.

## References

- [Packer]
- [Qemu]
- [Packer Qemu builder]
- [Centos]
- [Kickstart2]

[Packer]: https://www.packer.io/
[Qemu]: https://www.qemu.org/
[Packer Qemu builder]: https://www.packer.io/docs/builders/qemu.html
[Centos]: https://www.centos.org/
[Kickstart2]: https://docs.centos.org/en-US/centos/install-guide/Kickstart2/
