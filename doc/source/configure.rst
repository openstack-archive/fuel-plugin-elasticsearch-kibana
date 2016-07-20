.. _plugin_configuration:

Configure an OpenStack environment with the plugin
==================================================

To configure the StackLight Elasticsearch-Kibana plugin during an environment
deployment, complete the following steps:

1. `Create a new environment
   <http://docs.openstack.org/developer/fuel-docs/userdocs/fuel-user-guide/create-environment/start-create-env.html>`_.

2. Click on the *Settings* tab of the Fuel web UI and select the *Other* category.

3. Scroll down through the settings until you find the *StackLight Elasticsearch-Kibana
   Plugin* section.

4. Tick the *StackLight Infrastructure Alerting Plugin* box and fill-in the required
   fields as indicated below.

   .. image:: ../images/elastic_kibana_settings.png
      :width: 800
      :align: center

   a. Specify the number of days of retention for your data.
   #. Specify the JVM heap size for Elastisearch. See the configuration recommendations below.

      .. note:: By default, 1GB of heap memory is allocated to the Elasticsearch process.
         This value is too small to run Elasticsearch for anything else than local testing.
         To run Elasticsearch in production you need to allocate at least 4 GB of memory
         but it is recommended to allocate 50% of the available memory up to 32 GB maximum.
         If you set a value that is greater than the memory size, Elasticsearch won't start.
         Keep in mind also to reserve enough memory for the operating system and the other services.

   #. At this point, you can choose to either edit the *Advanced settings* or let the plugin
      decide the defaults for you. The advanced settings are used to specify advanced settings
      when Elasticsearch and Kibana are installed on a cluster of nodes.
      To manually configure those advanced settings, check the *Advanced settings* box and fill-in
      the required parameters.

5. Tick the *Enable TLS for Kibana* box if you want to encrypt your
   Kibana credentials (username, password). Then, fill-in the required
   fields as indicated below.

   .. image:: ../images/tls_settings.png
      :width: 800
      :align: center

   a. Specify the DNS name of the Kibana server. This parameter is used
      to create a link in the Fuel dashboard to the Kibana server.
   #. Specify the location of a PEM file that contains the certificate
      and the private key of the Kibana server that will be used in TLS handchecks
      with the client.

6. Tick the *Use LDAP for Kibana Authentication* box if you want to authenticate
   via LDAP to Kibana. Then, fill-in the required fields as indicated below.

   .. image:: ../images/ldap_auth.png
      :width: 800
      :align: center

   a. Select the *LDAPS* button if you want to enable LDAP authentication
      over SSL.
   #. Specify one or several LDAP server addresses separated by a space. Those
      addresses must be accessible from the node where Kibana is installed.
      Note that addresses external to the *management network* are not routable
      by default (see the note below).
   #. Specify the LDAP server port number or leave it empty to use the defaults.
   #. Specify the *Bind DN* of a user who has search priviliges on the LDAP server.
   #. Specify the password of the user identified by the *Bind DN* above.
   #. Specify the *Base DN* in the Directory Information Tree (DIT) from where
      to search for users.
   #. Specify a valid attribute (ex. 'uid') to search for users. The search should
      return a unique user entry.
   #. Specify a valid search filter (ex. '(objectClass=*') to search for users.

   You can further restrict access to Kibana to those users who
   are member of a specific LDAP group.

   a. Tick the *Enable group-based authorization*.
   #. Specify the LDAP attribute (ex. memberUid) in the user entry
      that identifies the LDAP group membership.
   #. Specify the DN of the LDAP group that will be mapped to the *admin role*
   #. Specify the DN of the LDAP group that will be mapped to the *viewer role*

   Users who have the *admin role* can modify the Kibana dashboards
   or create new ones. Users who have the *Viewer role* can only
   visualise the Kibana dashboards.

7. `Configure your environment
   <http://docs.openstack.org/developer/fuel-docs/userdocs/fuel-user-guide/configure-environment.html>`_.

   .. note:: By default, StackLight is configured to use the *management network*,
      of the so-called `Default Node Network Group
      <http://docs.openstack.org/developer/fuel-docs/userdocs/fuel-user-guide/configure-environment/network-settings.html>`_.
      While this default setup may be appropriate for small deployments or
      evaluation purposes, it is recommended not to use this network
      for StackLight in production. It is instead recommended to create a network
      dedicated to StackLight. Using a dedicated network for StackLight should
      improve performances and reduce the monitoring footprint.
      It will also facilitate access to the Kibana UI after deployment.

8. Click the *Nodes* tab and assign the *Elasticsearch_Kibana* role
   to the node(s) where you want to install the plugin.

   You can see in the example below that the *Elasticsearch_Kibana*
   role is assigned to three nodes along side with the
   *Alerting_Infrastructure* and the *InfluxDB_Grafana* roles.
   Here, the three plugins of the LMA toolchain backend servers are
   installed on the same nodes.

   .. image:: ../images/elastic_kibana_role.png
      :width: 800
      :align: center

   .. note:: The Elasticsearch clustering for high availability requires
      that you assign the *Elasticsearch_Kibana* role to at least three nodes,
      but you can assign the *Elasticsearch_Kibana* role up to five nodes.
      Note also that is possible to add or remove a node with the *Elasticsearch_Kibana*
      role after deployment.

9. `Adjust the disk partitioning if necessary
   <http://docs.openstack.org/developer/fuel-docs/userdocs/fuel-user-guide/configure-environment/customize-partitions.html>`_.

   By default, the Elasticsearch-Kibana Plugin allocates:

     * 20% of the first available disk for the operating system by honoring a range of 15GB minimum and 50GB maximum.
     * 10GB for */var/log*.
     * At least 30 GB for the Elasticsearch database in */opt/es-data*.

10. `Deploy your environment
    <http://docs.openstack.org/developer/fuel-docs/userdocs/fuel-user-guide/deploy-environment.html>`_.
