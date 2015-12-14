#    Copyright 2015 Mirantis, Inc.
#
#    Licensed under the Apache License, Version 2.0 (the "License"); you may
#    not use this file except in compliance with the License. You may obtain
#    a copy of the License at
#
#         http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
#    WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
#    License for the specific language governing permissions and limitations
#    under the License.
#
# Class lma_logging_analytics::kibana


class lma_logging_analytics::kibana (
  $number_of_replicas = $lma_logging_analytics::params::kibana_replicas,
  $es_host = 'localhost',
) inherits lma_logging_analytics::params {

  validate_integer($number_of_replicas)

  $kibana_dir    = $lma_logging_analytics::params::kibana_dir
  $kibana_conf   = $lma_logging_analytics::params::kibana_config
  $dashboard_dir = $lma_logging_analytics::params::kibana_dashboard_dir
  $default_route = $lma_logging_analytics::params::kibana_default_route

  # Deploy Kibana
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

  elasticsearch::template { 'kibana':
    content => "{\"template\":\"kibana-*\", \"settings\": {\"number_of_replicas\":${number_of_replicas}}}",
    host    => $es_host,
  }

  # Note that the dashboards are stored in templates/ because it is the only way
  # for us to read the content of the file. Ideally we would have used the
  # file() function but until Puppet 3.7 it works only with absolute paths.
  # See http://www.unixdaemon.net/tools/puppet/puppet-3.7-file-function.html
  # for details
  lma_logging_analytics::kibana_dashboard { 'logs':
    content => template('lma_logging_analytics/kibana_dashboards/logs.json'),
    host    => $es_host,
    require => [File["${dashboard_dir}/logs.json"], Elasticsearch::Template['kibana']],
  }

  file { "${dashboard_dir}/notifications.json":
    content => template('lma_logging_analytics/kibana_dashboards/notifications.json'),
    require => File[$kibana_dir],
  }

  lma_logging_analytics::kibana_dashboard { 'notifications':
    content => template('lma_logging_analytics/kibana_dashboards/notifications.json'),
    require => [File["${dashboard_dir}/notifications.json"], Elasticsearch::Template['kibana']],
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
