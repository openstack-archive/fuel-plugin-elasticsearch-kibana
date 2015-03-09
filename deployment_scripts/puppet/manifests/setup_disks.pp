$fuel_settings = parseyaml(file('/etc/astute.yaml'))

if $fuel_settings['elasticsearch_kibana']['node_name'] == $fuel_settings['user_node_name'] {

  $disks = regsubst($fuel_settings['elasticsearch_kibana']['dedicated_disks'], '([a-z]+)', '/dev/\1', 'G')
  $array_disks = split($disks, ',')

  class { 'disk_management': }

  disk_management::partition { $array_disks:
    require => Class['disk_management']
  }
}
