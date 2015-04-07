$elasticsearch_kibana = hiera('elasticsearch_kibana')

if $elasticsearch_kibana['node_name'] == hiera('user_node_name') {
  class { 'lma_logging_analytics::kibana': }
}
