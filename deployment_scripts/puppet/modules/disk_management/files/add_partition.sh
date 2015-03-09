#!/bin/bash

# Use this script if you want to allocate a new partition.

# $1 is the disk (for example: /dev/sdc)

set -eux

DISK=$1

PARTED=$(which parted 2>/dev/null)
PARTPROBE=$(which partprobe 2>/dev/null)

function add_new_partition {
    FREESPACE=$(${PARTED} ${DISK} unit s p free | grep "Free Space" | awk '{print $1, $2}')
    if [[ -z "${FREESPACE}" ]]
    then
        echo "Failed to find free space"
        exit 1
    fi

    ${PARTED} -s -- ${DISK} unit s mkpart primary ${FREESPACE} &> /dev/null
}

if ${PARTED} ${DISK} print | grep -q "unrecognised disk label"; then
    # We need to create a new label
    ${PARTED} ${DISK} mklabel gpt
fi

# Create a new partition
add_new_partition ${DISK}

# Get the ID of the partition and set flags to LVM
PARTID=$(${PARTED} ${DISK} p | grep -v "^$" | tail -1 | awk {'print $1'})
${PARTED} ${DISK} set ${PARTID} lvm on
