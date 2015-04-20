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
$elasticsearch_kibana = hiera('elasticsearch_kibana')

if $elasticsearch_kibana['node_name'] == hiera('user_node_name') {

  class { 'disk_management': }

  if ($elasticsearch_kibana['disk1']) {
    disk_management::partition { "/dev/${elasticsearch_kibana['disk1']}":
      size    => $elasticsearch_kibana['disk1_size'],
      require => Class['disk_management'],
    }
  }

  if ($elasticsearch_kibana['disk2']) {
    disk_management::partition { "/dev/${elasticsearch_kibana['disk2']}":
      size    => $elasticsearch_kibana['disk2_size'],
      require => Class['disk_management'],
    }
  }

  if ($elasticsearch_kibana['disk3']) {
    disk_management::partition { "/dev/${elasticsearch_kibana['disk3']}":
      size    => $elasticsearch_kibana['disk3_size'],
      require => Class['disk_management'],
    }
  }
}
