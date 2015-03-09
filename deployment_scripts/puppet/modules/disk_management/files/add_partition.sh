#!/bin/bash

# Use this script if you want to allocate a new partition.
# Ubuntu and CentOS are not configured the same way by Fuel. CentOS is doing
# RAID 1 with /boot on all disks so we need to deal with that.

# $1 -> The distribution (centos or anything else)
# $2 -> The disk (example: "/dev/sdb")
# $3 -> The RAID device (by default it is "/dev/md0")

set -eux

DISTRIB=$1
DISK=$2
RAID=${3:-/dev/md0}

[[ ${DISTRIB} = "centos" ]] && MDADM=$(which mdadm 2>/dev/null)
PARTED="$(which parted 2>/dev/null) -s"
PARTPROBE=$(which partprobe 2>/dev/null)

function add_new_partition {
    FREESPACE=$(${PARTED} ${DISK} unit s p free | grep "Free Space" | awk '{print $1, $2}')
    if [[ -z "${FREESPACE}" ]]; then
        echo "Failed to find free space"
        exit 1
    fi

    ${PARTED} ${DISK} unit s mkpart primary ${FREESPACE} &> /dev/null
}

if [[ ${DISTRIB} = "centos" ]]; then
    # Get the partition involved into RAID.
    PARTITION=$(${MDADM} -D ${RAID} | grep "active" | grep ${DISK} | awk '{print $7}')

    # Remove the partition from RAID.
    ${MDADM} ${RAID} --fail ${PARTITION} --remove ${PARTITION} &>/dev/null
fi

if ${PARTED} ${DISK} print | grep -q "unrecognised disk label"; then
    # We need to create a new label
    ${PARTED} ${DISK} mklabel gpt
fi

# Create a new partition
add_new_partition ${DISK}

# Get the ID of the partition and set flags to LVM
PARTID=$(${PARTED} -m ${DISK} p | tail -1 | awk -F: {'print $1'})
${PARTED} ${DISK} set ${PARTID} lvm on


# For centos Add the partition that belongs to the raid.
[[ ${DISTRIB} = "centos" ]] && ${MDADM} --add  ${RAID} ${PARTITION}

# The previous test can fail and then we will end with 1
# So be sure to exit with 0.
exit 0
