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
