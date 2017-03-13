.. _plugin_requirements:

Requirements
============

The StackLight Elasticsearch-Kibana Plugin 1.1.0 has the following
requirements:

+------------------------+------------------------------------------------------------------------------------------+
| **Requirement**        | **Version/Comment**                                                                      |
+========================+==========================================================================================+
| Disk space             | The plugin's specification requires:                                                     |
|                        |                                                                                          |
|                        | * provisioning at least 15 GB of disk space for the system                               |
|                        | * 10 GB for the logs                                                                     |
|                        | * 30 GB for the database                                                                 |
|                        |                                                                                          |
|                        | As a result, the installation of the plugin will fail if there is less than **55 GB**    |
|                        | of disk space available on the node.                                                     |
+------------------------+------------------------------------------------------------------------------------------+
| Mirantis OpenStack     | 8.0, 9.x                                                                                 |
+------------------------+------------------------------------------------------------------------------------------+
| Hardware configuration | The hardware configuration (RAM, CPU, disk) depends on the size of your cloud environment|
|                        | of your cloud environment and other parameters such as the retention period and log      |
|                        | level.                                                                                   |
|                        | A typical setup would at least requires a quad-core server with 8 GB of RAM and access   |
|                        | to a 500-1000 IOPS disk. For sizeable production deployments it is strongly recommended  |
|                        | to use a disk capable of 1000+ IOPS like an SSD.                                         |
|                        | The actual disk space you need to run the plugin on depends on several                   |
|                        | factors including the size of your OpenStack environment, the retention period, the      |
|                        | logging level, and workload. The more of the above, the more disk space you need to      |
|                        | run the Elaticsearch-Kibana plugin. We also highly recommend using dedicated             |
|                        | disk(s) for your data storage.                                                           |
+------------------------+------------------------------------------------------------------------------------------+


