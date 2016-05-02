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

notice('fuel-plugin-elasticsearch-kibana: elasticsearch.pp')

$listen_address = hiera('lma::elasticsearch::listen_address')
$es_nodes       = hiera('lma::elasticsearch::nodes')
$es_dir         = hiera('lma::elasticsearch::data_dir')
$es_instance    = hiera('lma::elasticsearch::instance_name')
$es_heap_size   = hiera('lma::elasticsearch::jvm_size')

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
  datadir       => "${es_dir}/elasticsearch_data",
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
    'cluster.name'                       => hiera('lma::elasticsearch::cluster_name'),
    'node.name'                          => hiera('lma::elasticsearch::node_name'),
    'node.master'                        => true,
    'node.data'                          => true,
    'discovery.zen.ping.multicast'       => {'enabled' => false},
    'discovery.zen.ping.unicast.hosts'   => $es_nodes,
    'discovery.zen.minimum_master_nodes' => hiera('lma::elasticsearch::minimum_master_nodes'),
    'gateway.recover_after_time'         => hiera('lma::elasticsearch::recover_after_time'),
    'gateway.recover_after_nodes'        => hiera('lma::elasticsearch::recover_after_nodes'),
    'gateway.expected_nodes'             => size($es_nodes),
    'http.bind_host'                     => $listen_address,
    'transport.bind_host'                => $listen_address,
    'transport.publish_host'             => $listen_address,
  }
}
