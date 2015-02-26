Elasticsearch and Kibana Plugin for Fuel
========================================

Overview
--------

Elasticsearch and Kibana will run on a dedicated node with "Operating System"
roles and the will provide a full-text search engine with a flexible web
interface for exploring and visualizing data.

Installation Guide
==================

To install the Elasticsearch/Kibana plugin, follow these steps:

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

Exploring the data
------------------

Work in progress...

Release Notes
-------------

**6.1.0**

* Initial release of the plugin

Contributors
------------

* Guillaume Thouvenin <gthouvenin@mirantis.com>
* Simon Pasquier <spasquier@mirantis.com>
* Swann Croiset <scroiset@mirantis.com>
