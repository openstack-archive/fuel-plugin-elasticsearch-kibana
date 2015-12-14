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
$hiera_dir        = '/etc/hiera/override'
$plugin_name      = 'elasticsearch_kibana'
$plugin_yaml      = "${plugin_name}.yaml"
$corosync_roles   = [$plugin_name]

$calculated_content = inline_template('
corosync_roles:
<%
@corosync_roles.each do |crole|
%>  - <%= crole %>
<% end -%>
')

file {$hiera_dir:
  ensure  => directory,
} ->
file { "${hiera_dir}/${plugin_yaml}":
  ensure  => file,
  content => "${calculated_content}\n",
}

package {'ruby-deep-merge':
  ensure  => 'installed',
}

file_line {"${plugin_name}_hiera_override":
  path  => '/etc/hiera.yaml',
  line  => "    - override/${plugin_name}",
  after => '    - "override/module/%{calling_module}"',
}
