#!/bin/bash

# Use this script if you want to allocate a new partition.
# Ubuntu and CentOS are not configured the same way by Fuel. CentOS is doing
# RAID 1 with /boot on all disks so we need to deal with that.

# $1 -> The disk (example: "/dev/sdb")

set -eux

DISK=$1
PARTED="$(which parted 2>/dev/null) -s -m"

if ${PARTED} ${DISK} p | grep -q "unrecognised disk label"; then
    # We need to create a new label
    ${PARTED} ${DISK} mklabel gpt
fi

# We take the free space at the end of the disk.
FREESPACE=$(${PARTED} ${DISK} unit s p free | grep "free" | tail -1 | awk -F: '{print $2, $3}')
if [[ -z "${FREESPACE}" ]]; then
    echo "Failed to find free space"
    exit 1
fi

CURRENTPARTID=$(${PARTED} ${DISK} p | tail -1 | awk -F: {'print $1'})

# If you create a partition on a mounted disk, this command returns 1
# So we need a different way to catch the error
set +e
${PARTED} ${DISK} unit s mkpart primary ${FREESPACE} &> /dev/null

# Get the ID of the partition and set flags to LVM
NEWPARTID=$(${PARTED} ${DISK} p | tail -1 | awk -F: {'print $1'})

if [[ ${NEWPARTID} = ${CURRENTPARTID} ]]; then
    # We catch a real error here
    exit 1
fi

${PARTED} ${DISK} set ${NEWPARTID} lvm on
exit 0
