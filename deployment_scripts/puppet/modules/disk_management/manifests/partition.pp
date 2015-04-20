#    Copyright 2015 Mirantis, Inc.
#
#    Licensed under the Apache License, Version 2.0 (the "License"); you may
#    not use this file except in compliance with the License. You may obtain
#    a copy of the License at
#
#         http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
#    WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
#    License for the specific language governing permissions and limitations
#    under the License.
#
# Class that partition the disk
# If a disk is given as title we check for free space and allocated
# this free space by calling the script given as parameter.

define disk_management::partition {

  include disk_management::params

  $disk   = $title
  $script = $disk_management::params::script_location
  $cmd    = "${script} ${disk}"

  exec { $title:
    command => $cmd,
  }
}
