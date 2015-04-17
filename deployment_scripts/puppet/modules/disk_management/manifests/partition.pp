# Class that partition the disk
# If a disk is given as title we check for free space and allocated
# this free space by calling the script given as parameter.

define disk_management::partition (
  $size = undef,
){

  include disk_management::params

  $disk   = $title
  $script = $disk_management::params::script_location
  $cmd    = "${script} ${disk} ${size}"

  exec { $title:
    command => $cmd,
  }
}
