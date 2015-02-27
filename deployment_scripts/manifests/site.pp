# Work is in progress....
define ek-volume(
    $pvname = $title,
    $ekdir = '/ek-data',
    $lvname = 'EKlv',
    $vgname = 'EKvg'
){
    $device = "/dev/$vgname/$lvname"

    # Creates the logical volume
    lvm::volume { $lvname:
      ensure => present,
      vg     => $vgname,
      pv     => $pvname,
      fstype => 'ext3',
    }

    # create the directory
    exec { "create ekdir":
      command => "/bin/mkdir -p ${ekdir}",
    }

    # Mount the directory
    exec { "mount ekdir":
      command => "/bin/mount ${device} ${ekdir}",
    }

    Lvm::Volume[$lvname] -> Exec["mount ekdir"]
    Exec["create ekdir"] -> Exec["mount ekdir"]
}

ek-volume { '/dev/sdb': }

