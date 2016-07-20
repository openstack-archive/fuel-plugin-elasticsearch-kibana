.. _limitations:

Limitations
===========

Currently, the maximum size of an Elasticsearch cluster that can be installed
by Fuel is limited to five nodes.

Each node of an Elasticsearch cluster is configured as *master candidate* and
a *storage node*. This means that each node of the Elasticsearch cluster can
be elected as master and all nodes will store data.

The :ref:`cluster operations <cluster_operations>` may require manual
operations.
