$elasticsearch_kibana = hiera('elasticsearch_kibana')

if $elasticsearch_kibana['node_name'] == hiera('user_node_name') {

  class { 'disk_management': }

  if ($elasticsearch_kibana['disk1']) {
    disk_management::partition { "/dev/${elasticsearch_kibana['disk1']}":
      size    => $elasticsearch_kibana['disk1_size'],
      require => Class['disk_management'],
    }
  }

  if ($elasticsearch_kibana['disk2']) {
    disk_management::partition { "/dev/${elasticsearch_kibana['disk2']}":
      size    => $elasticsearch_kibana['disk2_size'],
      require => Class['disk_management'],
    }
  }

  if ($elasticsearch_kibana['disk3']) {
    disk_management::partition { "/dev/${elasticsearch_kibana['disk3']}":
      size    => $elasticsearch_kibana['disk3_size'],
      require => Class['disk_management'],
    }
  }
}
