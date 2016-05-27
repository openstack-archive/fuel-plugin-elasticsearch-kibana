#    Copyright 2016 Mirantis, Inc.
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
# Defined type lma_logging_analytics::es_template

define lma_logging_analytics::es_bulk (
  $index,
  $host = 'localhost',
  $port = 9200,
) {
  $es_url = "http://${host}:${port}"

  # Note that the bulk request is stored in templates/ because it is the only way
  # for us to read the content of the file. Ideally we would have used the
  # file() function but until Puppet 3.7 it only works with absolute paths.
  # See http://www.unixdaemon.net/tools/puppet/puppet-3.7-file-function.html
  # for details
  $content = template("lma_logging_analytics/es_bulk_${title}.json")
  $es_bulk_performed = "/var/cache/es_bulk_${title}"

  Exec {
    path      => [ '/bin', '/usr/bin', '/usr/local/bin' ],
    cwd       => '/tmp',
    tries     => 3,
    try_sleep => 5,
  }

  exec { "es_bulk_${title}":
    creates => $es_bulk_performed,
    command => "curl -sL -w \"%{http_code}\\n\" -XPUT ${es_url}/${index}/_bulk -d '${content}' -o /dev/null \
    | egrep \"(200|201)\" > /dev/null && touch ${es_bulk_performed}",
  }
}
