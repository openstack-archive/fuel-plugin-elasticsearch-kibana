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
