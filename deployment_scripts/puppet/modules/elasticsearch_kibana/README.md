Elasticsearch_kibana module for Puppet
======================================

Description
-----------

Puppet module for configuring the elasticsearch server and kibana visualizer.

Usage
-----

```puppet
class {'elasticsearch_kibana':
  pv_name => '/dev/sdb',
  vg_name => 'EKvg',
  lv_name => 'EKlv',
  es_dir  => '/es-data',
  es_version  => '1.4.4',
  es_instance => 'es-01',
}

```

Limitations
-----------

None.

License
-------

Licensed under the terms of the Apache License, version 2.0.

Contact
-------

Guillaume Thouvenin, <thouveng@mirantis.com>

Support
-------

See the Contact section.
