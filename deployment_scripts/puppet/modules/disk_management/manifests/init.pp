# == Class: disk_management
#
# The disk_management class will create a logical volume above the disks
# given as parameter and mount the direcory on this volume.
#
# === Parameters
#
# [*disks*]
#   The disks to use to create the physical volumes.
#
# [*directory*]
#   The name of the directory that will be mount on created logical volumes.
#
# === Examples
#
#  class { 'disk_management':
#    disks     => ['/dev/sdb', '/dev/sdc'],
#    directory => "/data",
#  }
#
# === Authors
#
# Guillaume Thouvenin <gthouvenin@mirantis.com
#
# === copyright
#
# Copyright 2015 Mirantis Inc, unless otherwise noted.
#
class disk_management (
  $disks,
  $directory,
  $lv_name,
  $vg_name,
) {

  disk_management::partition { $disks:
  }

  disk_management::lvm_fs { $directory:
    disks   => $disks,
    lv_name => $lv_name,
    vg_name => $vg_name,
    require => Disk_management::Partition[$disks],
  }

}
