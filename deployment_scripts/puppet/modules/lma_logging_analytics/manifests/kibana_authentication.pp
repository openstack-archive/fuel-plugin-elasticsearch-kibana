#    Copyright 2016 Mirantis, Inc.
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
# Class lma_logging_analytics::kibana_authentication

class lma_logging_analytics::kibana_authentication (
  $listen_address,
  $listen_port,
  $kibana_port,
  $kibana_address,
  $username,
  $password,
) {

  include lma_logging_analytics::params

  $apache_modules = ['proxy', 'proxy_http', 'rewrite',
                    'authn_file', 'auth_basic', 'authz_user']

  ## Configure apache
  class { 'apache':
    # be good citizen by not erasing other configurations
    purge_configs       => false,
    default_confd_files => false,
    default_vhost       => false,
    mpm_module          => false,
    default_mods        => $apache_modules,
  }

  apache::listen { "${listen_address}:${listen_port}": }

  $htpasswd_file = $lma_logging_analytics::params::apache_htpasswd_file
  htpasswd { $username:
    cryptpasswd => ht_md5($password, 'salt'),
    target      => $htpasswd_file,
    require     => Class['apache'],
  }

  file { $htpasswd_file:
    ensure  => present,
    mode    => '0440',
    owner   => $::apache::user,
    group   => $::apache::group,
    require => Class[Apache],
  }

  apache::custom_config { 'kibana-proxy':
    content => template('lma_logging_analytics/apache_kibana_proxy.conf.erb'),
    require => [Class['apache'], File[$htpasswd_file]],
  }
}
