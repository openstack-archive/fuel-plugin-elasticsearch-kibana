Elasticsearch-Kibana Plugin for Fuel
====================================

The **Elasticsearch-Kibana Fuel Plugin** is used to install and configure
Elasticsearch and Kibana which collectively provide access to the OpenStack
logs and notifications analytics.
Those analytics can be used to search and correlate the service-affecting
events which occurred in your OpenStack environment. It is an indispensable
tool to troubleshooting problems.
The Elasticsearch-Kibana Plugin is a key component of the
**Logging, Monitoring and Alerting (LMA) Toolchain** of Mirantis OpenStack.

Release Notes
-------------

**0.8.0**

* Add support for the "elasticsearch_kibana" Fuel Plugin role instead of
  of the "base-os" role which had several limitations.
* Add support for a retention policy configuration thanks to the integration
  of [Elastic Curator](https://github.com/elastic/curator)
* Upgrade to Elasticsearch 1.4.5

**0.7.0**

* Initial release of the plugin. This is a beta version.

Requirements
------------

| Requirement            | Version/Comment                             |
|------------------------|---------------------------------------------|
| Fuel                   | Mirantis OpenStack 7.0 or higher            |
| Hardware configuration | The hardware configuration (RAM, CPU, disk) |
|                        | required by this plugin depends on the size |
|                        | of your cloud and other parameters like the |
|                        | log level being used, but a typical setup   |
|                        | would at least require a quad-core server   |
|                        | with 8GB of RAM and fast disks (ideally     |
|                        | SSDs). It is also highly recommended to use |
|                        | dedicated disk(s) for your data storage.    |
|                        | Otherwise, Elasticsearch will use the root  |
|                        | filesystem by default.                      |

Known issues
------------

No known issues so far.

Limitations
-----------

A current limitation of this plugin is that it not possible to
display in the Fuel web UI the URL where the Kibana interface
can be reached when the deployment has completed.
Instructions are provided in the *Installation Guide* about how you can
obtain this URL using the `fuel` command line.

Installation
------------

Please follow the installation instructions in the [Elasticsearch-Kibana Fuel
Plugin Installation Guide](
http://fuel-plugin-elasticsearch-kibana.readthedocs.org/en/latest/installation.html)

User Guide
----------

How to configure and use the Elasticsearch-Kibana Fuel Plugin is detailed in
in the [Elasticsearch-Kibana Fuel Plugin User Guide](
http://fuel-plugin-elasticsearch-kibana.readthedocs.org/en/latest/user.html)

Communication
-------------

The *OpenStack Development Mailing List* is the preferred way to communicate
with the members of the project.
Emails should be sent to `openstack-dev@lists.openstack.org` with the subject
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
* Patrick Petit <ppetit@mirantis.com>
* Simon Pasquier <spasquier@mirantis.com>
* Swann Croiset <scroiset@mirantis.com>
