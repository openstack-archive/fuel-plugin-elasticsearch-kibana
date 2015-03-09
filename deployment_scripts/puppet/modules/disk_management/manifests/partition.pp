define disk_management::partition {

  $script = $::osfamily ? {
    RedHat => "add_partition_on_raid.sh",
    Debian => "add_partition.sh",
  }

  $disk            = $title
  $puppet_source   = "puppet:///modules/disk_management/${script}"
  $script_location = "/usr/local/bin/${script}"
  $cmd             = "${script_location} ${disk}"

  package { 'parted':
    ensure => installed,
  }

  file { $script_location:
    ensure  => 'file',
    source  => $puppet_source,
    owner   => 'root',
    group   => 'root',
    mode    => '0700',
    require => Package['parted'],
  }

  exec { 'run_script':
    command => $cmd,
    require => File[$script_location],
  }
}
