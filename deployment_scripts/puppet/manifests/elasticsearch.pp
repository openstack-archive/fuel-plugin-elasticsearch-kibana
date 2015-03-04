$fuel_settings = parseyaml(file('/etc/astute.yaml'))

$disks = regsubst($fuel_settings['elasticsearch_kibana']['dedicated_disks'], '([a-z]+)', '/dev/\1', 'G')

# Params for managing volumes.
$pv_name = split($disks, ',')
$lv_name = "EKlv"
$vg_name = "EKvg"
$device  = "/dev/${vg_name}/${lv_name}"
$fstype = "ext3"

# Params related to Elasticsearch.
$es_dir = "/es-data"
$es_instance = "es-01"
$java = "openjdk-7-jre-headless"


# Creates the logical volume
lvm::volume { $lv_name:
  ensure => present,
  vg     => $vg_name,
  pv     => $pv_name,
  fstype => $fstype,
}

# create the directory
file { $es_dir:
  ensure => directory,
}

# Mount the directory
mount { $es_dir:
  device  => $device,
  ensure  => mounted,
  fstype  => $fstype,
  options => "defaults",
  require => [File[$es_dir], Lvm::Volume[$lv_name]],
}

# Ensure that java is installed
package { $java:
  ensure => installed,
}

# Install elasticsearch
class { "elasticsearch":
  datadir => ["${es_dir}/elasticsearch_data"],
  require => [Mount[$es_dir], Package[$java]],
}

# Start an instance of elasticsearch
elasticsearch::instance { $es_instance: }
