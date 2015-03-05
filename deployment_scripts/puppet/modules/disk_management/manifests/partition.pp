define disk_management::partition {

  $disk = $title
  $script = "/usr/local/bin/add_partition_on_raid.sh"
  $cmd  = "${script} ${disk}"

  case $::osfamily {
    'RedHat': {
      # CentOS deploys /boot into a RAID on all available disks. So in
      # this case we need to create a new partition instead of using the whole
      # disks as we do for Debian family.

      package { 'parted':
        ensure => installed,
      }

      file { $script:
        ensure  => 'file',
        source  => 'puppet:///modules/disk_management/add_partition_on_raid.sh',
        owner   => 'root',
        user    => 'root',
        mode    => '0700',
        require => Package['parted'],
      }

      exec { 'run_script':
        command => $cmd,
        require => File[$script],
      }

      # We know that for RedHat it is partition number 4.
      # We definitely need to improve this.
      $usedisks = split(regsubst($disks, '([a-z]+)', '/dev/\14', 'G'), ',')
    }
  }
}
