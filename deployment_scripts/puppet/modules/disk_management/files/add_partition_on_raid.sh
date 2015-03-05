#!/bin/bash

# Use this script if you want to allocate a new partition that is already used
# in RAID. It is the case for example with the current deployment of CentOS.

# $1 is the disk (for example: /dev/sdc)
# $2 is the raid : default is "/dev/md0"

set -eux

DISK=$1
RAID=${2:-"/dev/md0"}

MDADM=$(which mdadm 2>/dev/null)
PARTED=$(which parted 2>/dev/null)
PARTPROBE=$(which partprobe 2>/dev/null)

function add_new_partition {
    FREESPACE=$(${PARTED} "$1" unit s p free | grep "Free Space" | awk '{print $1, $2}')
    if [[ -z "${FREESPACE}" ]]
    then
        echo "Failed to find free space"
        exit 1
    fi

    ${PARTED} -s -- $1 unit s mkpart primary ${FREESPACE} &> /dev/null
}

# Check if the partition is involved into RAID. If not just quite.
PARTITION=$(${MDADM} -D ${RAID} | grep "active" | grep ${DISK} | awk '{print $7}')

# Remove the partition from RAID.
$MDADM $RAID --fail $PARTITION --remove $PARTITION &>/dev/null

# Create a new partition
add_new_partition $DISK

# Add the partition that belongs to the raid.
$MDADM --add  $RAID $PARTITION

