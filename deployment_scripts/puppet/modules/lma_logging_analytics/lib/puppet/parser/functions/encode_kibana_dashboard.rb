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
# Encode a Kibana dashboard file
require 'json'

module Puppet::Parser::Functions
  newfunction(:encode_kibana_dashboard, :type => :rvalue, :doc => <<-EOS
    Encodes a Kibana dashboard for storing it to Elasticsearch.
    EOS
  ) do |args|
    raise(Puppet::ParseError, "encode_kibana_dashboard(): Wrong number of " +
      "arguments given (#{args.size} for 4)") if args.size != 4

    user = args[0]
    group = args[1]
    title = args[2]
    data = args[3]

    return JSON.generate({
        'user' => user,
        'group' => group,
        'title' => title,
        'dashboard' => data
    })
  end
end
