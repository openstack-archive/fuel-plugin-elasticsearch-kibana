Elasticsearch-Kibana Plugin
===========================

Requirements
------------

| Requirement                    | Version/Comment |
|--------------------------------|-----------------|
| Mirantis OpenStack compatility | 6.1 or higher   |


Limitations
-----------

None so far.

Installation Guide
==================

**Elasticsearch-Kibana** installation
-------------------------------------


To install the Elasticsearch-Kibana plugin, follow these steps:

1. Download the plugin from the [Fuel Plugins
   Catalog](https://software.mirantis.com/download-mirantis-openstack-fuel-plug-ins/).

2. Copy the plugin file to the Fuel Master node.
```
scp elasticsearch-kibana-plugin-6.1.0.fp root@<IP address>:
```
3. Install the plugin using the `fuel` command line:
```
fuel plugins --install elasticsearch-kibana-plugin-6.1.0.fp
```
4. Verify that the plugin is installed correctly:
```
fuel plugins --list
```

User Guide
==========

Known issues
------------

Work in progress...

Release Notes
-------------

* Initial release of the plugin

Contributors
------------

* Guillaume Thouvenin <gthouvenin@mirantis.com>
* Simon Pasquier <spasquier@mirantis.com>
* Swann Croiset <scroiset@mirantis.com>
