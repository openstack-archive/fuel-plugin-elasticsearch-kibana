# Class disk_management
#
# This class is used to parition disks. This is achieved by running a
# shell script.
#
# [* script *]
#    The script called to partition disks. The script must be store
#    in the files/ directory.

class disk_management (
  $script = 'UNSET',
) {

  include disk_management::params

  $script_real = $script ? {
    'UNSET' => $disk_management::params::script,
    default => $script
  }

  $puppet_source   = "puppet:///modules/disk_management/${script_real}"
  $script_location = "/usr/local/bin/${script_real}"

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
