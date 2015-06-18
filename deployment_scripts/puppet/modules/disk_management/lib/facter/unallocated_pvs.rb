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
# Return the list of LVM disk partition that haven't been allocated yet
unallocated_pvs = []

# Enumerate disk devices
devices = Dir.entries('/sys/block/').select do |d|
    File.exist?( "/sys/block/#{ d }/device" )
end

if Facter::Util::Resolution.which("parted") and Facter::Util::Resolution.which('pvs') then
    devices.each do |device|
        device = "/dev/#{ device }"
        # Filter only partitions flagged as LVM
        lvm_partitions = Facter::Util::Resolution.exec(
            "parted -s -m #{ device } print 2>/dev/null").scan(/^(\d+):.+:lvm;$/).flatten
        lvm_partitions.each do |x|
            # Filter only partitions which haven't been created yet
            pvs = Facter::Util::Resolution.exec(
                "pvs --noheadings #{ device }#{ x } 2>/dev/null")
            if pvs.nil? then
                unallocated_pvs.push("#{ device }#{ x }")
            end
        end
    end
end

Facter.add("unallocated_pvs") { setcode { unallocated_pvs.sort.join(',') } }
