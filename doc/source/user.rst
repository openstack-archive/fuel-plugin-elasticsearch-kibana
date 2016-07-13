.. _user_guide:

User Guide
==========

.. _plugin_configuration:

Plugin configuration
--------------------

To configure the **StackLight Elasticsearch-Kibana Plugin**, you need to follow these steps:

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

.. _plugin_install_verification:

Plugin verification
-------------------

Be aware, that depending on the number of nodes and deployment setup,
deploying a Mirantis OpenStack environment can typically take anything
from 20 minutes to several hours. But once your deployment is complete,
you should see a deployment success notification message with two
links to Kibana as shown in the figure below:

.. image:: ../images/deploy_notif.png
   :align: center
   :width: 800

.. note:: For technical reasons, it was necessary to create two different ports
   to enforce the access authorization to Kibana. One port (80) for users with the
   *admin role* and one port (81) for users with the *viewer role*.
   Be also aware that if Kibana is installed on the *management network*,
   you may not have direct access to the UI. Some extra network
   configuration may be required to create an SSH tunnel to the *management network*.

Verifying Elasticsearch
~~~~~~~~~~~~~~~~~~~~~~~

You should verify that the Elasticsearch cluster is running properly.
To do that, you need first to retrieve the Elasticsearch cluster VIP address.
Here is how to proceed.

#. On the Fuel Master node, find the IP address of a node where the Elasticsearch
   server is installed using the following command::

    [root@fuel ~]# fuel nodes
    id | status   | name             | cluster | ip  | mac | roles                |
    ---|----------|------------------|---------|-----|----------------------------|
    1  | ready    | Untitled (fa:87) | 1       | ... | ... | elasticsearch_kibana |
    2  | ready    | Untitled (12:aa) | 1       | ... | ... | elasticsearch_kibana |
    3  | ready    | Untitled (4e:6e) | 1       | ... | ... | elasticsearch_kibana |


#. Then `ssh` to anyone of these nodes (ex. *node-1*) and type the command::

    root@node-1:~# hiera lma::elasticsearch::vip
    10.109.1.5

   This tells you that the VIP address of your Elasticsearch cluster is *10.109.1.5*.

#. With that VIP address type the command::

     curl http://10.109.1.5:9200/

   The output should look like this::

    {
      "status" : 200,
      "name" : "node-3.test.domain.local_es-01",
      "cluster_name" : "lma",
      "version" : {
        "number" : "1.7.4",
        "build_hash" : "0d3159b9fc8bc8e367c5c40c09c2a57c0032b32e",
        "build_timestamp" : "2015-12-15T11:25:18Z",
        "build_snapshot" : false,
        "lucene_version" : "4.10.4"
      },
      "tagline" : "You Know, for Search"
    }

Verifying Kibana
~~~~~~~~~~~~~~~~

From the Fuel dashboard, click on the *Kibana (Admin role)* link
(or enter the IP address and port number if your DNS is not setup),
then enter your credentials. You should be redirected to a Kibana 4
**Logs Anaytics Dashboard** as shown in the figure below.

.. image:: ../images/kibana_logs_dash.png
   :align: center
   :width: 800

Dashboards management
---------------------

The StackLight Elasticsearch-Kibana Plugin comes with two built-in dashboards:

  * The Logs Analytics Dashboard that is used to visualize and search the logs.
  * The Notifications Analytics Dashboard that is used to visualize and
    search the OpenStack notifications if you enabled the feature in the
    Collector settings.

You can switch from one dashboard to another by clicking on the top-right *Load*
icon in the toolbar to select the requested dashboard from the list, as shown below.

.. image:: ../images/kibana_dash.png
   :align: center
   :width: 800

Each dashboard provides a single pane of glass for visualizing and searching
all the logs and the notifications of your OpenStack environment.
Note that in the Collector settings it is possible to tag the logs by
environment name so that you can distinguish which logs (and notifications)
belong to what environment.

As you can see, the Kibana dashboard for logs is divided in several sections:

.. image:: ../images/kibana_logs_sections_1.png
   :align: center
   :width: 800

1. A time-picker control that lets you choose the time period you want
   to select and refresh frequency.

2. A text-box to enter search queries.

3. Various logs analytics with six different panels:

  a. A stack graph showing all the logs per source.
  b. A stack graph showing all the logs per severity.
  c. A stack graph showing all logs top 10 sources.
  d. A stack graph showing all the logs top 10 programs.
  e. A stack graph showing all logs top 10 hosts.
  f. A graph showing the number of logs per severity.
  g. A graph showing the number of logs per role.

4. A table of log messages sorted in reverse chronological order.

.. image:: ../images/kibana_logs_sections_2.png
  :align: center
  :width: 800

Filters and queries
-------------------

Filters and queries have similar syntax but they are used for different purposes.

  * The filters are used to restrict what is displayed in the dashboard.
  * The queries are used for free-text search.

You can also combine multiple queries and compare their results.
To further filter the log messages to, for example, select the *deployment_id*,
you need to expand a log entry and then select the *deployment_id* field
by clicking on the magnifying glass icon as shown below.

.. image:: ../images/kibana_logs_filter1.png
   :align: center
   :width: 800

This will apply a new filter in the dashboard.

.. image:: ../images/kibana_logs_filter2.png
   :align: center
   :width: 800

Filtering will work for any field that has been indexed for the log entries that
are in the dashboard.

Filters and queries can also use wildcards that can be combined with *field names* like in::

    programname: <name>*

For example, to display only the Nova logs you could enter::

    programname:nova*

in the query textbox as shown below.

.. image:: ../images/kibana_logs_query1.png
   :align: center
   :width: 800

Troubleshooting
---------------

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
