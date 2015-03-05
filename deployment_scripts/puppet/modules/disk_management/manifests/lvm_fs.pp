define disk_management::lvm_fs (
  $disks,
  $lv_name,
  $vg_name,
  $fstype = "ext3",
) {

  $directory = $title
  $device  = "/dev/${vg_name}/${lv_name}"

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
