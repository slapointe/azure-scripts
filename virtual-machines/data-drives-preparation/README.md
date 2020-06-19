# Consistent Azure VM data drives preparation, format & lettering

When dealing with Windows virtual machines from the marketplace on Azure, sometimes a CD-ROM will temporarily be present in the first moments in the lifetime of the VM. Microsoft needs this drive to perform various actions like preparing and licensing the VM. This is an adaptation from a Microsoft script I got my hands on to always ensure my data disks drive letters are consistent across reboot, de-allocate, re-image & host relocation on Azure.

It will move (if present) the CD-ROM drive to letter Z and perform initialization, formatting and assignation of drive letters for all un-initialized disks from letter E to Y.