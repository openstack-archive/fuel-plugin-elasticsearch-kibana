 .. _cluster_operations:

Cluster Operations
==================

All logs and OpenStack notifications are stored in Elasticsearch indices which are partionned by day.
There are respectively named *log-%{+YYYY.MM.dd}* and *notification-%{+YYYY.MM.dd}*.

Manual operation to
`update indices settings <https://www.elastic.co/guide/en/elasticsearch/reference/1.7/indices-update-settings.html>`_
is required when scaling the Elasticsearch cluster.

A third index type named *kibana-int* is used to store Kibana dashboards.
There is only one index and the replication settings is automatically updated.

Scale up
--------

After a scale up of the cluster (eg. from 1 to 3 nodes), the previously created
indices are not automatically replicated on the new nodes freshly added.
In order to ensure the high availability of these 'old' indices it requires to adjust
the *number_of_replicas* to reflect the current cluster size.

The following example shows a scale up operation performed on 3 february, which let the current index
not replicated while the index of the following day is well replicated.
The manual operation consists to increase the number_of_replicas setting of the ‘log-2016.02.03’ index::

  [root@node-1 ~]# curl <VIP>:9200/_cat/indices?v
  health status index                   pri rep docs.count docs.deleted store.size pri.store.size
  green  open   log-2016.02.03            5   0     270405            0     48.7mb         48.7mb
  green  open   log-2016.02.04            5   2    1934581            0        1gb        384.6mb

  [root@node-1 ~]# curl -XPUT  <VIP>:9200/log-2016.02.03/_settings -d '{ "index": { "number_of_replicas": 2 } }'
  {"acknowledged":true}

  [root@node-1 ~]# curl <VIP>:9200/_cat/indices?v
  health status index                   pri rep docs.count docs.deleted store.size pri.store.size
  green  open   log-2016.02.03            5   2     270405            0    146.3mb         48.7mb
  green  open   log-2016.02.04            5   2    1934581            0        1gb        384.6mb

It should be noted that this operation induces a load on the cluster and increases the global store size.

Scale down
----------

After a scale down of the cluster with Fuel UI (eg. removing 2 nodes for a cluster
initialy composed of 3 nodes), the *number_of_replicas* of all indices must be
aligned with the new configuration otherwise the cluster health is degraded::

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


This limitation is tracked in `Launchpad <https://bugs.launchpad.net/lma-toolchain/+bug/1556576>`_,
the operation will be automatically performed in the next release of the plugin.
