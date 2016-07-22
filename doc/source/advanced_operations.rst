.. _advanced_user_guide:

Advanced operations
===================

This section describes advanced operations that you can apply to your
Elasticsearch cluster using the StackLight Elasticsearch-Kibana Fuel plugin.

.. _cluster_operations:

Cluster operations
------------------

Because of limitations in the current implementation of the plugin, manual
operations are required after the Elasticsearch cluster is scaled up or scaled down. Using these operations, you can adjust the replication factor of the
Elasticsearch indices that are based on the new number of nodes on the cluster.

The plugin uses three types of indices:

* The log indices named *log-%{+YYYY.MM.dd}* which are created on a daily basis.
* The notification indices named *notification-%{+YYYY.MM.dd}* which are
  created on a daily basis.
* The Kibana index named *kibana-int* which is created once during the
  installation to store the templates of the Kibana dashboards.

Adjusting the replication factor for the *kibana-int* index is performed
automatically by the plugin. Therefore, no manual operation is required
for this index when the cluster is scaled up or down. But this is not the case
for the replication factor of other two indices that you should manually
update as described in the
`Elasticsearch official documentation <https://www.elastic.co/guide/en/elasticsearch/reference/1.7/indices-update-settings.html>`_.

The following sections describe in detail how to scale up and scale down the
Elasticsearch cluster. Scaling up from one node to three nodes and scaling
down from three nodes to one node are used as examples. Your mileage may vary,
but the principal of (re)configuring the replication factor of the indices
should remain the same.

Scaling up
~~~~~~~~~~

The problem that the manual operation aims to address is that the replication
factor for the old indices is not updated automatically by the plugin when
a new node is added in the cluster. If you want the old indices to be
replicated on the new node(s), adjust the *number_of_replicas*
parameter to the current size of the cluster for those indices as shown below.

The output below shows that the replication factor of the indices created
before the scale-up is zero. In this example, a scale-up was performed on the
3rd of February. Therefore, the indices created after that date
(*log-2016.02.04* in this example) are automatically updated with the correct
number of replicas (number of cluster nodes - 1).

.. code-block:: console

  [root@node-1 ~]# curl <VIP>:9200/_cat/indices?v
  health status index                   pri rep docs.count docs.deleted ....
  green  open   log-2016.02.03            5   0     270405            0 ....
  green  open   log-2016.02.04            5   2    1934581            0 ....

If you want the *log-2016.02.03* index to be replicated, update the
*number_of_replicas* parameter of that index:

.. code-block:: console

  [root@node-1 ~]# curl -XPUT  <VIP>:9200/log-2016.02.03/_settings \
    -d '{ "index": {"number_of_replicas": 2}}'
  {"acknowledged":true}

  [root@node-1 ~]# curl <VIP>:9200/_cat/indices?v
  health status index                   pri rep docs.count docs.deleted ....
  green  open   log-2016.02.03            5   2     270405            0 ....
  green  open   log-2016.02.04            5   2    1934581            0 ....

.. caution:: Replicating the old indices on the new node(s) will increase the
   load on the cluster as well as the size required to store the data.

Scaling down
~~~~~~~~~~~~

After a scale-down, align the *number_of_replicas* of all indices with the
new size of the cluster. Otherwise, StackLight reports a critical status of
the Elasticsearch cluster:

.. code-block:: console

  [root@node-1 ~]# # the current index health is 'red' after the scale-down
  [root@node-1 ~]# curl <VIP>:9200/_cat/indices?v
  health  status index                  pri rep docs.count ....
  red     open   log-2016.02.04           5   2    1934581 ....

  [root@node-1 ~]# curl -XPUT  <VIP>:9200/log-2016.02.04/_settings \
    -d '{"index": {"number_of_replicas": 0}}'
  {"acknowledged":true}

  [root@node-1 ~]# # the cluster health is now 'green'
  [root@node-1 ~]# curl <VIP>:9200/_cat/indices?v
  health  status index                  pri rep docs.count ....
  green   open   log-2016.02.04           5   2    1934581 ....
