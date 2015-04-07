$elasticsearch_kibana = hiera('elasticsearch_kibana')

if $elasticsearch_kibana['node_name'] == hiera('user_node_name') {

  $disks = regsubst($elasticsearch_kibana['dedicated_disks'], '([a-z]+)', '/dev/\1', 'G')
  $array_disks = split($disks, ',')

  class { 'disk_management': }

  disk_management::partition { $array_disks:
    require => Class['disk_management']
  }
}
