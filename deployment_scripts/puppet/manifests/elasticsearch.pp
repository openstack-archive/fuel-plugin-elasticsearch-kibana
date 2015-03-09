$fuel_settings = parseyaml(file('/etc/astute.yaml'))

if $fuel_settings['elasticsearch_kibana']['node_name'] == $fuel_settings['user_node_name'] {

  # Params related to Elasticsearch.
  $es_dir      = $fuel_settings['elasticsearch_kibana']['data_dir']
  $es_instance = "es-01"

  # Java
  $java = $::operatingsystem ? {
    CentOS => "java-1.8.0-openjdk-headless",
    Ubuntu => "openjdk-7-jre-headless"
  }

  # Ensure that java is installed
  package { $java:
    ensure => installed,
  }

  # Install elasticsearch
  class { "elasticsearch":
    datadir => ["${es_dir}/elasticsearch_data"],
    require => [Package[$java]],
  }

  # Start an instance of elasticsearch
  elasticsearch::instance { $es_instance:
    config => {
      "http.cors.allow-origin" => "/.*/",
      "http.cors.enabled" => "true"
    },
  }

  lma_logging_analytics::es_template { ['log', 'notification']:
    require => Elasticsearch::Instance[$es_instance],
  }
}
