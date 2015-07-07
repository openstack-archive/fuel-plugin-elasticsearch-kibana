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
  class { 'lma_logging_analytics::kibana': }

  exec { 'set_replicas_to_0':
    command => "/usr/bin/curl -XPUT 'localhost:9200/_settings' -d '{ \"index\" : { \"number_of_replicas\" : 0 } }' > /dev/null",
    require => Class['lma_logging_analytics::kibana'],
  }
}
