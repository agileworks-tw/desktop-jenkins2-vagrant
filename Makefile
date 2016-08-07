miniVM:
	vagrant ssh -- -t 'sudo dd if=/dev/zero of=wipefile bs=1024x1024; rm -f wipefile'
	- vagrant halt
	VBoxManage clonehd ~/VirtualBox\ VMs/agileworks-vm/box-disk1.vmdk cloned.vdi --format vdi
	VBoxManage clonehd cloned.vdi ~/VirtualBox\ VMs/agileworks-vm/box-disk2.vmdk --format vmdk

cleanVM:
	rm ~/VirtualBox\ VMs/agileworks-vm/box-disk1.vmdk
	rm cloned.vdi

exportVM:
	vboxmanage export agileworks-vm -o agileworks-vm.ova
