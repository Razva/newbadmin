### Proxmox Template Generator
#
# "vmid" represents the ID of the Template you are generating
# "image" represents the location of the QCOW2 image you are using in order to generate the Template
# "storage" represents the storage location on which you would like to store the Template
# "network" represents the network device that will be used by the Template
# "ram" represents the ammount of memory you are allocating to the Template
#
### Configuration below ###
vmid="999"
image="/root/CentOS-7-x86_64-GenericCloud.qcow2"
storage="local-zfs"
network="vmbr1"
ram="1024"
#### STOP Editing ###

echo "Creating VM..."
qm create $vmid --memory $ram --net0 virtio,bridge=$network
echo "Importing disk..."
qm importdisk $vmid $image $storage
echo "Attaching disk to VM..."
qm set $vmid --scsihw virtio-scsi-pci --scsi0 $storage:vm-$vmid-disk-0
echo "Attaching Cloudinit Drive..."
qm set $vmid --ide2 $storage:cloudinit
echo "Setting boot disk..."
qm set $vmid --boot c --bootdisk scsi0
echo "Adding serial console..."
qm set $vmid --serial0 socket --vga serial0
echo "Converting to Template..."
qm template $vmid
echo "DONE"
