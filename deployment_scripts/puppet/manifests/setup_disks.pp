$fuel_settings = parseyaml(file('/etc/astute.yaml'))

$disks = regsubst($fuel_settings['elasticsearch_kibana']['dedicated_disks'], '([a-z]+)', '/dev/\1', 'G')

class  { 'disk_management':
    disks     => split($disks, ','),
    directory => $fuel_settings['elasticsearch_kibana']['data_dir'],
    lv_name   => "es",
    vg_name   => "data",
}
