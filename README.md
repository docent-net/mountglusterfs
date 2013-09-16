mountglusterfs
==============

Init scripts (Debian LSB && RHEL SysVinit).

Those scripts provide scripts for mounting GlusterFS based drives in proper 
order during startup. For example having gluster server on same machine where
mounting provided by this server mountpoints it's impossible to mount it with
_netdev option from fstab because by default mountnfs is started before 
gluster-server service.

With below scripts You can set new system service, which mounts all glusterfs
partitions entered in /etc/fstab with _netdev option.

Installation:
--------------
**Debian**: copy debian/mountglusterfs.sh to /etc/init.d and run command:
*update-rc.d mountglusterfs.sh defaults*

After that you can use mountglusterfs keyword in "Required start:" option of 
choosen LSB scripts. For more informations go to:

- LSB scripts: https://wiki.debian.org/LSBInitScripts
- Dependency based boot: https://wiki.debian.org/LSBInitScripts/DependencyBasedBoot

Usage:
--------------
After installing create new /etc/fstab records using 'glusterfs' as fstype and
_netdev as additional mount option. After rebooting those resources should be 
mounted in choosen order.

Todo:
--------------
- RHEL & CentOS scripts