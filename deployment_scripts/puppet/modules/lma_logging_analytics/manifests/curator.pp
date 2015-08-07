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

class lma_logging_analytics::curator (
  $retention_period = $lma_logging_analytics::params::retention_period,
  $prefixes = $lma_logging_analytics::params::indexes_prefixes,
) inherits lma_logging_analytics::params {

  validate_integer($retention_period)
  validate_array($prefixes)

  package { 'python-elasticsearch-curator':
    ensure => installed,
  }

  if size($prefixes) > 0 and $retention_period > 0 {
    $regex = join($prefixes, '|')
    cron { 'es-curator':
      ensure   => present,
      command  => "/usr/local/bin/curator --host localhost --port 9200 --debug delete indices --regex '^(${regex})-.*$' --time-unit days --older-than ${retention_period} --timestring \"%Y.%m.%d\"",
      minute   => '0',
      hour     => '*',
      month    => '*',
      monthday => '*',
    }
  }
}
