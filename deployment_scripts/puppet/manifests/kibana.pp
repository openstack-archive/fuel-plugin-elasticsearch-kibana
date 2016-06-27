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

class { 'lma_logging_analytics::kibana_authentication':
  listen_address => hiera('lma::elasticsearch::listen_address'),
  listen_port    => hiera('lma::elasticsearch::apache_port'),
  kibana_address => '127.0.0.1',
  kibana_port    => hiera('lma::elasticsearch::kibana_port'),
  username       => hiera('lma::kibana::username'),
  password       => hiera('lma::kibana::password'),
  require        => Class[lma_logging_analytics::kibana],
}
