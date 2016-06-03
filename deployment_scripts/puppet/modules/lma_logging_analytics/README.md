LMA Logging Analytics module for Puppet
=======================================

Description
-----------

Puppet module for configuring the Kibana dashboard and Elasticsearch.

Usage
-----

```puppet
class {'lma_logging_analytics::elasticsearch':
  listen_address       => 'localhost',
  node_name            => $::fqdn,
  nodes                => [$::fqdn, 'node-x', 'node-y']
  data_dir             => '/opt/es-data'
  instance_name        => 'es-01',
  heap_size            => 16,
  cluster_name         => 'my_cluster',
}

class {'lma_logging_analytics::kibana': }
```

Limitations
-----------

None.

License
-------

Licensed under the terms of the Apache License, version 2.0.

Contact
-------

Guillaume Thouvenin, <gthouvenin@mirantis.com>

Support
-------

See the Contact section.
