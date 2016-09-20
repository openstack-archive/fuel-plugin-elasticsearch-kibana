# Copyright 2016 Mirantis, Inc.
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

class lma_logging_analytics::elasticsearch (
  $listen_address,
  $data_dir,
  $node_name,
  $instance_name,
  $cluster_name,
  $nodes = [],
  $logs_dir = '/var/log/elasticsearch',
  $minimum_master_nodes = 1,
  $recover_after_time = 5,
  $recover_after_nodes = 1,
  $is_master = true,
  $is_data = true,
  $heap_size = 1,
  $listen_port = 9200,
  $version = 'latest',
  $script_inline = 'sandbox',
  $script_indexed = 'sandbox',
){

  validate_bool($is_master)
  validate_bool($is_data)
  validate_integer($minimum_master_nodes)
  validate_integer($recover_after_time)
  validate_integer($recover_after_nodes)
  validate_integer($heap_size)
  validate_integer($listen_port)

  file { $data_dir:
    ensure => 'directory',
  }

  # Install elasticsearch
  class { '::elasticsearch':
    version       => $version,
    datadir       => "${data_dir}/elasticsearch_data",
    init_defaults => {
        'MAX_LOCKED_MEMORY' => 'unlimited',
        'ES_HEAP_SIZE'      => "${heap_size}g",
        'LOG_DIR'           => $logs_dir,
    },
    require       => File[$data_dir],
  }

  $config = {
    'threadpool.bulk.queue_size'         => '1000',
    'bootstrap.mlockall'                 => true,
    'http.cors.allow-origin'             => '/.*/',
    'http.cors.enabled'                  => true,
    'cluster.name'                       => $cluster_name,
    'path.logs'                          => $logs_dir,
    'node.name'                          => $node_name,
    'node.master'                        => $is_master,
    'node.data'                          => $is_data,
    'discovery.zen.ping.multicast'       => {'enabled' => false},
    'discovery.zen.ping.unicast.hosts'   => $nodes,
    'discovery.zen.minimum_master_nodes' => $minimum_master_nodes,
    'gateway.recover_after_time'         => "${recover_after_time}m",
    'gateway.recover_after_nodes'        => $recover_after_nodes,
    'gateway.expected_nodes'             => size($nodes),
    'http.bind_host'                     => $listen_address,
    'transport.bind_host'                => $listen_address,
    'transport.publish_host'             => $listen_address,
    'script.inline'                      => $script_inline,
    'script.indexed'                     => $script_indexed,
  }
  # Start an instance of elasticsearch
  ::elasticsearch::instance { $instance_name:
    logging_file => 'puppet:///modules/lma_logging_analytics/elasticsearch_logging.yaml',
    config       => $config,
  }

  # This template uses $logs_dir variable
  file { "/etc/logrotate.d/elasticsearch-${instance_name}.conf":
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('lma_logging_analytics/elasticsearch_logrotate.conf.erb'),
  }
}
