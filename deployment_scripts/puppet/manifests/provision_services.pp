#    Copyright 2016 Mirantis, Inc.
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

$deployment_id = hiera('deployment_id')
$master_ip = hiera('master_ip')
$vip = hiera('lma::elasticsearch::vip')
$number_of_replicas = hiera('lma::elasticsearch::number_of_replicas')
$kibana_link_data = "{\"title\":\"Kibana\",\
\"description\":\"Dashboard for visualizing logs and notifications\",\
\"url\":\"http://${vip}/\"}"
$kibana_link_created_file = '/var/cache/kibana_link_created'
$elasticsearch_kibana = hiera_hash('elasticsearch_kibana')

lma_logging_analytics::es_template { ['log', 'notification', 'kibana']:
  number_of_replicas => $number_of_replicas,
  host               => $vip,
} ->
lma_logging_analytics::kibana_dashboard { ['logs', 'notifications']:
  host    => $vip,
} ->
class { 'lma_logging_analytics::curator':
  host             => $vip,
  retention_period => $elasticsearch_kibana['retention_period'],
  prefixes         => ['log', 'notification'],
} ->
exec { 'notify_kibana_url':
  creates => $kibana_link_created_file,
  command => "/usr/bin/curl -sL -w \"%{http_code}\" \
-H 'Content-Type: application/json' -X POST -d '${kibana_link_data}' \
http://${master_ip}:8000/api/clusters/${deployment_id}/plugin_links \
-o /dev/null | /bin/grep 201 && touch ${kibana_link_created_file}",
}
