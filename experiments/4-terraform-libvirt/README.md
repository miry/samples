# Terraform libvirt

There is no simple, quick start of usage `libvirt`.
I came to the [terraform-provider-libvirt]
to find a solution to operate Qemu virtual machines as clouds.
Without any knowledge of `libvirt`, I started checking the [examples](https://github.com/dmacvicar/terraform-provider-libvirt/tree/master/examples/v0.12/ubuntu).

There are similar articles about how to use [terraform-provider-libvirt]:

- https://computingforgeeks.com/how-to-provision-vms-on-kvm-with-terraform/
- https://computingforgeeks.com/how-to-install-terraform-on-ubuntu-centos-7/
- https://titosoft.github.io/kvm/terraform-and-kvm/

Documentation about resources, you can find in https://github.com/dmacvicar/terraform-provider-libvirt/tree/master/website/docs/r.

During my experiments, I copied everything from the ubuntu example.
I made a small mistake and reported the problem https://github.com/dmacvicar/terraform-provider-libvirt/issues/672.
I thought that cloud-init iso should be a bootable disk, and then load a kernel from the image.

## Here is what I did wrong

### Machines

Terraform finished with success after apply. Next step, check where is this machine is running and how can I access it.
There is no documentation of how can I verify the libvirt work.
After search the internet, I found a tool [virsh](https://linux.die.net/man/1/virsh).


```shell
$ virsh list
 Id Name State
--------------------


```

The list was empty. Next attempt to use

```shell
$ sudo virsh list --all
```

That returned the list of domains with a name that specified with status `running`.


### Machine Address

Added `output` with machine address:

```hcl
output "master_address" {
 value = concat(libvirt_domain.domain-ubuntu.network_interface.*.addresses)
}
```

To show the current address.

```shell
$ terraform output address
```

Other solution via command line:

```shell
$ sudo virsh net-list
Name State Autostart Persistent
--------------------------------------------
 default active yes yes

$ sudo virsh net-dhcp-leases default
Expiry Time MAC address Protocol IP address Hostname Client ID or DUID
-----------------------------------------------------------------------------------

....
```

### Console

Next step I tried to access machine via SSH.

```shell
$ terraform output address
$ ssh root@<address>
```

It was next failed. It means the cloud init config was not correctly setup.
How can I debug machine booting process?

Found logs of libvirt:

```shell
$ sudo less /var/log/libvirt/qemu/ubuntu-terraform.log
```

This information was not enough. It contains only qemu command line to boot the machine.

Next command, I found very useful:

```shell
$ sudo virsh console ubuntu-terraform
```

It allows connecting to the terminal with login. I tried any combination of cloud-init config, still nothing.

At last, I found a UI tool to show libvirt machines: [virt-manager]

```shell
$ sudo dnf install virt-manager
$ virt-manager
```

It gives a desktop app to check the details of the running machines. There are controls to operate machines.
I restarted the created machine and tried to check loading logs.
It was too fast :)
It also gives console access to machines and the ability to send commands like switch terminals: `CTRL+ALT+1`

### Review configs

In the end, I started to investigate how the cloud-init iso is working. Checked the [code](https://github.com/dmacvicar/terraform-provider-libvirt/blob/master/libvirt/cloudinit_def.go#L135) and found it is very primitive and easy to debug.

```shell
$ TF_LOG=debug terraform apply -target=libvirt_cloudinit_disk.cloudinit
```

In the output, I found the full command of how the iso was created. I understand the problem - it is not to be bootable at all.
I remember a similar problem when cloud-init is not working for AWS resources. When there is missing the first line: `#cloud-init`
Because there are 2 formats of cloud-init user data: shell or YAML.
More sample of cloud-init for ISO [here](https://cloudinit.readthedocs.io/en/latest/topics/datasources/nocloud.html).
After this fix, everything started work: console login and ssh connection.


## Useful commands

Before find `virt-manager`, I struggled with rebuilding volumes and domains.
The provider does not provide an excellent way to clean them.

```shell
$ sudo virsh shutdown <domain> : Stop the current virtual machine
$ sudo virsh undefine <domain> : Destroy a stopped machine
$ sudo virsh pool-destroy <pool name> : Destroy volume pool
```

[terraform-provider-libvirt]: https://github.com/dmacvicar/terraform-provider-libvirt
