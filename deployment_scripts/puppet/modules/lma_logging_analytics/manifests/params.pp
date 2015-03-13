class lma_logging_analytics::params {
  $kibana_dir              = "/opt/kibana"
  $kibana_config           = "${kibana_dir}/config.js"
  $kibana_dashboard_dir    = "${kibana_dir}/app/dashboards"
  $kibana_dashboard_prefix = "Logging, Monitoring and Alerting - "
  $kibana_default_route    = "/dashboard/elasticsearch/Logging, Monitoring and Alerting - Logs"
}
