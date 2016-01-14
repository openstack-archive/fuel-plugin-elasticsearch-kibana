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

prepare_network_config(hiera('network_scheme', {}))
$corosync_roles = hiera_array('lma::corosync_roles')
$network_metadata = hiera('network_metadata')
$nodes = get_nodes_hash_by_roles($network_metadata, $corosync_roles)

Cs_property {
  provider => 'crm',
}

if count($nodes) > 2 {
  $policy = 'stop'
} else {
  $policy = 'ignore'
}

cs_property { 'no-quorum-policy':
  ensure => present,
  value  => $policy,
}
