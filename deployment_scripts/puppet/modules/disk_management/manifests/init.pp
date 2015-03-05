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
    $lv_name = $disk_management::params::lv_name,
    $vg_name = $disk_management::params::vg_name,
    $device  = $disk_management::params::device,
    $fstype  = $disk_management::params::fstype,

) inherits disk_management::params {

    # Creates the logical volume
    lvm::volume { $lv_name:
      ensure => present,
      pv     => $disks,
      vg     => $vg_name,
      fstype => $fstype,
    }

    # create the directory
    file { $directory:
      ensure => directory,
    }

    # Mount the directory
    mount { $directory:
      device  => $device,
      ensure  => mounted,
      fstype  => $fstype,
      options => "defaults",
      require => [File[$directory], Lvm::Volume[$lv_name]],
    }

}
