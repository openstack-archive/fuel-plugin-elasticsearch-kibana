Elasticsearch-Kibana Plugin for Fuel
====================================

Elasticsearch-Kibana plugin
---------------------------

Overview
--------

Elasticsearch and Kibana provide a full-text search engine with a flexible web
interface for exploring and visualizing data.

Requirements
------------

| Requirement                    | Version/Comment |
|--------------------------------|-----------------|
| Mirantis OpenStack compatility | 6.1 or higher   |

Recommendations
---------------

It is highly recommended to use dedicated disk(s) for data storage. Otherwise
Elasticsearch will store its data on the root filesystem.

Limitations
-----------

None so far.

Installation Guide
==================

**Elasticsearch-Kibana** plugin installation
--------------------------------------------


To install the Elasticsearch-Kibana plugin, follow these steps:

1. Download the plugin from the [Fuel Plugins
   Catalog](https://software.mirantis.com/download-mirantis-openstack-fuel-plug-ins/).

2. Copy the plugin file to the Fuel Master node. Follow the [Quick start
   guide](https://software.mirantis.com/quick-start/) if you don't have a running
   Fuel Master node yet.

   ```
   scp elasticsearch_kibana-0.7-0.7.0-0.noarch.rpm root@<Fuel Master node IP address>:
   ```

3. Install the plugin using the `fuel` command line:

   ```
   fuel plugins --install elasticsearch_kibana-0.7-0.7.0-0.noarch.rpm
   ```

4. Verify that the plugin is installed correctly:

   ```
   fuel plugins --list
   ```

Please refer to the [Fuel Plugins wiki](https://wiki.openstack.org/wiki/Fuel/Plugins)
if you want to build the plugin by yourself. Version 2.0.0 (or higher) of the Fuel
Plugin Builder is required.

User Guide
==========

**Elasticsearch-Kibana** plugin configuration
---------------------------------------------

1. Create a new environment with the Fuel UI wizard.
2. Add a node with the "Operating System" role.
3. Before applying changes or once changes applied, edit the name of the node by
   clicking on "Untitled (xx:yy)" and modify it for "elasticsearch".
4. Click on the Settings tab of the Fuel web UI.
5. Scroll down the page, select the "Elasticsearch-Kibana Server plugin" checkbox
   and fill-in the required fields.

### Heap sizing
The default installation of Elasticsearch is configured with a 1 GB heap. In
many cases this number will be too small. You can modify this value up to
32GB. The recommendation is to give 50% of the available memory to
Elasticsearch heap. If you set a value that is greater than the memory size of
your machine, Elasticsearch will not be able to start.


### Disks partitionning
You can select up to 3 physical disks that will be mounted as a single logical
volume to store the Elasticsearch data. If you specify no disk, the data will
be stored on the root filesystem. In all cases, Elasticsearch data will be
located in the */opt/es-data* directory.

For each disk, you can also specify the allocated size (in GB). If you don't
specify a value, the plugin will use all the free space of the disk.


Testing
-------

### Elasticsearch

Once installed, you can check that Elasticsearch is working using `curl`:

```
curl http://$HOST:9200/
```

Where `HOST` is the IP address or the name of the node that runs the server.

The expected output is something like this:

```
{
  "status" : 200,
  "name" : "node-23-es-01",
  "cluster_name" : "elasticsearch",
  "version" : {
    "number" : "1.4.4",
    "build_hash" : "c88f77ffc81301dfa9dfd81ca2232f09588bd512",
    "build_timestamp" : "2015-02-19T13:05:36Z",
    "build_snapshot" : false,
    "lucene_version" : "4.10.3"
  },
  "tagline" : "You Know, for Search"
}
```

### Kibana

The Kibana user interface is available at the following URL:

http://$HOST/

Where `HOST` is the IP address or the name of the node. By default, you will
be redirected to the logs dashboard.

Known issues
------------

None.

Release Notes
-------------

**0.7.0**

* Initial release of the plugin. This is a beta version.

Development
===========

The *OpenStack Development Mailing List* is the preferred way to communicate,
emails should be sent to `openstack-dev@lists.openstack.org` with the subject
prefixed by `[fuel][plugins][lma]`.

Reporting Bugs
--------------

Bugs should be filled on the [Launchpad fuel-plugins project](
https://bugs.launchpad.net/fuel-plugins) (not GitHub) with the tag `lma`.


Contributing
------------

If you would like to contribute to the development of this Fuel plugin you must
follow the [OpenStack development workflow](
http://docs.openstack.org/infra/manual/developers.html#development-workflow).

Patch reviews take place on the [OpenStack gerrit](
https://review.openstack.org/#/q/status:open+project:stackforge/fuel-plugin-elasticsearch-kibana,n,z)
system.

Contributors
------------

* Guillaume Thouvenin <gthouvenin@mirantis.com>
* Simon Pasquier <spasquier@mirantis.com>
* Swann Croiset <scroiset@mirantis.com>
