class kibana::params {
  $kibana_dir       = "/opt/kibana"
  $kibana_config    = "${dir}/config.js"
  $kibana_dashboard = "${dir}/app/dashboards/logs.json"
}
