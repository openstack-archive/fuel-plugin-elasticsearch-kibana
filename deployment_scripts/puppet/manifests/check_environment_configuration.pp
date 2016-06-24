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

notice('fuel-plugin-elasticsearch-kibana: check_environment_configuration.pp')

# Check that JVM size doesn't exceed the physical RAM size
$jvm_heap_size = hiera('lma::elasticsearch::jvm_size')
$jvmsize_mb = ($jvm_heap_size + 0.0) * 1024
if $jvmsize_mb >= $::memorysize_mb {
  fail("The configured JVM size (${jvm_heap_size} GB) is greater than the system RAM (${::memorysize}).")
}

$kibana_tls = hiera_hash('lma::kibana::tls')
if $kibana_tls['enabled'] {
  $certificate = $kibana_tls['cert_file_path']
  $common_name = $kibana_tls['hostname']

  # function validate_ssl_certificate() must be the value of a statement, so
  # we must use it in a statement.
  $not_used = validate_ssl_certificate($certificate, $common_name)
}
