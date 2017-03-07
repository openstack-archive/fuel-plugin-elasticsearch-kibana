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

notice('fuel-plugin-elasticsearch-kibana: provision_services.pp')

$deployment_id = hiera('deployment_id')
$master_ip = hiera('master_ip')
$es_vip = hiera('lma::elasticsearch::vip')
$kibana_vip = hiera('lma::kibana::vip')
$kibana_viewer_port = hiera('lma::elasticsearch::kibana_frontend_viewer_port')
$es_port = hiera('lma::elasticsearch::rest_port')
$number_of_replicas = hiera('lma::elasticsearch::number_of_replicas')
$kibana_index = hiera('lma::elasticsearch::kibana_index')

$authnz = hiera_hash('lma::kibana::authnz')
if $authnz['ldap_enabled'] and $authnz['ldap_authorization_enabled'] {
  $two_links = true
} else {
  $two_links = false
}
$kibana_tls = hiera_hash('lma::kibana::tls')
if $kibana_tls['enabled'] {
  $protocol = 'https'
  $kibana_hostname = $kibana_tls['hostname']
  if $two_links {
    $kibana_link_data = "{\"title\":\"Kibana (Admin role)\",\
    \"description\":\"Dashboard for visualizing logs and notifications (${kibana_hostname}: ${protocol}://${kibana_vip})\",\
    \"url\":\"${protocol}://${kibana_hostname}\"}"
    $kibana_link_viewer_data = "{\"title\":\"Kibana (Viewer role)\",\
    \"description\":\"Dashboard for visualizing logs and notifications (${kibana_hostname}: ${protocol}://${kibana_vip}:${kibana_viewer_port})\",\
    \"url\":\"${protocol}://${kibana_hostname}:${kibana_viewer_port}/\"}"
  } else {
    $kibana_link_data = "{\"title\":\"Kibana\",\
    \"description\":\"Dashboard for visualizing logs and notifications (${kibana_hostname}: ${protocol}://${kibana_vip})\",\
    \"url\":\"${protocol}://${kibana_hostname}\"}"
  }
} else {
  $protocol = 'http'
  if $two_links {
    $kibana_link_data = "{\"title\":\"Kibana (Admin role)\",\
    \"description\":\"Dashboard for visualizing logs and notifications\",\
    \"url\":\"${protocol}://${kibana_vip}\"}"
    $kibana_link_viewer_data = "{\"title\":\"Kibana (Viewer role)\",\
    \"description\":\"Dashboard for visualizing logs and notifications\",\
    \"url\":\"${protocol}://${kibana_vip}:${kibana_viewer_port}/\"}"
  } else {
    $kibana_link_data = "{\"title\":\"Kibana\",\
    \"description\":\"Dashboard for visualizing logs and notifications\",\
    \"url\":\"${protocol}://${kibana_vip}\"}"
  }
}

lma_logging_analytics::es_template { ['log', 'notification', 'audit']:
  number_of_replicas => $number_of_replicas,
  host               => $es_vip,
  port               => $es_port,
}

# Adjust the number of replicas for the Kibana index
exec { 'adjust_kibana_replicas':
  command => "/usr/bin/curl -sL -XPUT http://${es_vip}:${es_port}/${kibana_index}/_settings \
  -d '{\"index\": {\"number_of_replicas\": ${number_of_replicas}}}'"
}

$kibana_link_created_file = '/var/cache/kibana_link_created_up_1.x'
exec { 'notify_kibana_url':
  creates => $kibana_link_created_file,
  command => "/usr/bin/curl -sL -w \"%{http_code}\" \
-H 'Content-Type: application/json' -X POST -d '${kibana_link_data}' \
http://${master_ip}:8000/api/clusters/${deployment_id}/plugin_links \
-o /dev/null | /bin/grep 201 && touch ${kibana_link_created_file}",
}

if $two_links {
  $kibana_viewer_link_created_file = '/var/cache/kibana_viewer_link_created_up_1.x'
  exec { 'notify_kibana_url_for_viewer':
    creates => $kibana_viewer_link_created_file,
    command => "/usr/bin/curl -sL -w \"%{http_code}\" \
  -H 'Content-Type: application/json' -X POST -d '${kibana_link_viewer_data}' \
  http://${master_ip}:8000/api/clusters/${deployment_id}/plugin_links \
  -o /dev/null | /bin/grep 201 && touch ${kibana_viewer_link_created_file}",
    require => Exec['notify_kibana_url'],
  }
}
