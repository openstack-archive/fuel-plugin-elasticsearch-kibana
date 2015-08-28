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
$elasticsearch_kibana = hiera('elasticsearch_kibana')

if $elasticsearch_kibana['node_name'] == hiera('user_node_name') {
  notice('MODULAR: netconfig.pp')

  $network_scheme = hiera('network_scheme')

  class { 'l23network' :
    use_ovs => hiera('use_neutron', false)
  }
  prepare_network_config($network_scheme)
  $sdn = generate_network_config()
  notify {'SDN': message => $sdn }

  #Set arp_accept to 1 by default #lp1456272
  sysctl::value { 'net.ipv4.conf.all.arp_accept':   value => '1'  }
  sysctl::value { 'net.ipv4.conf.default.arp_accept':   value => '1'  }

  # setting kernel reserved ports
  # defaults are 49000,49001,35357,41055,58882
  class { 'openstack::reserved_ports': }

  ### TCP connections keepalives and failover related parameters ###
  # configure TCP keepalive for host OS.
  # Send 3 probes each 8 seconds, if the connection was idle
  # for a 30 seconds. Consider it dead, if there was no responces
  # during the check time frame, i.e. 30+3*8=54 seconds overall.
  # (note: overall check time frame should be lower then
  # nova_report_interval).
  class { 'openstack::keepalive' :
    tcpka_time   => '30',
    tcpka_probes => '8',
    tcpka_intvl  => '3',
    tcp_retries2 => '5',
  }

  # increase network backlog for performance on fast networks
  sysctl::value { 'net.core.netdev_max_backlog':   value => '261144' }

  L2_port<||> -> Sysfs_config_value<||>
  L3_ifconfig<||> -> Sysfs_config_value<||>
  L3_route<||> -> Sysfs_config_value<||>

  class { 'sysfs' :}

  sysfs_config_value { 'rps_cpus' :
    ensure  => 'present',
    name    => '/etc/sysfs.d/rps_cpus.conf',
    value   => cpu_affinity_hex($::processorcount),
    sysfs   => '/sys/class/net/*/queues/rx-*/rps_cpus',
    exclude => '/sys/class/net/lo/*',
  }

  sysfs_config_value { 'xps_cpus' :
    ensure  => 'present',
    name    => '/etc/sysfs.d/xps_cpus.conf',
    value   => cpu_affinity_hex($::processorcount),
    sysfs   => '/sys/class/net/*/queues/tx-*/xps_cpus',
    exclude => '/sys/class/net/lo/*',
  }

  if !defined(Package['irqbalance']) {
    package { 'irqbalance':
      ensure => installed,
    }
  }

  if !defined(Service['irqbalance']) {
    service { 'irqbalance':
      ensure  => running,
      require => Package['irqbalance'],
    }
  }
}
