class kibana (
    $kibana_dir  = $kibana::params::dir
    $kibana_conf = $kibana::params::config
    $kibana_dash = $kibana::params::dashboard
) inherits kibana::params {

    # Deploy kibana
    file { $kibana_dir:
      source  => "puppet:///modules/kibana/src",
      recurse => true,
    }

    # Replace config.js and add logs.json.
    file { $kibana_conf:
      ensure  => file,
      content => template('kibana/config.js.erb'),
      require => File[$kibana_dir],
    }

    file { $kibana_dash:
      source  => "puppet:///modules/kibana/logs.json",
      require => File[$kibana_dir],
    }

    # Install nginx
    class { 'nginx':
      manage_repo           => false,
      nginx_vhosts          => { 'kibana.local' => { 'www_root' => $kibana_dir } },
      nginx_vhosts_defaults => { 'listen_options' => 'default_server' },
      require               => File[$kibana_conf],
    }
}
