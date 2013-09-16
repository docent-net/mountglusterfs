mountglusterfs
==============

Init scripts (Debian LSB && RHEL SysVinit).

Those scripts gives you solution for situation when auto-mounting glusterfs drives
served by gluster-server hosted on same machine. When using Debian and insserv with
dependency based boot partitions with _netdev option given in /etc/fstab are 
mounted by /etc/init.d/mountnfs which is started earlier than 
/etc/init.d/gluster-server - and I couldn't find any way to change that order even 
when using Required-Start or X-Start-Before/After.

With below scripts You can set new system service, which mounts all glusterfs
partitions entered in /etc/fstab with _netdev option and use that service to write 
another init scripts for any services and create dependency trees.

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
mounted in choosen order. Example line from fstab:

- *your.host.com:/puppet-volume /etc/puppet/ha_cfg/     glusterfs       _netdev 0 0*

Todo:
--------------
- RHEL & CentOS scripts