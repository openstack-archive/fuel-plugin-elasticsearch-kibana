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
  $roles = hiera('roles')
  $blockdevices_array = split($::blockdevices, ',')

  # Check that we're not colocated with other roles
  if size($roles) > 1 {
    fail('The Elasticsearch-Kibana plugin cannot be deployed with roles other than base-os.')
  }

  # Check that disk device(s) exist
  if ($elasticsearch_kibana['disk1']) and !($elasticsearch_kibana['disk1'] in $blockdevices_array) {
    fail("Disk device ${ elasticsearch_kibana['disk1'] } doesn't exist.")
  }

  if ($elasticsearch_kibana['disk2']) and !($elasticsearch_kibana['disk2'] in $blockdevices_array) {
    fail("Disk device ${ elasticsearch_kibana['disk2'] } doesn't exist.")
  }

  if ($elasticsearch_kibana['disk3']) and !($elasticsearch_kibana['disk3'] in $blockdevices_array) {
    fail("Disk device ${ elasticsearch_kibana['disk3'] } doesn't exist.")
  }

  # Check that JVM size doesn't exceed the physical RAM size
  $jvmsize_mb = ($elasticsearch_kibana['jvm_heap_size'] + 0.0) * 1024
  if $jvmsize_mb >= $::memorysize_mb {
    fail("The configured JVM size (${ $elasticsearch_kibana['jvm_heap_size'] } GB) is greater than the total amount of RAM of the system (${ ::memorysize }).")
  }
}

