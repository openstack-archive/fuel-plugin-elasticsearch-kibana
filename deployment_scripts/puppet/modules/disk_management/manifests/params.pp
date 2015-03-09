class disk_management::params {
  $script          = "add_partition.sh"
  $puppet_source   = "puppet:///modules/disk_management/${script}"
  $script_location = "/usr/local/bin/${script}"
}
