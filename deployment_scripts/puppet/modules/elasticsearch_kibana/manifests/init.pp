class elasticsearch_kibana (
    $pv_name,
) {
    include elasticsearch_kibana::params

    # Creates the logical volume
    lvm::volume { $elasticsearch_kibana::params::lv_name:
      ensure => present,
      vg     => $elasticsearch_kibana::params::vg_name,
      pv     => $pv_name,
      fstype => $elasticsearch_kibana::params::fstype,
    }

    # create the directory
    file { $elasticsearch_kibana::params::es_dir:
      ensure => directory,
    }

    # Mount the directory
    mount { $elasticsearch_kibana::params::es_dir:
      device  => $elasticsearch_kibana::params::device,
      ensure  => mounted,
      fstype  => $elasticsearch_kibana::params::fstype,
      options => "defaults",
      require => [File[$elasticsearch_kibana::params::es_dir], Lvm::Volume[$elasticsearch_kibana::params::lv_name]],
    }

    # Ensure that java is installed
    package { $elasticsearch_kibana::params::java:
      ensure => installed,
    }

    # Install elasticsearch
    class { "elasticsearch":
      datadir => ["${elasticsearch_kibana::params::es_dir}/elasticsearch_data"],
      require => [Mount[$elasticsearch_kibana::params::es_dir], Package[$elasticsearch_kibana::params::java]],
    }

    # Start an instance of elasticsearch
    elasticsearch::instance { $elasticsearch_kibana::params::es_instance: }
}

