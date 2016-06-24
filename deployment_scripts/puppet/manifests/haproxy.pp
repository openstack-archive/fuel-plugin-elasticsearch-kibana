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

notice('fuel-plugin-elasticsearch-kibana: haproxy.pp')

$es_port = hiera('lma::elasticsearch::rest_port')
$kibana_backend_port = hiera('lma::elasticsearch::apache_port')
$kibana_frontend_port = hiera('lma::elasticsearch::kibana_frontend_port')
$vip = hiera('lma::elasticsearch::vip')

$nodes_ips = hiera('lma::elasticsearch::nodes')
$nodes_names = prefix(range(1, size($nodes_ips)), 'server_')

Openstack::Ha::Haproxy_service {
  server_names        => $nodes_names,
  ipaddresses         => $nodes_ips,
  public              => false,
  public_ssl          => false,
  internal            => true,
  internal_virtual_ip => $vip,
}

$es_haproxy_service = hiera('lma::elasticsearch::es_haproxy_service')
openstack::ha::haproxy_service { $es_haproxy_service:
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

$kibana_tls = hiera_hash('lma::kibana::tls')
if $kibana_tls['enabled'] {
  openstack::ha::haproxy_service { 'kibana':
    order                  => '921',
    internal_ssl           => true,
    internal_ssl_path      => $kibana_tls['cert_file_path'],
    listen_port            => $kibana_frontend_port,
    balancermember_port    => $kibana_backend_port,
    balancermember_options => 'check inter 10s fastinter 2s downinter 3s rise 3 fall 3',
    haproxy_config_options => {
      'option'  => ['httplog', 'http-keep-alive', 'prefer-last-server', 'dontlog-normal'],
      'balance' => 'roundrobin',
      'mode'    => 'http',
    },
  }
} else {
  openstack::ha::haproxy_service { 'kibana':
    order                  => '921',
    listen_port            => $kibana_frontend_port,
    balancermember_port    => $kibana_backend_port,
    balancermember_options => 'check inter 10s fastinter 2s downinter 3s rise 3 fall 3',
    haproxy_config_options => {
      'option'  => ['httplog', 'http-keep-alive', 'prefer-last-server', 'dontlog-normal'],
      'balance' => 'roundrobin',
      'mode'    => 'http',
    }
  }
}
