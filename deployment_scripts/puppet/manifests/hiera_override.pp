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
$hiera_dir            = '/etc/hiera/plugins'
$plugin_name          = 'elasticsearch_kibana'
$plugin_yaml          = "${plugin_name}.yaml"
$corosync_roles       = [$plugin_name, "primary-${plugin_name}"]
$elasticsearch_kibana = hiera_hash('elasticsearch_kibana')
$network_metadata     = hiera('network_metadata')
$es_nodes             = get_nodes_hash_by_roles($network_metadata, ['elasticsearch_kibana', 'primary-elasticsearch_kibana'])
$es_nodes_count       = count($es_nodes)
$vip_name             = 'es_vip_mgmt'
if ! $network_metadata['vips'][$vip_name] {
  fail('Elasticsearch VIP is not defined')
}
$vip = $network_metadata['vips'][$vip_name]['ipaddr']

if is_integer($elasticsearch_kibana['number_of_replicas']) and $elasticsearch_kibana['number_of_replicas'] < $es_nodes_count {
  $number_of_replicas = 0 + $elasticsearch_kibana['number_of_replicas']
}else{
  # Override the replication number otherwise this will lead to a stale cluster health
  $number_of_replicas = $es_nodes_count - 1
  notice("Set number_of_replicas to ${number_of_replicas}")
}

if is_integer($elasticsearch_kibana['minimum_master_nodes'] and $elasticsearch_kibana['minimum_master_nodes'] <= $es_nodes_count) {
  $minimum_master_nodes = 0 + $elasticsearch_kibana['minimum_master_nodes']
} elsif $es_nodes_count > 2 {
  $minimum_master_nodes = floor($es_nodes_count / 2 + 1)
}else{
  $minimum_master_nodes = 1
}
notice("Set minimum_master_nodes to ${minimum_master_nodes}")

$recover_after_time = 0 + $elasticsearch_kibana['recover_after_time']

if is_integer($elasticsearch_kibana['recover_after_nodes']) and $elasticsearch_kibana['recover_after_nodes'] <= $es_nodes_count {
  $recover_after_nodes = $elasticsearch_kibana['recover_after_nodes']
} else {
  if $es_nodes_count <= 1 {
    $recover_after_nodes = 1
  } else {
    $recover_after_nodes = floor($es_nodes_count * 2 / 3)
  }
  notice("Set recover_after_nodes to ${recover_after_nodes}")
}

$calculated_content = inline_template('
lma::corosync_roles:
<%
@corosync_roles.each do |crole|
%>  - <%= crole %>
<% end -%>

lma::elasticsearch::vip: <%= @vip%>
lma::elasticsearch::number_of_replicas: <%= @number_of_replicas %>
lma::elasticsearch::minimum_master_nodes: <%= @minimum_master_nodes %>
lma::elasticsearch::recover_after_time: <%= @recover_after_time %>
lma::elasticsearch::recover_after_nodes: <%= @recover_after_nodes %>
')

file { "${hiera_dir}/${plugin_yaml}":
  ensure  => file,
  content => "${calculated_content}\n",
}
