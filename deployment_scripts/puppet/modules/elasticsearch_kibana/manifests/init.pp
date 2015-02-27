class elasticsearch_kibana (
    $pv_name,
    $vg_name,
    $lv_name,
    $es_dir,
    $es_version,
    $es_instance,
) {
    $device = "/dev/${vg_name}/${lv_name}"
    $fstype = "/dev/ext3"

    # Creates the logical volume
    lvm::volume { $lv_name:
      ensure => present,
      vg     => $vg_name,
      pv     => $pv_name,
      fstype => $fstype,
    }

    # create the directory
    file { $es_dir:
      ensure => directory,
    }

    # Mount the directory
    mount { $es_dir:
      device  => $device,
      ensure  => mounted,
      fstype  => $fstype,
      require => [File[$es_dir], Lvm::Volume[$lv_name]],
    }

    # Install elasticsearch
    class { "elasticsearch":
      version  => $es_version,
      datadir  => [$es_dir],
      required => Mount[$es_dir],
    }

    # Start an instance of elasticsearch
    elasticsearch::instance { $es_instance: }
}

