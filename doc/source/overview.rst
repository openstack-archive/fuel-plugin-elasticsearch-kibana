.. _user_overview:

Overview
========

The **Elasticsearch-Kibana Fuel Plugin** is used to install and configure
Elasticsearch and Kibana which collectively provide access to the OpenStack
logs and notifications analytics.
Those analytics can be used to search and correlate service-affecting
events which occurred in your OpenStack environment. It is an indispensable
tool to troubleshooting problems.

Elasticsearch and Kibana are key components
of the `LMA Toolchain project <https://launchpad.net/lma-toolchain>`_
as shown in the figure below.

.. image:: ../images/toolchain_map.png
   :align: center

.. _plugin_requirements:

Requirements
------------

+------------------------+------------------------------------------------------------------------------------------+
| **Requirement**        | **Version/Comment**                                                                      |
+========================+==========================================================================================+
| Disk space             | The plugin's specification requires to provision at least 15GB of disk space for the     |
|                        | system, 10GB for the logs and 30GB for the database. As a result, the installation       |
|                        | of the plugin will fail if there is less than 55GB of disk space available on the node.  |
+------------------------+------------------------------------------------------------------------------------------+
| Mirantis OpenStack     | 8.0                                                                                      |
+------------------------+------------------------------------------------------------------------------------------+
| Hardware configuration | The hardware configuration (RAM, CPU, disk) required by this plugin depends on the size  |
|                        | of your cloud environment and other parameters like the retention period and log level.  |
|                        |                                                                                          |
|                        | A typical setup would at least require a quad-core server with 8GB of RAM and fast disks |
|                        | (ideally, SSDs). The actual disk space you need to run the plugin depends on several     |
|                        | factors including the size of your OpenStack environment, the retention period, the      |
|                        | logging level and workload. The more of the above, the more disk space you will need to  |
|                        | run the Elaticsearch-Kibana Plugin. It is also highly recommended to use dedicated       |
|                        | disk(s) for your data storage.                                                           |
+------------------------+------------------------------------------------------------------------------------------+

Limitations
-----------

Currently, the maximum size of an Elasticsearch cluster that can be installed by Fuel is limited to five nodes.
Each node of an Elasticsearch cluster is configured as *master candidate* and a *storage node*.
This means, that each node of the Elasticsearch cluster can be elected as a master and all nodes will store data.

The :ref:`cluster operations <cluster_operations>` can require some manual operations some times.

Key terms, acronyms and abbreviations
-------------------------------------

+----------------------------+--------------------------------------------------------------------------------------+
| **Terms & acronyms**       | **Definition**                                                                       |
+============================+======================================================================================+
| LMA Collector              | Logging, Monitoring and Alerting (LMA) Collector. A service running on each node     |
|                            | which collects all the logs and the OpenStak notifications.                          |
+----------------------------+--------------------------------------------------------------------------------------+
| Elasticsearch              | An open source (Apache Licensed) application based on the  Lucene™ search engine     |
|                            | that makes data like log messages easy to explore and correlate.                     |
|                            |                                                                                      |
|                            | Elasticsearch is written in Java and uses Lucene internally for all of its indexing  |
|                            | and searching, but it aims to make full-text search easy by hiding the complexities  |
|                            | of Lucene behind a simple, coherent, RESTful API.                                    |
+----------------------------+--------------------------------------------------------------------------------------+
| Kibana                     | An open source (Apache Licensed), browser based analytics and search dashboard for   |
|                            | Elasticsearch. Kibana is easy to setup and start using.                              |
+----------------------------+--------------------------------------------------------------------------------------+
