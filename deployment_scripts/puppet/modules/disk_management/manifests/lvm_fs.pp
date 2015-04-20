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
# Define Resource Type: disk_management::lvm_fs

define disk_management::lvm_fs (
  $disks,
  $lv_name,
  $vg_name,
  $fstype = 'ext3',
) {

  $directory = $title
  $device  = "/dev/${vg_name}/${lv_name}"

  # Creates the logical volume
  lvm::volume { $lv_name:
    ensure => present,
    pv     => $disks,
    vg     => $vg_name,
    fstype => $fstype,
  }

  # create the directory
  file { $directory:
    ensure => directory,
  }

  # Mount the directory
  mount { $directory:
    ensure  => mounted,
    device  => $device,
    fstype  => $fstype,
    options => 'defaults',
    require => [File[$directory], Lvm::Volume[$lv_name]],
  }
}
