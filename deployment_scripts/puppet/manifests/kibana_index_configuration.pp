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

notice('fuel-plugin-elasticsearch-kibana: kibana_index_configuration.pp')

$vip = hiera('lma::elasticsearch::vip')
$es_port = hiera('lma::elasticsearch::rest_port')
$kibana_index = hiera('lma::elasticsearch::kibana_index')
$number_of_replicas = hiera('lma::elasticsearch::number_of_replicas')

# Elasticsearch must be reachable through HAproxy before the template creation.
# This is due the fact that The Elasticsearch Puppet module miserably fails
# when HAproxy responds 503 with HTML content and this leads to never create
# the template.
haproxy_backend_status { 'elasticsearch':
  name   => hiera('lma::elasticsearch::es_haproxy_service'),
  socket => '/var/lib/haproxy/stats',
}

# Kibana4 creates automatically its index when starting and configures fields
# mapping on the fly when first objects are created through the UI.
# In order to automate the dashboards importation, the Elasticsearch index
# template for Kibana4 must be created before Kibana starts.
# Then, correct fields mapping are present before importing objects
# (searches, visualizations and dashboards).
lma_logging_analytics::es_template { 'kibana4':
  number_of_replicas => $number_of_replicas,
  host               => $vip,
  port               => $es_port,
  index_template     => $kibana_index,
  require            => Haproxy_backend_status['elasticsearch'],
}

# Import all Kibana objects in one time by issuing a Bulk request
class { 'lma_logging_analytics::kibana_dashboards':
  host    => $vip,
  port    => $es_port,
  index   => $kibana_index,
  require => Lma_logging_analytics::Es_template['kibana4'],
}
