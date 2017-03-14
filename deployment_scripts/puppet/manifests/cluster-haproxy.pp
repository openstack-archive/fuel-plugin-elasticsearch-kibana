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

notice('fuel-plugin-elasticsearch-kibana: cluster-haproxy.pp')

$fuel_version = 0 + hiera('fuel_version')

$network_scheme     = hiera_hash('network_scheme', {})
$haproxy_hash       = hiera_hash('haproxy', {})

$haproxy_maxconn              = '16000'
$haproxy_bufsize              = '32768'
$other_networks               = direct_networks($network_scheme['endpoints'])
$haproxy_maxrewrite           = '1024'
$haproxy_log_file             = '/var/log/haproxy.log'
$haproxy_ssl_default_dh_param = '2048'
$primary_controller           = false
$debug                        = false
$spread_checks                = '3'

#FIXME(mattymo): Replace with only VIPs for roles assigned to this node
include ::concat::setup
include ::haproxy::params
include ::rsyslog::params

package { 'haproxy':
  name => $::haproxy::params::package_name,
}

#NOTE(bogdando) we want defaults w/o chroot
#  and this override looks the only possible if
#  upstream manifests must be kept intact
$global_options   = {
  'log'                        => '/dev/log local0',
  'pidfile'                    => '/var/run/haproxy.pid',
  'maxconn'                    => $haproxy_maxconn,
  'user'                       => 'haproxy',
  'group'                      => 'haproxy',
  'daemon'                     => '',
  'stats'                      => 'socket /var/lib/haproxy/stats',
  'spread-checks'              => $spread_checks,
  'tune.bufsize'               => $haproxy_bufsize,
  'tune.maxrewrite'            => $haproxy_maxrewrite,
  'tune.ssl.default-dh-param'  => $haproxy_ssl_default_dh_param,
  'ssl-default-bind-options'   => 'no-sslv3 no-tls-tickets',
  'ssl-default-server-options' => 'no-sslv3 no-tls-tickets',
}

$defaults_options = {
  'log'     => 'global',
  'maxconn' => '8000',
  'mode'   => 'http',
  'retries' => '3',
  'option'  => [
    'redispatch',
    'http-server-close',
    'splice-auto',
    'dontlognull',
  ],
  'timeout' => [
    'http-request 20s',
    'queue 1m',
    'connect 10s',
    'client 1m',
    'server 1m',
    'check 10s',
  ],
}

$service_name = 'p_haproxy'

class { 'haproxy::base':
  global_options    => $global_options,
  defaults_options  => $defaults_options,
  stats_ipaddresses => ['127.0.0.1'],
  use_include       => true,
}

# IP forwarding needs to be enabled for multi-rack environments
# See https://bugs.launchpad.net/lma-toolchain/+bug/1604432
sysctl::value { 'net.ipv4.ip_forward': value => '1' }
sysctl::value { 'net.ipv4.ip_nonlocal_bind':
  value => '1'
}

service { 'haproxy' :
  ensure     => 'running',
  name       => $service_name,
  enable     => true,
  hasstatus  => true,
  hasrestart => true,
}

tweaks::ubuntu_service_override { 'haproxy' :
  service_name => 'haproxy',
  package_name => $haproxy::params::package_name,
}

class { 'cluster::haproxy::rsyslog':
  log_file => $haproxy_log_file,
}

Package['haproxy'] ->
Class['haproxy::base']

Class['haproxy::base'] ~>
Service['haproxy']

Package['haproxy'] ~>
Service['haproxy']

Sysctl::Value['net.ipv4.ip_nonlocal_bind', 'net.ipv4.ip_forward'] ~>
Service['haproxy']

# Pacemaker
$primitive_type  = 'ns_haproxy'
$complex_type    = 'clone'
$metadata        = {
  'migration-threshold' => '3',
  'failure-timeout'     => '120',
}
$parameters      = {
  'ns'             => 'haproxy',
  'debug'          => $debug,
  'other_networks' => $other_networks,
}
$operations      = {
  'monitor' => {
    'interval' => '30',
    'timeout'  => '60'
  },
  'start'   => {
    'timeout' => '60'
  },
  'stop'    => {
    'timeout' => '60'
  },
}

if $fuel_version < 9.0 {

  pacemaker_wrappers::service { $service_name :
    primitive_type => $primitive_type,
    parameters     => $parameters,
    metadata       => $metadata,
    operations     => $operations,
    ms_metadata    => {
      'interleave' => true,
    },
    complex_type   => $complex_type,
    prefix         => false,
  }

  Cs_resource[$service_name] ->
  Service[$service_name]
} else {

  pacemaker::service { $service_name :
    primitive_type   => $primitive_type,
    parameters       => $parameters,
    metadata         => $metadata,
    operations       => $operations,
    complex_metadata => {
      'interleave' => true,
    },
    complex_type     => $complex_type,
    prefix           => false,
  }

  Pcmk_resource[$service_name] ->
  Service[$service_name]
}
