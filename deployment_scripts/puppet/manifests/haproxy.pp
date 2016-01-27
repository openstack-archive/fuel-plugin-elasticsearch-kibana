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
$role_name = 'elasticsearch_kibana'
$es_port = '9200'
$nginx_port = '80'
$vip = hiera('lma::elasticsearch::vip')
$roles = [ $role_name , "primary-${role_name}"]
$es_nodes = get_nodes_hash_by_roles(hiera_hash('network_metadata'), $roles)
$es_address_map = get_node_to_ipaddr_map_by_network_role($es_nodes, 'elasticsearch')
$es_nodes_ips = values($es_address_map)
$es_nodes_names = keys($es_address_map)
notice($es_address_map)
notice($es_nodes_ips)

Openstack::Ha::Haproxy_service {
  server_names        => $es_nodes_names,
  ipaddresses         => $es_nodes_ips,
  public              => false,
  public_ssl          => false,
  internal            => true,
  internal_virtual_ip => $vip,
}

openstack::ha::haproxy_service { 'elasticsearch-rest':
  order                  => '920',
  listen_port            => $es_port,
  balancermember_port    => $es_port,
  balancermember_options => 'check inter 10s fastinter 2s downinter 3s rise 3 fall 3',
  haproxy_config_options => {
    'option'  => ['httplog', 'http-keep-alive', 'prefer-last-server', 'dontlog-normal'],
    'balance' => 'roundrobin',
    'mode'    => 'http',
  }
}

openstack::ha::haproxy_service { 'kibana':
  order                  => '921',
  listen_port            => $nginx_port,
  balancermember_port    => $nginx_port,
  balancermember_options => 'check inter 10s fastinter 2s downinter 3s rise 3 fall 3',
  haproxy_config_options => {
    'option'  => ['httplog', 'http-keep-alive', 'prefer-last-server', 'dontlog-normal'],
    'balance' => 'roundrobin',
    'mode'    => 'http',
  }
}
