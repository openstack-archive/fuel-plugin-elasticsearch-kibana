# Copyright 2015 Mirantis, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.

notice('fuel-plugin-elasticsearch-kibana: kibana.pp')

class { 'lma_logging_analytics::kibana':
  listen_address => '127.0.0.1',
  listen_port    => hiera('lma::elasticsearch::kibana_port'),
  es_host        => hiera('lma::elasticsearch::vip'),
  es_port        => hiera('lma::elasticsearch::rest_port'),
  version        => '4.5.1',
}

$authnz = hiera_hash('lma::kibana::authnz')
class { 'lma_logging_analytics::kibana_authentication':
  listen_address             => hiera('lma::elasticsearch::listen_address'),
  listen_port                => hiera('lma::elasticsearch::apache_port'),
  kibana_address             => '127.0.0.1',
  kibana_port                => hiera('lma::elasticsearch::kibana_port'),
  username                   => $authnz['username'],
  password                   => $authnz['password'],
  ldap_enabled               => $authnz['ldap_enabled'],
  ldap_protocol              => $authnz['ldap_protocol'],
  ldap_port                  => $authnz['ldap_port'],
  ldap_servers               => $authnz['ldap_servers'],
  ldap_bind_dn               => $authnz['ldap_bind_dn'],
  ldap_bind_password         => $authnz['ldap_bind_password'],
  ldap_user_search_base_dns  => $authnz['ldap_user_search_base_dns'],
  ldap_user_search_filter    => $authnz['ldap_user_search_filter'],
  ldap_user_attribute        => $authnz['ldap_user_attribute'],
  ldap_authorization_enabled => $authnz['ldap_authorization_enabled'],
  listen_port_viewer         => hiera('lma::elasticsearch::apache_viewer_port'),
  ldap_group_attribute       => $authnz['ldap_group_attribute'],
  ldap_admin_group_dn        => $authnz['ldap_admin_group_dn'],
  ldap_viewer_group_dn       => $authnz['ldap_viewer_group_dn'],
  require                    => Class[lma_logging_analytics::kibana],
}
