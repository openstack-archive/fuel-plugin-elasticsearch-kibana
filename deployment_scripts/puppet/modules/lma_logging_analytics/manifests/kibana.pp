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
  $es_host = 'localhost',
) {

  include lma_logging_analytics::params

  $kibana_dir    = $lma_logging_analytics::params::kibana_dir
  $kibana_conf   = $lma_logging_analytics::params::kibana_config
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
