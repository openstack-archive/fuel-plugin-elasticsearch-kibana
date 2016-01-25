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
prepare_network_config(hiera('network_scheme', {}))
$mgmt_address = get_network_role_property('management', 'ipaddr')
$elasticsearch_kibana = hiera_hash('elasticsearch_kibana')
$network_metadata = hiera('network_metadata')
$es_nodes = get_nodes_hash_by_roles($network_metadata, ['elasticsearch_kibana', 'primary-elasticsearch_kibana'])
$es_address_map = get_node_to_ipaddr_map_by_network_role($es_nodes, 'management')
$es_nodes_ips = values($es_address_map)

include lma_logging_analytics::params

# Params related to Elasticsearch.
$es_dir       = $elasticsearch_kibana['data_dir']
$es_instance  = 'es-01'
$es_heap_size = $elasticsearch_kibana['jvm_heap_size']

# Java
$java = $::operatingsystem ? {
  CentOS => 'java-1.8.0-openjdk-headless',
  Ubuntu => 'openjdk-7-jre-headless'
}

# Ensure that java is installed
package { $java:
  ensure => installed,
}

file { $es_dir:
  ensure => 'directory',
}

# Install elasticsearch
class { 'elasticsearch':
  datadir       => ["${es_dir}/elasticsearch_data"],
  init_defaults => {
      'MAX_LOCKED_MEMORY' => 'unlimited',
      'ES_HEAP_SIZE'      => "${es_heap_size}g"
  },
  require       => [File[$es_dir], Package[$java]],
}

# Start an instance of elasticsearch
elasticsearch::instance { $es_instance:
  config => {
    'threadpool.bulk.queue_size'         => '1000',
    'bootstrap.mlockall'                 => true,
    'http.cors.allow-origin'             => '/.*/',
    'http.cors.enabled'                  => true,
    'cluster.name'                       => $lma_logging_analytics::params::es_cluster_name,
    'node.name'                          => "${::fqdn}_${es_instance}",
    'node.master'                        => true,
    'node.data'                          => true,
    'discovery.zen.ping.multicast'       => {'enabled' => false},
    'discovery.zen.ping.unicast.hosts'   => $es_nodes_ips,
    'discovery.zen.minimum_master_nodes' => hiera('lma::elasticsearch::minimum_master_nodes'),
    'gateway.recover_after_time'         => hiera('lma::elasticsearch::recover_after_time'),
    'gateway.recover_after_nodes'        => hiera('lma::elasticsearch::recover_after_nodes'),
    'gateway.expected_nodes'             => size($es_nodes_ips),
    'http.bind_host'                     => $mgmt_address,
    'transport.bind_host'                => $mgmt_address,
    'transport.publish_host'             => $mgmt_address,
  }
}