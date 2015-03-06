class kibana::params {
  $kibana_dir       = "/opt/kibana"
  $kibana_config    = "${kibana_dir}/config.js"
  $kibana_dashboard = "${kibana_dir}/app/dashboards/logs.json"
}
