Elasticsearch-Kibana Plugin for Fuel
====================================

Elasticsearch-Kibana plugin
---------------------------

Overview
--------

The Elasticsearch-Kibana Fuel Plugin is used to install and configure
Elasticsearch combined with Kibana for logs and notifications analytics
visualization.
The logs analytics are used to search and correlate service-affecting
events obtained from the OpenStack environment logs.
Elasticsearch is a powerful application based on the Lucene search engine
that makes data like log messages easy to explore and correlate.
This is an indispensable tool of the LMA Toolchan for troubleshooting problems.
Kibana is installed with two dashboards. One for the logs and one for the
OpenStack notifications.
Each dashboard provides a single pane of glass and search capabilities
for all the logs and all the notifications. It is possible to tag the logs
by environment name so that one can use one Elasticsearch server instance
for multiple environments.

Requirements
------------

| Requirement                    | Version/Comment |
|--------------------------------|-----------------|
| Mirantis OpenStack compatility | 7.0 or higher   |


Recommendations
---------------

It is highly recommended to use a dedicated disk(s) for data storage. Otherwise
Elasticsearch will store its data on the root filesystem.

Limitations
-----------

No known limitations.

Installation Guide
==================

Please refer to the [Elasticsearch-Kibana Fuel Plugins Installation Guide]
(https://github.com/stackforge/fuel-plugin-elasticsearch-kibana/blob/master/doc/source/installation.rst)

User Guide
==========

**Elasticsearch-Kibana** plugin configuration
---------------------------------------------

1. Create a new environment with the Fuel UI wizard.
2. Click on the Settings tab of the Fuel web UI.
3. Scroll down the page, select the "Elasticsearch-Kibana Server plugin" tab,
   enable the plugin and fill-in the required fields.
4. Add a node with the "Elasticsearch Kibana" role.

### Heap sizing
By default, 1G of heap memory is allocated to the Elasticsearch process. In
many cases this number will be too small. You can modify this value up to
32GB. The recommendation is to give 50% of the available memory to
Elasticsearch. If you set a value that is greater than the memory size of
the node, Elasticsearch won't start.

### Disks partitioning
The plugin uses:

- 20% of the first disk for the operating system by honoring the range of
  15GB minimum and 50GB maximum.
- 10GB for /var/log.
- at least 30GB for the Elasticsearch data (/opt/es-data).

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

**0.8.0**

* Add the "elasticsearch_kibana" role (instead of leveraging on the
  "base-os" role)
* Add support for data curation
* Upgrade Elasticsearch to 1.4.5

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
