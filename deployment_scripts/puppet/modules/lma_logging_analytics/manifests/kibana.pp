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
  $listen_address,
  $listen_port,
  $es_host = 'localhost',
  $es_port = 9200,
  $es_scheme = 'http',
  $version = '4.5.1'
) {

  include lma_logging_analytics::params

  $kibana_dir    = $lma_logging_analytics::params::kibana_dir
  $kibana_conf   = $lma_logging_analytics::params::kibana_config
  $default_route = $lma_logging_analytics::params::kibana_default_route

  package { 'kibana':
    ensure => $version,
  }

  file { '/opt/kibana/config/kibana.yml':
    ensure  => present,
    content => template('lma_logging_analytics/kibana4.yaml.erb'),
    notify  => Service['kibana'],
    require => Package['kibana'],
  }

  service { 'kibana':
    ensure     => 'running',
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    require    => Package['kibana'],
  }
}
