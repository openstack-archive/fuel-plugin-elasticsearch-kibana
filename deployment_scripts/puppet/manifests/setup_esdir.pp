$fuel_settings = parseyaml(file('/etc/astute.yaml'))

if $fuel_settings['elasticsearch_kibana']['node_name'] == $fuel_settings['user_node_name'] {

  $directory = $fuel_settings['elasticsearch_kibana']['data_dir']
  $disks = split($::unallocated_pvs, ',')

  validate_array($disks)

  if empty($disks) {
    file { $directory:
      ensure => "directory",
    }
  } else {
    disk_management::lvm_fs { $directory:
      disks   => $::unallocated_pvs,
      lv_name => "es",
      vg_name => "data",
  }
}
