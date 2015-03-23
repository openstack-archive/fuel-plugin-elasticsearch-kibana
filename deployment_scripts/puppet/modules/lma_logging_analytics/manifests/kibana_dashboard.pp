define lma_logging_analytics::kibana_dashboard (
  $es_url = 'http://localhost:9200',
  $content = undef,
) {
  include lma_logging_analytics::params

  $dashboard_title = join([$lma_logging_analytics::params::kibana_dashboard_prefix, capitalize($title)], '')
  $dashboard_id = uriescape($dashboard_title)

  $dashboard_source = encode_kibana_dashboard('guest', 'guest', $dashboard_title, $content)

  exec { $title:
    command => "/usr/bin/curl -sL -w \"%{http_code}\\n\" -XPUT ${es_url}/kibana-int/dashboard/${dashboard_id} -d '${dashboard_source}' -o /dev/null | egrep \"(200|201)\" > /dev/null",
  }
}
