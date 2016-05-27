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
# Defined type lma_logging_analytics::es_template

define lma_logging_analytics::es_template (
  $number_of_shards = 5,
  $number_of_replicas = 0,
  $host = 'localhost',
  $port = 9200,
  $index_template = undef,
) {
  if $index_template {
    $template = $index_template
  } else {
    $template = "${title}-*"
  }

  elasticsearch::template { $title:
    content => template("lma_logging_analytics/es_template_${title}.json.erb"),
    host    => $host,
    port    => $port,
  }
}
