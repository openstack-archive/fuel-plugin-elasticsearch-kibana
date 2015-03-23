# Class lma_logging_analytics::kibana

class lma_logging_analytics::kibana (
    $kibana_dir  = $lma_logging_analytics::params::kibana_dir,
    $kibana_conf = $lma_logging_analytics::params::kibana_config,
    $kibana_dash = $lma_logging_analytics::params::kibana_dashboard,
) inherits lma_logging_analytics::params {

  # Deploy kibana
  file { $kibana_dir:
    source  => 'puppet:///modules/lma_logging_analytics/kibana/src',
    recurse => true,
  }

  # Replace config.js
  file { $kibana_conf:
    ensure  => file,
    content => template('lma_logging_analytics/config.js.erb'),
    require => File[$kibana_dir],
  }

  file { $kibana_dash:
    source  => 'puppet:///modules/lma_logging_analytics/kibana_dashboards/logs.json',
    require => File[$kibana_dir],
  }

  # Install nginx
  class { 'nginx':
    manage_repo           => false,
    nginx_vhosts          => {
      'kibana.local' => {
        'www_root' => $kibana_dir
      }
    },
    nginx_vhosts_defaults => {
      'listen_options' => 'default_server'
    },
    require               => File[$kibana_conf],
  }
}
