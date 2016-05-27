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

notice('fuel-plugin-elasticsearch-kibana: kibana_es_configuration.pp')

# Kibana4 creates automatically its index when starting and configures fields
# mapping on the fly when first objects are created through the UI.
# To be able to automatically import dashboards, the Elasticsearch index
# template for Kibana4 index must be created before Kibana starts
# to have correct fields mapping before importing objects (searches, visualizations
# and dashboards).

$vip = hiera('lma::elasticsearch::vip')
$es_port = hiera('lma::elasticsearch::rest_port')
$kibana_index = hiera('lma::elasticsearch::kibana_index')

lma_logging_analytics::es_template { 'kibana4':
  host           => $vip,
  port           => $es_port,
  index_template => $kibana_index,
} ->
lma_logging_analytics::es_bulk { 'kibana':
  host  => $vip,
  port  => $es_port,
  index => $kibana_index,
}