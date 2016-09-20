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

# Java
$java = $::operatingsystem ? {
  CentOS => 'java-1.8.0-openjdk-headless',
  Ubuntu => 'openjdk-7-jre-headless'
}

# Ensure that java is installed
package { $java:
  ensure => installed,
}

class { 'lma_logging_analytics::elasticsearch':
  listen_address       => hiera('lma::elasticsearch::listen_address'),
  node_name            => hiera('lma::elasticsearch::node_name'),
  nodes                => hiera('lma::elasticsearch::nodes'),
  data_dir             => hiera('lma::elasticsearch::data_dir'),
  instance_name        => hiera('lma::elasticsearch::instance_name'),
  heap_size            => hiera('lma::elasticsearch::jvm_size'),
  cluster_name         => hiera('lma::elasticsearch::cluster_name'),
  logs_dir             => hiera('lma::elasticsearch::logs_dir'),
  minimum_master_nodes => hiera('lma::elasticsearch::minimum_master_nodes'),
  recover_after_time   => hiera('lma::elasticsearch::recover_after_time'),
  recover_after_nodes  => hiera('lma::elasticsearch::recover_after_nodes'),
# The Telemetry plugin creates values for 'script_inline' and 'script_indexed' in hiera if enabled
# default value is 'sandbox';
# related documentation:
# https://www.elastic.co/guide/en/elasticsearch/reference/current/modules-scripting.html#enable-dynamic-scripting
  script_inline        => hiera('lma::elasticsearch::script_inline', 'sandbox'),
  script_indexed       => hiera('lma::elasticsearch::script_indexed', 'sandbox'),
  version              => '2.3.3',
  require              => Package[$java],
}

# The plugin's packages used to have a higher priority but this isn't the case
# anymore on MOS 9. Since MOS ships an older version of python-elasticsearch
# (incompatible with python-elasticsearch-curator), we need to force the
# installation of python-elasticsearch before installing the curator package.
package { 'python-elasticsearch':
  ensure => '2.3.0',
}

# The curator is installed on all the nodes but by configuration, it will only
# be executed on the ES cluster master node
class { 'lma_logging_analytics::curator':
  host             => hiera('lma::elasticsearch::listen_address'),
  port             => hiera('lma::elasticsearch::rest_port'),
  retention_period => hiera('lma::elasticsearch::retention_period'),
  prefixes         => ['log', 'notification'],
  package_version  => '4.0.6',
  require          => Package['python-elasticsearch'],
}
