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
# Class lma_logging_analytics::params

class lma_logging_analytics::params {
  $retention_period        = 30
  $indexes_prefixes        = []

  $kibana_dir              = '/opt/kibana'
  $kibana_config           = "${kibana_dir}/config.js"
  $apache_htpasswd_file    = '/etc/apache2/kibana.htpasswd'
  $kibana_dashboard_prefix = 'Logging, Monitoring and Alerting - '
  $kibana_default_route    = join(['/dashboard/elasticsearch/', $kibana_dashboard_prefix, 'Logs'], '')
  $kibana_replicas         = 0
}
