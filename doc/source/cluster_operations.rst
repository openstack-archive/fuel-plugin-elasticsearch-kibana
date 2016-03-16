 .. _cluster_operations:

Cluster Operations
==================

Because of certain limitations in the current implementation of the Fuel plugin, it is necessary to
perform some manual operations after the Elasticsearch cluster is scaled up or scaled down.
Those operations are needed to adjust the replication factor of the Elasticsearch indices
consistent with the number of nodes running in the cluster.
There are three types of indices used by the plugin.

  * The log indices named *log-%{+YYYY.MM.dd}* which are created on a daily basis.
  * The notifications indices named *notification-%{+YYYY.MM.dd}* which are also created on a daily
    basis.
  * The Kibana index named *kibana-int* which is created once at installation time to store the
    templates of the Kibana dashboards.

Adjusting the replication factor for the *kibana-int* index is
performed automatically by the plugin and therefore there is no need to do any manualy operation
for that index when the cluster is scaled up or down.

This is not the case for the replication factor of the other two indices which need to
be updated manualy as described in the
`official documentation <https://www.elastic.co/guide/en/elasticsearch/reference/1.7/indices-update-settings.html>`_.

The following sections explain what to do taking the example of scaling up from one node to
three nodes and scaling down from three nodes to one node. Your mileage may vary but the
principal of (re)configuring the replication factor of the indices should remain the same.

Scaling Up
-----------

The problem the manual operation aims to adress is that the replication factor for the old
indicies is not updated automatically by the plugin when a new node is added in the cluster. If you
want the old indicies to be replicated on the new node(s), you need to adjust the
*number_of_replicas* parameter to the current size of the cluster for those indices as shown below.

The output below shows that the replication factor of the indices before the scale up are not
replicated. Here, a scale up was performed on the 3rd of February::

  [root@node-1 ~]# curl <VIP>:9200/_cat/indices?v
  health status index                   pri rep docs.count docs.deleted store.size pri.store.size
  green  open   log-2016.02.03            5   0     270405            0     48.7mb         48.7mb
  green  open   log-2016.02.04            5   2    1934581            0        1gb        384.6mb

Then, if you want the *log-2016.02.03* index to be replicated, you need to update the
*number_of_replicas* paramter of that index as shown below::

  [root@node-1 ~]# curl -XPUT  <VIP>:9200/log-2016.02.03/_settings -d '{ "index": { "number_of_replicas": 2 } }'
  {"acknowledged":true}

  [root@node-1 ~]# curl <VIP>:9200/_cat/indices?v
  health status index                   pri rep docs.count docs.deleted store.size pri.store.size
  green  open   log-2016.02.03            5   2     270405            0    146.3mb         48.7mb
  green  open   log-2016.02.04            5   2    1934581            0        1gb        384.6mb

Note that this will increase the load on the cluster as well as the size of the data store.

Scaling down
------------

Similarly, after a scale down the *number_of_replicas* of all indices must be
aligned with the new size of the cluster. Not doing so will be reported by LMA as a critical
status for the Elasticsearch cluster::

  [root@node-1 ~]# # the current index health is 'red' after the scale down
  [root@node-1 ~]# curl <VIP>:9200/_cat/indices?v
  health  status index                   pri rep docs.count docs.deleted store.size pri.store.size
  red     open   log-2016.02.04            5   2    1934581            0        1gb        384.6mb

  [root@node-1 ~]# curl -XPUT  <VIP>:9200/log-2016.02.04/_settings -d '{ "index": { "number_of_replicas": 0 } }'
  {"acknowledged":true}

  [root@node-1 ~]# # the cluster health is now 'green'
  [root@node-1 ~]# curl <VIP>:9200/_cat/indices?v
  health  status index                   pri rep docs.count docs.deleted store.size pri.store.size
  green     open   log-2016.02.04            5   0    1934581            0    384.6mb        384.6mb
