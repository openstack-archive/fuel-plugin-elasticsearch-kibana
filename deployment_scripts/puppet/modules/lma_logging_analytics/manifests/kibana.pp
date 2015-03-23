# Class lma_logging_analytics::kibana


class lma_logging_analytics::kibana {
  include lma_logging_analytics::params

  $kibana_dir    = $lma_logging_analytics::params::kibana_dir
  $kibana_conf   = $lma_logging_analytics::params::kibana_config
  $dashboard_dir = $lma_logging_analytics::params::kibana_dashboard_dir
  $default_route = $lma_logging_analytics::params::kibana_default_route

  # Deploy Kibana
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

  file { "${dashboard_dir}/logs.json":
    content => template('lma_logging_analytics/kibana_dashboards/logs.json'),
    require => File[$kibana_dir],
  }

  lma_logging_analytics::kibana_dashboard { 'logs':
    content => template('lma_logging_analytics/kibana_dashboards/logs.json'),
    require => File["${dashboard_dir}/logs.json"],
  }

  file { "${dashboard_dir}/notifications.json":
    content => template('lma_logging_analytics/kibana_dashboards/notifications.json'),
    require => File[$kibana_dir],
  }

  lma_logging_analytics::kibana_dashboard { 'notifications':
    content => template('lma_logging_analytics/kibana_dashboards/notifications.json'),
    require => File["${dashboard_dir}/notifications.json"],
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
