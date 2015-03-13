define lma_logging_analytics::kibana_dashboard (
  $es_url = 'http://localhost:9200',
  $source = undef,
) {
  include lma_logging_analytics::params

  $dashboard_id = uriescape(join([$lma_logging_analytics::params::kibana_dashboard_prefix, capitalize($title)], ''))

  $dash_content = regsubst(
                     regsubst(file($source), '"', '\"', 'G'),
                     '\n', '', 'G'
                )
  $dash = "{\"group\": \"guest\", \"title\": \"${lma_logging_analytics::params::kibana_dashboard_prefix} ${title}\", \"user\": \"guest\", \"dashboard\": \"${dash_content}\" }"
  exec { $title:
    command => "/usr/bin/curl -sL -w \"%{http_code}\\n\" -XPUT ${es_url}/kibana-int/dashboard/${dashboard_id} -d '${dash}' -o /dev/null | egrep \"(200|201)\" > /dev/null",
  }

}

