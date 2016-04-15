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

notice('fuel-plugin-elasticsearch-kibana: cluster.pp')

# Compared to the osnailyfacter/modular/cluster/cluster.pp manifest, this task
# supports the use case where the Pacemaker cluster is made of several
# unrelated roles.
prepare_network_config(hiera_hash('network_scheme'))
$fuel_version = 0 + hiera('fuel_version')

$corosync_nodes = corosync_nodes(
    get_nodes_hash_by_roles(
      hiera_hash('network_metadata'),
      hiera_array('lma::corosync_roles')
    ),
    'mgmt/corosync'
)
$cluster_recheck_interval = hiera('cluster_recheck_interval', '190s')

if $fuel_version < 9.0 {
  class { '::cluster':
    internal_address         => get_network_role_property('mgmt/corosync', 'ipaddr'),
    corosync_nodes           => $corosync_nodes,
    cluster_recheck_interval => $cluster_recheck_interval,
  }
} else {
  $corosync_nodes_processed = corosync_nodes_process($corosync_nodes)

  class { '::cluster':
    internal_address         => get_network_role_property('mgmt/corosync', 'ipaddr'),
    quorum_members           => $corosync_nodes_processed['ips'],
    unicast_addresses        => $corosync_nodes_processed['ips'],
    quorum_members_ids       => $corosync_nodes_processed['ids'],
    cluster_recheck_interval => $cluster_recheck_interval,
  }
}

pcmk_nodes { 'pacemaker' :
  nodes               => $corosync_nodes,
  add_pacemaker_nodes => false,
}

Service <| title == 'corosync' |> {
  subscribe => File['/etc/corosync/service.d'],
  require   => File['/etc/corosync/corosync.conf'],
}

Service['corosync'] -> Pcmk_nodes<||>
Pcmk_nodes<||> -> Service<| provider == 'pacemaker' |>

# Sometimes during first start pacemaker can not connect to corosync
# via IPC due to pacemaker and corosync processes are run under different users
if($::operatingsystem == 'Ubuntu') {
  $pacemaker_run_uid = 'hacluster'
  $pacemaker_run_gid = 'haclient'

  file {'/etc/corosync/uidgid.d/pacemaker':
    content =>"uidgid {
   uid: ${pacemaker_run_uid}
   gid: ${pacemaker_run_gid}
}"
  }

  File['/etc/corosync/corosync.conf'] -> File['/etc/corosync/uidgid.d/pacemaker'] -> Service <| title == 'corosync' |>
}
