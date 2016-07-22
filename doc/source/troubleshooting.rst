Troubleshooting
===============

If you cannot access the Kibana Dashboard or you get no data in the Dashboard,
use the following troubleshooting tips:

#. Verify that the StackLight Collector is running properly. For details, see
   the `StackLight Collector <http://fuel-plugin-lma-collector.readthedocs.io/>`_
   troubleshooting instructions.

#. Verify that the nodes can connect to the Elasticsearch cluster
   through the virtual IP address on port ``9200`` as described in the
   :ref:`verify-elastic` section.

#. On any of the *Elasticsearch_Kibana* role nodes, check the status of the
   virtual IP address and HAProxy resources on the Pacemaker cluster:

   .. code-block:: console

     root@node-1:~# crm resource status vip__es_vip_mgmt
     resource vip__es_vip_mgmt is running on: node-1.test.domain.local

     root@node-1:~# crm resource status p_haproxy
     resource p_haproxy is running on: node-1.test.domain.local

#. If the virtual IP or HAProxy resources are down, restart them:

   .. code-block:: console

     root@node-1:~# crm resource start vip__es_vip_mgmt
     root@node-1:~# crm resource start p_haproxy

#. Verify that the Elasticsearch server is up and running on both CentOS and
   Ubuntu:

   .. code-block:: console

     [root@node-1 ~]# /etc/init.d/elasticsearch-es-01 status

   If Elasticsearch is down, restart it on both CentOS and Ubuntu:

   .. code-block:: console

     [root@node-1 ~]# /etc/init.d/elasticsearch-es-01 start

#. Verify that Apache is up and running on both CentOS and Ubuntu:

   .. code-block:: console

    [root@node-1 ~]# /etc/init.d/apache2 status

   If Apache is down, restart it on both CentOS and Ubuntu:

   .. code-block:: console

    [root@node-1 ~]# /etc/init.d/apache2 start

#. Look for errors in the Elasticsearch log files located at
   ``/var/log/elasticsearch/es-01/``.

#. Look for errors in the Apache log files located at ``/var/log/apache2/``.

.. raw:: latex

   \pagebreak
