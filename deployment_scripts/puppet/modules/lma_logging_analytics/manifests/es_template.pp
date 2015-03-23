# Defined type lma_logging_analytics::es_template

define lma_logging_analytics::es_template (
  $number_of_shards = 3
) {
  $index_prefix = $title

  elasticsearch::template { $title:
    content => template('lma_logging_analytics/es_template.json.erb'),
  }
}
