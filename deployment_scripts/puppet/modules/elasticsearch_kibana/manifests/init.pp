class elasticsearch_kibana (
    $pv_name,
    $vg_name,
    $lv_name,
    $es_dir,
    $es_instance,
) {
    $device = "/dev/${vg_name}/${lv_name}"
    $fstype = "ext3"
    $java   = "openjdk-7-jre-headless"

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
      options => "defaults",
      require => [File[$es_dir], Lvm::Volume[$lv_name]],
    }

    # Ensure that java is installed
    package { $java:
      ensure => installed,
    }

    # Install elasticsearch
    class { "elasticsearch":
      datadir => ["${es_dir}/elasticsearch_data"],
      require => [Mount[$es_dir], Package[$java]],
    }

    # Start an instance of elasticsearch
    elasticsearch::instance { $es_instance: }
}

