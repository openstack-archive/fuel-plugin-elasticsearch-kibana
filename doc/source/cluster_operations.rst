 .. _cluster_operations:

Cluster Operations
==================

Because of certain limitations in the current implementation of the Fuel plugin, it is necessary to
perform some manual operations after the Elasticsearch cluster is scaled up or scaled down.
Those operations are needed to adjust the replication factor of the Elasticsearch indices,
based on the new number of nodes in the cluster.
There are three types of indices used by the plugin:

  * The log indices named *log-%{+YYYY.MM.dd}* which are created on a daily basis.
  * The notification indices named *notification-%{+YYYY.MM.dd}* which are also created on a daily
    basis.
  * The Kibana index named *kibana-int* which is created once at installation time to store the
    templates of the Kibana dashboards.

Adjusting the replication factor for the *kibana-int* index is
performed automatically by the plugin and therefore there is no need to do any manual operation
for that index when the cluster is scaled up or down.

This is not the case for the replication factor of the other two indices which needs to
be updated manualy as described in the
`official documentation <https://www.elastic.co/guide/en/elasticsearch/reference/1.7/indices-update-settings.html>`_.

The following sections provide more details, describing what do when scaling up/down the
Elasticsearch cluster. Scaling up from one node to three nodes, and scaling down from three nodes
to one node, are used as examples. Your mileage may vary but the
principal of (re)configuring the replication factor of the indices should remain the same.

Scaling Up
-----------

The problem the manual operation aims to address is that the replication factor for the old
indices is not updated automatically by the plugin when a new node is added in the cluster. If you
want the old indices to be replicated on the new node(s), you need to adjust the
*number_of_replicas* parameter to the current size of the cluster for those indices as shown below.

The output below shows that the replication factor of the indices created before the scale-up is
zero. Here, a scale-up was performed on the 3rd of February, so the indices created after that date
(*log-2016.02.04* here) are automatically updated with the correct number of replicas
(number of cluster nodes - 1). ::

  [root@node-1 ~]# curl <VIP>:9200/_cat/indices?v
  health status index                   pri rep docs.count docs.deleted ....
  green  open   log-2016.02.03            5   0     270405            0 ....
  green  open   log-2016.02.04            5   2    1934581            0 ....


Then, if you want the *log-2016.02.03* index to be replicated, you need to update the
*number_of_replicas* parameter of that index as shown below::

  [root@node-1 ~]# curl -XPUT  <VIP>:9200/log-2016.02.03/_settings \
    -d '{ "index": {"number_of_replicas": 2}}'
  {"acknowledged":true}

  [root@node-1 ~]# curl <VIP>:9200/_cat/indices?v
  health status index                   pri rep docs.count docs.deleted ....
  green  open   log-2016.02.03            5   2     270405            0 ....
  green  open   log-2016.02.04            5   2    1934581            0 ....


Note that replicating the old indices on the new node(s) will increase the load on the
cluster as well as the size required to store the data.

Scaling down
------------

Similarly, after a scale-down the *number_of_replicas* of all indices must be
aligned with the new size of the cluster. Not doing so will be reported by LMA as a critical
status for the Elasticsearch cluster::

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
