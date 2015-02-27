class elasticsearch_kibana::params {
    $lv_name     = "EKlv"
    $vg_name     = "EKvg"
    $device      = "/dev/${vg_name}/${lv_name}"

    # Used to mount the logical volume
    $fstype      = "ext3"

    $es_dir      = "/es-data"
    $es_instance = "es-01"

    $java        = "openjdk-7-jre-headless"
}
