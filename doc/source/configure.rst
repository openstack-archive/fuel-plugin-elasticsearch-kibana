.. _plugin_configuration:

Configure the plugin during an environment deployment
=====================================================

To configure the StackLight Elasticsearch-Kibana plugin during an environment
deployment:

#. Using the Fuel web UI,
   `create a new environment <http://docs.openstack.org/developer/fuel-docs/userdocs/fuel-user-guide/create-environment/start-create-env.html>`_.

#. In the Fuel web UI, click the :guilabel:`Settings` tab and select the
   :guilabel:`Other` category.

#. Scroll down through the settings to find the
   :guilabel:`StackLight Elasticsearch-Kibana Plugin` section.

#. Select :guilabel:`StackLight Infrastructure Alerting Plugin` and fill in
   the required fields as follows:

   .. image:: ../images/elastic_kibana_settings.png
      :width: 800
      :align: center

   #. Specify the number of days to retain your data.
   #. Specify the :guilabel:`JVM heap size` for Elastisearch. Use the tips
      below:

      * By default, 1 GB of heap memory is allocated to the Elasticsearch
        process. This value is enough to run Elasticsearch for local testing
        only.
      * To run Elasticsearch in production, allocate minimum 4 GB of memory.
        But we recommend allocating 50% of the available memory up to 32 GB
        maximum.
      * If you set a value greater than the memory size, Elasticsearch will
        not start.
      * Reserve enough memory for operating system and other services.

   #. Select and edit :guilabel:`Advanced settings` if Elasticsearch and
      Kibana are installed on a cluster of nodes.

#. Select :guilabel:`Enable TLS for Kibana` if you want to encrypt your
   Kibana credentials (username, password). Then, fill in the required fields
   as follows:

   .. image:: ../images/tls_settings.png
      :width: 800
      :align: center

   #. Specify the DNS name of the Kibana server. This parameter is used
      to create a link in the Fuel dashboard to the Kibana server.
   #. Specify the location of a PEM file that contains the certificate
      and the private key of the Kibana server that will be used in TLS handchecks
      with the client.

#. If you want to authenticate through LDAP to Kibana, select
   :guilabel:`Use LDAP for Kibana authentication`. Then, fill in the required
   fields as follows:

   .. image:: ../images/ldap_auth.png
      :width: 800
      :align: center

   #. Select :guilabel:`LDAPS` if you want to enable LDAP authentication
      over SSL.
   #. Specify one or several :guilabel:`LDAP servers` addresses separated by
      space. Those addresses must be accessible from the node where Kibana
      is installed.
      The addresses that are external to the *management network* are not
      routable by default (see more details in step 7).
   #. Specify the LDAP server :guilabel:`Port` number or leave it empty to
      use the defaults.
   #. Specify the :guilabel:`Bind DN` of a user who has search privileges on
      the LDAP server.
   #. Specify the password of the user identified by the :guilabel:`Bind DN`
      selected in the above field.
   #. Specify the :guilabel:`User search base DN` in the Directory
      Information Tree (DIT) from where to search for users.
   #. Specify a valid attribute to search for users, for example, ``uid``.
      The search should return a unique user entry.
   #. Specify a valid search filter to search for users, for example,
      ``(objectClass=*)``

   You can further restrict access to Kibana to those users who
   are members of a specific LDAP group:

   #. Select :guilabel:`Enable group-based authorization`.
   #. Specify the :guilabel:`LDAP attribute` in the user entry that identifies
      the LDAP group membership, for example, ``memberUid``.
   #. Specify the DN of the LDAP group that will be mapped to the *admin role*.
   #. Specify the DN of the LDAP group that will be mapped to the *viewer role*.

   Users who have the *admin role* can modify the Kibana dashboards
   or create new ones. Users who have the *viewer role* can only
   view the Kibana dashboards.

#. In the Fuel web UI,
   `configure your environment <http://docs.openstack.org/developer/fuel-docs/userdocs/fuel-user-guide/configure-environment.html>`_.

   .. caution:: By default, StackLight is configured to use the
      *management network* of the so-called
      `Default Node Network Group <http://docs.openstack.org/developer/fuel-docs/userdocs/fuel-user-guide/configure-environment/network-settings.html>`_.
      While this default setup may be appropriate for small deployments or
      evaluation purposes, we recommend not to use this network
      for StackLight in production. Instead, create a network
      dedicated to StackLight to improve performance and reduce the monitoring
      footprint. It will also facilitate access to the Kibana UI after
      deployment.

#. Click the :guilabel:`Nodes` tab and assign the *Elasticsearch_Kibana* role
   to the node(s) where you want to install the plugin.

   The example below shows that the *Elasticsearch_Kibana* role is assigned
   to three nodes alongside with the *Alerting_Infrastructure* and the
   *InfluxDB_Grafana* roles. The three plugins of the LMA toolchain back-end
   servers are installed on the same nodes.

   .. image:: ../images/elastic_kibana_role.png
      :width: 800
      :align: center

   .. note:: The Elasticsearch clustering for high availability requires
      that you assign the *Elasticsearch_Kibana* role to at least three nodes,
      but you can assign the *Elasticsearch_Kibana* role up to five nodes.
      You can also add or remove a node with the *Elasticsearch_Kibana*
      role after deployment.

#. If required, `adjust the disk partitioning <http://docs.openstack.org/developer/fuel-docs/userdocs/fuel-user-guide/configure-environment/customize-partitions.html>`_.

   By default, the Elasticsearch-Kibana plugin allocates:

   * 20% of the first available disk for the operating system by honoring
     a range of 15 GB minimum and 50 GB maximum.
   * 10 GB for ``/var/log``.
   * At least 30 GB for the Elasticsearch database in ``/opt/es-data``.

10. `Deploy your environment
    <http://docs.openstack.org/developer/fuel-docs/userdocs/fuel-user-guide/deploy-environment.html>`_.

.. raw:: latex

   \pagebreak
