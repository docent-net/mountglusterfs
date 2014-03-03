#! /bin/bash
### BEGIN INIT INFO
# Provides:          mountglusterfs
# Required-Start:    $local_fs $network
# Required-Stop:     $local_fs $network
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Mount glusterfs drives
# Description:       When system services rely on glusterfs drives
#                    than those services' LSB scripts should have certainty
#                    that glusterfs based drives are up and running.
### END INIT INFO

. /lib/init/vars.sh
. /lib/init/mount-functions.sh
. /lib/lsb/init-functions

do_wait_sync_mount() {
	GLUSTER_DEVS=()
	GLUSTER_MTPTS=()
	GLUSTER_OPTS=()
	# Read through fstab line by line. If it is glusterfs and _netdev, set the 
	# flag for mounting glusterfs file systems.	
	for file in "$(eval ls $(fstab_files))"; do
		if [ -f "$file" ]; then
			while read DEV MTPT FSTYPE OPTS REST; do
				F_OPT=0
				F_FSTYPE=0
				case "$OPTS" in
				*_netdev*)
					F_OPT=1
					;;
				esac
				case "$FSTYPE" in
				glusterfs)
					F_FSTYPE=1
					;;
				esac
				
				if [ "$F_OPT" -eq "1" -a "$F_FSTYPE" -eq "1" ]; then
					GLUSTER_DEVS+=($DEV)
					GLUSTER_MTPTS+=($MTPT)
					GLUSTER_OPTS+=($OPTS)
				fi
			done < "$file"			
		fi
	done
	
	# Wait for each path, the timeout is for all of them as that's
	# really the maximum time we have to wait anyway
	TIMEOUT=900
	for ((i = 0; i <=  ${#GLUSTER_DEVS[@]}-1; i++)); do
		log_action_begin_msg "Mounting ${GLUSTER_DEVS[$i]} at " \
		"${GLUSTER_MTPTS[$i]}"

		while ! mountpoint -q ${GLUSTER_MTPTS[$i]}; do
			sleep 0.1
			mount -t glusterfs -o ${GLUSTER_OPTS[$i]} ${GLUSTER_DEVS[$i]} ${GLUSTER_MTPTS[$i]}
			
			TIMEOUT=$(( $TIMEOUT - 1 ))
			if [ $TIMEOUT -le 0 ]; then
				log_action_end_msg 1
				break
			fi			
		done
		
		if [ $TIMEOUT -gt 0 ]; then
			log_action_end_msg 0
		fi
	done
}

case "$1" in
    start)
		do_wait_sync_mount;;
    restart|reload|force-reload)
        echo "Error: argument '$1' not supported" >&2
        exit 3
        ;;
    stop)
        ;;
    *)
        echo "Usage: $0 start|stop" >&2
        exit 3
        ;;
esac

: exit 0
