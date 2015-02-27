$fuel_settings = parseyaml(file('/etc/astute.yaml'))

class { 'elasticsearch_kibana':
    pv_name => '/dev/sdb',
    lv_name => 'EKlv',
    vg_name => 'EKvg',
    es_dir  => '/es-data',
    es_version  => '1.4.4',
    es_instance => 'es-01',
}
