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
class lma_logging_analytics::kibana_dashboards (
  $host = 'localhost',
  $port = '9200',
  $index = '.kibana',
) {
  include lma_logging_analytics::params

  # Note that the dashboards are stored in templates/ because it is the only way
  # for us to read the content of the file. Ideally we would have used the
  # file() function but until Puppet 3.7 it only works with absolute paths.
  # See http://www.unixdaemon.net/tools/puppet/puppet-3.7-file-function.html
  # for details

  $default = {
    url => "http://${host}:${port}",
    elasticsearch_index => $index,
  }

  $objects = {
    '4.5.1' => {
      content => template('lma_logging_analytics/kibana4_objects/config.json'),
      type => 'config',
    },
    'log-*' => {
      content => template('lma_logging_analytics/kibana4_objects/index-pattern_logs.json'),
      type => 'index-pattern',
    },
    'Logs' => {
      content => template('lma_logging_analytics/kibana4_objects/dashboard_logs.json'),
      type => 'dashboard',
    },
    'search-logs' => {
      content => template('lma_logging_analytics/kibana4_objects/search_logs.json'),
      type => 'search',
    },
    'LOG-MESSAGES-OVER-TIME-PER-SEVERITY' => {
      content => template('lma_logging_analytics/kibana4_objects/visualization_LOG-MESSAGES-OVER-TIME-PER-SEVERITY.json'),
      type => 'visualization',
    },
    'LOG-MESSAGES-OVER-TIME-PER-SOURCE' => {
      content => template('lma_logging_analytics/kibana4_objects/visualization_LOG-MESSAGES-OVER-TIME-PER-SOURCE.json'),
      type => 'visualization',
    },
    'NUMBER-OF-LOG-MESSAGES-PER-ROLE' => {
      content => template('lma_logging_analytics/kibana4_objects/visualization_NUMBER-OF-LOG-MESSAGES-PER-ROLE.json'),
      type => 'visualization',
    },
    'NUMBER-OF-LOG-MESSAGES-PER-SEVERITY' => {
      content => template('lma_logging_analytics/kibana4_objects/visualization_NUMBER-OF-LOG-MESSAGES-PER-SEVERITY.json'),
      type => 'visualization',
    },
    'TOP-10-HOSTS' => {
      content => template('lma_logging_analytics/kibana4_objects/visualization_TOP-10-HOSTS.json'),
      type => 'visualization',
    },
    'TOP-10-PROGRAMS' => {
      content => template('lma_logging_analytics/kibana4_objects/visualization_TOP-10-PROGRAMS.json'),
      type => 'visualization',
    },
    'TOP-10-SOURCES' => {
      content => template('lma_logging_analytics/kibana4_objects/visualization_TOP-10-SOURCES.json'),
      type => 'visualization',
    },
    'notification-*' => {
      content => template('lma_logging_analytics/kibana4_objects/index-pattern_notifications.json'),
      type => 'index-pattern',
    },
    'Notifications' => {
      content => template('lma_logging_analytics/kibana4_objects/dashboard_notifications.json'),
      type => 'dashboard',
    },
    'NOTIFICATIONS-OVER-TIME-PER-SOURCE' => {
      content => template('lma_logging_analytics/kibana4_objects/visualization_NOTIFICATIONS-OVER-TIME-PER-SOURCE.json'),
      type => 'visualization',
    },
    'NOTIFICATIONS-OVER-TIME-PER-SEVERITY' => {
      content => template('lma_logging_analytics/kibana4_objects/visualization_NOTIFICATIONS-OVER-TIME-PER-SEVERITY.json'),
      type => 'visualization',
    },
    'EVENT-TYPE-BREAKDOWN' => {
      content => template('lma_logging_analytics/kibana4_objects/visualization_EVENT-TYPE-BREAKDOWN.json'),
      type => 'visualization',
    },
    'SOURCE-BREAKDOWN' => {
      content => template('lma_logging_analytics/kibana4_objects/visualization_SOURCE-BREAKDOWN.json'),
      type => 'visualization',
    },
    'HOST-BREAKDOWN' => {
      content => template('lma_logging_analytics/kibana4_objects/visualization_HOST-BREAKDOWN.json'),
      type => 'visualization',
    },
    'NOTIFICATIONS-PER-SEVERITY' => {
      content => template('lma_logging_analytics/kibana4_objects/visualization_NOTIFICATIONS-PER-SEVERITY.json'),
      type => 'visualization',
    },
    'search-notifications' => {
      content => template('lma_logging_analytics/kibana4_objects/search_notifications.json'),
      type => 'search',
    },
    'audit-*' => {
      content => template('lma_logging_analytics/kibana4_objects/index-pattern_audit.json'),
      type => 'index-pattern',
    },
    'search-audit' => {
      content => template('lma_logging_analytics/kibana4_objects/search_audit.json'),
      type => 'search',
    },
  }

  create_resources(
    kibana_object, $objects, $default
  )
}
