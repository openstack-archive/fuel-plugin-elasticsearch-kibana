class disk_management (
  $script          = $disk_management::params::script,
  $puppet_source   = $disk_management::params::puppet_source,
  $script_location = $disk_management::params::script_location,
) inherits disk_management::params {

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
}
