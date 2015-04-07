$elasticsearch_kibana = hiera('elasticsearch_kibana')

if $elasticsearch_kibana['node_name'] == hiera('user_node_name') {

  $directory = $elasticsearch_kibana['data_dir']
  $disks = split($::unallocated_pvs, ',')

  validate_array($disks)

  if empty($disks) {
    file { $directory:
      ensure => 'directory',
    }
  } else {
    disk_management::lvm_fs { $directory:
      disks   => $disks,
      lv_name => 'es',
      vg_name => 'data',
    }
  }
}
