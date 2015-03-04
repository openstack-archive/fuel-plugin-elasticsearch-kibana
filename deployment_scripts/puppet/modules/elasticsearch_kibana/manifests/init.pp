class elasticsearch_kibana (
    $pv_name,
) {
    include elasticsearch_kibana::params

    # Creates the logical volume
    lvm::volume { $elasticsearch_kibana::params::lv_name:
      alias  => 'elasticsearch',
      ensure => present,
      vg     => $elasticsearch_kibana::params::vg_name,
      pv     => $pv_name,
      fstype => $elasticsearch_kibana::params::fstype,
    }

    # create the directory
    file { $elasticsearch_kibana::params::es_dir:
      alias  => 'es_dir',
      ensure => directory,
    }

    # Mount the directory
    mount { $elasticsearch_kibana::params::es_dir:
      alias   => 'es_dir',
      device  => $elasticsearch_kibana::params::device,
      ensure  => mounted,
      fstype  => $elasticsearch_kibana::params::fstype,
      options => "defaults",
      require => [File['es_dir'], Lvm::Volume['elasticsearch']],
    }

    # Ensure that java is installed
    package { $elasticsearch_kibana::params::java:
      alias  => 'java',
      ensure => installed,
    }

    # Install elasticsearch
    class { "elasticsearch":
      datadir => ["${elasticsearch_kibana::params::es_dir}/elasticsearch_data"],
      require => [Mount['es_dir'], Package['java']],
    }

    # Start an instance of elasticsearch
    elasticsearch::instance { $elasticsearch_kibana::params::es_instance:
      config => {
        "http.cors.allow-origin" => "/.*/",
        "http.cors.enabled" => "true"
      },
    }

    # Install nginx and kibana
    file { '/opt/kibana':
      source  => "puppet:///modules/elasticsearch_kibana/kibana",
      recurse => true,
    }

    class { 'nginx':
      manage_repo => false,
      nginx_vhosts => { 'kibana.local' => { 'www_root' => '/opt/kibana' } },
      nginx_vhosts_defaults => { 'listen_options' => 'default_server' },
      require     => File['/opt/kibana']
    }

}

