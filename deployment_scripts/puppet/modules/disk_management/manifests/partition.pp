define disk_management::partition {

  $disk            = $title
  $script          = "add_partition.sh"
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
