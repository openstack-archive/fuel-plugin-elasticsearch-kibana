.. _limitations:

Limitations
===========

The StackLight Elasticsearch-Kibana plugin 1.1.0 has the following
limitations:

* Currently, the maximum size of an Elasticsearch cluster that can be
  installed by Fuel is limited to five nodes. But each node of an Elasticsearch
  cluster is configured as *master candidate* and a *storage node*. This means
  that each node of an Elasticsearch cluster can be selected as master, and
  all nodes will store data.

* The :ref:`cluster operations <cluster_operations>` may require manual
  operations.
