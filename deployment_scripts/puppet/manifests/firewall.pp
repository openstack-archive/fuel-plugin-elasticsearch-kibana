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

notice('fuel-plugin-elasticsearch-kibana: firewall.pp')

$authnz = hiera_hash('lma::kibana::authnz')

class {'::firewall':}

firewall { '000 accept all icmp requests':
  proto  => 'icmp',
  action => 'accept',
}

firewall { '001 accept all to lo interface':
  proto   => 'all',
  iniface => 'lo',
  action  => 'accept',
}

firewall { '002 accept related established rules':
  proto  => 'all',
  state  => ['RELATED', 'ESTABLISHED'],
  action => 'accept',
}

firewall {'020 ssh':
  port   => 22,
  proto  => 'tcp',
  action => 'accept',
}
firewall { '113 corosync-input':
  port   => 5404,
  proto  => 'udp',
  action => 'accept',
}

firewall { '114 corosync-output':
  port   => 5405,
  proto  => 'udp',
  action => 'accept',
}

firewall { '100 elasticsearch REST':
  port   => hiera('lma::elasticsearch::rest_port'),
  proto  => 'tcp',
  action => 'accept',
}

firewall { '110 elasticsearch clustering':
  port   => hiera('lma::elasticsearch::clustering_port'),
  proto  => 'tcp',
  action => 'accept',
}

firewall { '101 haproxy kibana':
  port   => hiera('lma::elasticsearch::kibana_frontend_port'),
  proto  => 'tcp',
  action => 'accept',
}

firewall { '101 kibana':
  port   => hiera('lma::elasticsearch::kibana_port'),
  proto  => 'tcp',
  action => 'accept',
}

firewall { '101 proxy-kibana':
  port   => hiera('lma::elasticsearch::apache_port'),
  proto  => 'tcp',
  action => 'accept',
}

if $authnz['ldap_authorization_enabled'] {
  firewall { '101 proxy-kibana-viewer':
    port   => hiera('lma::elasticsearch::apache_viewer_port'),
    proto  => 'tcp',
    action => 'accept',
  }
}

firewall { '999 drop all other requests':
  proto  => 'all',
  chain  => 'INPUT',
  action => 'drop',
}
