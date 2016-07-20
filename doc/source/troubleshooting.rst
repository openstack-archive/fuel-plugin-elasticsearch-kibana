Troubleshooting
===============

If you cannot access the Kibana dashboard or you get no data in the dashboard,
follow these troubleshooting tips.

1. First, check that the StackLight Collector is running properly by following the
   `StackLight Collector troubleshooting instructions
   <http://fuel-plugin-lma-collector.readthedocs.io/>`_.

#. Check that the nodes are able to connect to the Elasticsearch cluster via the VIP address
   on port *9200* as explained in the `Verifying Elasticsearch` section above.

#. On any of the *Elasticsearch_Kibana* role nodes, check the status of the VIP address
   and HAProxy resources in the Pacemaker cluster::

     root@node-1:~# crm resource status vip__es_vip_mgmt
     resource vip__es_vip_mgmt is running on: node-1.test.domain.local

     root@node-1:~# crm resource status p_haproxy
     resource p_haproxy is running on: node-1.test.domain.local

#. If the VIP or HAProxy resources are down, restart them::

     root@node-1:~# crm resource start vip__es_vip_mgmt
     root@node-1:~# crm resource start p_haproxy

#. Check that the Elasticsearch server is up and running::

     # On both CentOS and Ubuntu
     [root@node-1 ~]# /etc/init.d/elasticsearch-es-01 status

#. If Elasticsearch is down, restart it::

     # On both CentOS and Ubuntu
     [root@node-1 ~]# /etc/init.d/elasticsearch-es-01 start

#. Check the apache is up and running::

    # On both CentOS and Ubuntu
    [root@node-1 ~]# /etc/init.d/apache2 status

#. If apache is down, restart it::

    # On both CentOS and Ubuntu
    [root@node-1 ~]# /etc/init.d/apache2 start

#. Look for errors in the Elasticsearch log files (located at /var/log/elasticsearch/es-01/).

#. Look for errors in the apache log files (located at /var/log/apache2/).
