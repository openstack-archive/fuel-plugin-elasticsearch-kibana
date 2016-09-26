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
  $ldap_enabled = false,
  $ldap_protocol = undef,
  $ldap_servers = [],
  $ldap_port = undef,
  $ldap_bind_dn = undef,
  $ldap_bind_password = undef,
  $ldap_user_search_base_dns = undef,
  $ldap_user_search_filter = undef,
  $ldap_user_attribute = undef,
  $ldap_authorization_enabled = false,
  $listen_port_viewer = undef,
  $ldap_group_attribute = undef,
  $ldap_admin_group_dn = undef,
  $ldap_viewer_group_dn = undef,
) {

  include lma_logging_analytics::params

  validate_integer($listen_port)
  validate_integer($kibana_port)

  $default_apache_modules = ['proxy', 'proxy_http', 'rewrite',
    'authn_file', 'auth_basic', 'authz_user']

  if $ldap_enabled {
    if empty($ldap_servers) {
      fail('ldap_servers list parameter is empty')
    }
    if ! is_array($ldap_servers) {
      fail('ldap_servers list parameter must be an array')
    }
    if ! $ldap_port { fail('Missing ldap_port parameter')}
    if ! $ldap_protocol { fail('Missing ldap_protocol parameter')}
    if ! $ldap_bind_dn { fail('Missing ldap_bind_dn parameter')}
    if ! $ldap_bind_password { fail('Missing ldap_bind_password parameter')}
    if ! $ldap_user_search_base_dns { fail('Missing ldap_user_search_base_dns parameter')}
    if ! $ldap_user_search_filter { fail('Missing ldap_user_search_filter parameter')}
    if ! $ldap_user_attribute { fail('Missing ldap_user_attribute parameter')}

    if $ldap_authorization_enabled {
      if ! $ldap_group_attribute {fail('Missing ldap_group_attribute parameter')}
      if ! $ldap_admin_group_dn {fail('Missing ldap_admin_group_dn parameter')}
      if ! $ldap_viewer_group_dn {fail('Missing ldap_viewer_group_dn parameter')}
      if ! $listen_port_viewer {fail('Missing listen_port_viewer parameter')}

      validate_integer($listen_port_viewer)
    }
    $apache_modules = concat($default_apache_modules, ['ldap', 'authnz_ldap'])

    # LDAP url is used by apache::custom_config
    $ldap_servers_url = join(suffix($ldap_servers, ":${ldap_port}"), ' ')
    $ldap_url = "${ldap_servers_url}/${ldap_user_search_base_dns}?${ldap_user_attribute}?sub?${ldap_user_search_filter}"
  } else {
    $apache_modules = $default_apache_modules
  }

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

  if $ldap_authorization_enabled {
    apache::custom_config { 'kibana-proxy':
      content => template('lma_logging_analytics/apache_kibana_proxy.conf.erb'),
      require => [Class['apache'], File[$htpasswd_file]],
    }
    apache::listen { "${listen_address}:${listen_port_viewer}": }
    apache::custom_config { 'kibana-proxy-viewer':
      content => template('lma_logging_analytics/apache_kibana_proxy_viewer.conf.erb'),
      require => [Class['apache'], File[$htpasswd_file]],
    }
  } else {
    apache::custom_config { 'kibana-proxy':
      content => template('lma_logging_analytics/apache_kibana_proxy.conf.erb'),
      require => [Class['apache'], File[$htpasswd_file]],
    }
  }
}
