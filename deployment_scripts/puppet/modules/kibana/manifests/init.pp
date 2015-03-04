class kibana {

    $kibana_dir = '/opt/kibana'
    $kibana_conf = "${kibana_dir}/config.js"
    $kibana_dash = "${kibana_dir}/app/dashboards/logs.json"

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
      ensure  => file,
      content => template('kibana/logs.json.erb'),
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
