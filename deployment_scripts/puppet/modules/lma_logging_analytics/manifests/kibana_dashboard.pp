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
define lma_logging_analytics::kibana_dashboard (
  $host = 'localhost',
  $port = '9200',
  $content = undef,
) {
  include lma_logging_analytics::params

  $es_url = "http://${host}:${port}"
  $dashboard_title = join([$lma_logging_analytics::params::kibana_dashboard_prefix, capitalize($title)], '')
  $dashboard_id = uriescape($dashboard_title)

  $dashboard_source = encode_kibana_dashboard('guest', 'guest', $dashboard_title, $content)

  exec { $title:
    onlyif  => ["/usr/bin/curl -sL -w \"%{http_code}\\n\" -XGET ${es_url}/_cluster/health?wait_for_status=green | grep 200 > /dev/null",
                "/usr/bin/curl -sL -w \"%{http_code}\\n\" -XHEAD ${es_url}/kibana-int/dashboard/${dashboard_id} | grep 404 > /dev/null"],
    command => "/usr/bin/curl -sL -w \"%{http_code}\\n\" -XPUT ${es_url}/kibana-int/dashboard/${dashboard_id} -d '${dashboard_source}' -o /dev/null | egrep \"(200|201)\" > /dev/null",
  }
}
