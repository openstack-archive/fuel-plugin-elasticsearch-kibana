define lma_logging_analytics::kibana_dashboard (
  $es_url = 'http://localhost:9200',
  $source = undef,
) {
  include lma_logging_analytics::params

  $dashboard_id = uriescape(join([$lma_logging_analytics::params::kibana_dashboard_prefix, capitalize($title)], ''))

  exec { $title:
    command => "/usr/bin/curl -sL -w \"%{http_code}\\n\" -XPUT ${es_url}/kibana-int/dashboard/${dashboard_id} -d @${source} -o /dev/null | egrep \"(200|201)\" > /dev/null",
  }
}

