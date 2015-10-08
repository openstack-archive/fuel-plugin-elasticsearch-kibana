.. _user_overview:

Overview
========

The **Elasticsearch-Kibana Fuel Plugin** is used to install and configure
Elasticsearch and Kibana which collectively provide access to the OpenStack
logs and notifications analytics.
Those analytics can be used to search and correlate the service-affecting
events which occurred in your OpenStack environment. It is an indispensable
tool to troubleshooting problems.
The Elasticsearch-Kibana Plugin is a key component of the
**Logging, Monitoring and Alerting (LMA) Toolchain** of Mirantis OpenStack.

.. _plugin_requirements:

Requirements
------------

+----------------------------+--------------------------------------------------------------------------------------------+
| **Requirement**            | **Version/Comment**                                                                        |
+============================+============================================================================================+
| Fuel                       | Mirantis OpenStack 7.0                                                                     |
+----------------------------+--------------------------------------------------------------------------------------------+
| Hardware configuration     | The hardware configuration (RAM, CPU, disk) required by this plugin depends on the size    |
|                            | of your cloud and other parameters like the log level being used, but a typical setup      |
|                            | would at least require a quad-core server with 8GB of RAM and fast disks (ideally, SSDs)   |
|                            | It is also highly recommended to use dedicated disk(s) for your data storage. Otherwise,   |
|                            | Elasticsearch will use the root filesystem by default.                                     |
+----------------------------+--------------------------------------------------------------------------------------------+

Limitations
-----------

A current limitation of this plugin is that it not possible to display in the Fuel web UI the URL where the Kibana interface
can be reached when the deployment has completed. Instructions are provided in the *Installation Guide* about how you can
obtain this URL using the `fuel` command line.

Key terms, acronyms and abbreviations
-------------------------------------

+----------------------------+--------------------------------------------------------------------------------------------+
| **Terms & acronyms**       | **Definition**                                                                             |
+============================+============================================================================================+
| LMA Collector              | Logging, Monitoring and Alerting (LMA) Collector. A service running on each OpenStack      |
|                            | node which collects all the logs and the OpenStak notifications.                           |
+----------------------------+--------------------------------------------------------------------------------------------+
| Elasticsearch              | An open source (Apache Licensed) application based on the  Lucene™ search engine that makes|
|                            | data like log messages easy to explore and correlate.                                      |
|                            | Elasticsearch is written in Java and uses Lucene internally for all of its indexing and    |
|                            | searching, but it aims to make full-text search easy by hiding the complexities of Lucene  |
|                            | behind a simple, coherent, RESTful API.                                                    |
+----------------------------+--------------------------------------------------------------------------------------------+
| Kibana                     | An open source (Apache Licensed), browser based analytics and search dashboard for         |
|                            | Elasticsearch. Kibana is easry to setup and start using.                                   |
+----------------------------+--------------------------------------------------------------------------------------------+
