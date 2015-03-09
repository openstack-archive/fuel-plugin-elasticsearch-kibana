define disk_management::partition {

  include disk_management::params

  $disk   = $title
  $script = $disk_management::params::script_location
  $cmd    = "${script} ${disk}"

  exec { $title:
    command => $cmd,
  }
}
