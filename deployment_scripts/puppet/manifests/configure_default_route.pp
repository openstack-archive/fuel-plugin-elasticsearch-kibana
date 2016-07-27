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

notice('fuel-plugin-influxdb-grafana: configure_default_route.pp')

$fuel_version = 0 + hiera('fuel_version')

if $fuel_version < 9.0 {
  # The code below is a copy-paste from configure_default_route.pp in
  # fuel-library (branch stable/8.0)
  # Unfortunately we have no way to do otherwise since we need to support both
  # MOS 8 and MOS 9
  $network_scheme         = hiera_hash('network_scheme', {})
  $management_vrouter_vip = hiera('management_vrouter_vip')
  $management_role        = 'management'
  $fw_admin_role          = 'fw-admin'

  if ( $::l23_os =~ /(?i:centos6)/ and $::kernelmajversion == '3.10' ) {
    $ovs_datapath_package_name = 'kmod-openvswitch-lt'
  }

  $use_ovs_dkms_datapath_module = $::l23_os ? {
                                    /(?i:redhat7|centos7)/ => false,
                                    default                => true
                                  }
  class { 'l23network' :
    use_ovs                      => hiera('use_ovs', false),
    use_ovs_dkms_datapath_module => $use_ovs_dkms_datapath_module,
    ovs_datapath_package_name    => $ovs_datapath_package_name,
  }

  $new_network_scheme = configure_default_route($network_scheme, $management_vrouter_vip, $fw_admin_role, $management_role )
  notice ($new_network_scheme)

  if !empty($new_network_scheme) {
    prepare_network_config($new_network_scheme)
    $sdn = generate_network_config()
    notify {'SDN': message => $sdn }
  }
}
