.. _user_installation:

Installation Guide
==================

StackLight Elasticsearch-Kibana Plugin installation using the RPM file of the Fuel Plugins Catalog
--------------------------------------------------------------------------------------------------

To install the StackLight Elasticsearch-Kibana Fuel Plugin using the RPM file of the Fuel Plugins
Catalog, you need to follow these steps:


1. Select, using the MONITORING category and Mirantis OpenStack version you are using,
   the RPM file you want to download from the `Fuel Plugins Catalog
   <https://www.mirantis.com/validated-solution-integrations/fuel-plugins>`_.

2. Copy the RPM file to the Fuel Master node::

    [root@home ~]# scp elasticsearch_kibana-0.10-0.10.0-0.noarch.rpm \
    root@<Fuel Master node IP address>:

3. Install the plugin using the `Fuel CLI
   <http://docs.mirantis.com/openstack/fuel/fuel-8.0/user-guide.html#using-fuel-cli>`_::

    [root@fuel ~]# fuel plugins --install elasticsearch_kibana-0.10-0.10.0-0.noarch.rpm

4. Verify that the plugin is installed correctly::

    [root@fuel ~]# fuel plugins --list
    id | name                 | version  | package_version
    ---|----------------------|----------|----------------
    1  | elasticsearch_kibana | 0.10.0   | 4.0.0

StackLight Elasticsearch-Kibana Fuel Plugin installation from source
--------------------------------------------------------------------

Alternatively, you may want to build the RPM file of the plugin from source if,
for example, you want to test the latest features of the master branch or customize the plugin.

.. note:: Be aware that running a Fuel plugin that you built yourself is at your
   own risk and will not be supported.

To install StacLight Elasticsearch-Kibana Plugin from source,
you first need to prepare an environment to build the RPM file.
The recommended approach is to build the RPM file directly onto the Fuel Master
node so that you won't have to copy that file later on.

**Prepare an environment for building the plugin on the Fuel Master Node**

1. Install the standard Linux development tools::

    [root@home ~] yum install createrepo rpm rpm-build dpkg-devel

2. Install the Fuel Plugin Builder. To do that, you should first get pip::

    [root@home ~] easy_install pip

3. Then install the Fuel Plugin Builder (the `fpb` command line) with `pip`::

    [root@home ~] pip install fuel-plugin-builder

.. note::  You may also need to build the Fuel Plugin Builder if the package version of the
   plugin is higher than the package version supported by the Fuel Plugin Builder you get from `pypi`.
   In this case, please refer to the section "Preparing an environment for plugin development"
   of the `Fuel Plugins wiki <https://wiki.openstack.org/wiki/Fuel/Plugins>`_,
   if you need further instructions about how to build the Fuel Plugin Builder.

4. Clone the plugin git repository::

    [root@home ~] git clone \
      https://github.com/openstack/fuel-plugin-elasticsearch-kibana.git

5. Check that the plugin is valid::

    [root@home ~] fpb --check ./fuel-plugin-elasticsearch-kibana

6.  And finally, build the plugin::

    [root@home ~] fpb --build ./fuel-plugin-elasticsearch-kibana

7. Now that you have created the RPM file, you can install the plugin using the `fuel plugins --install` command::

    [root@fuel ~] fuel plugins --install \
      ./fuel-plugin-elasticsearch-kibana/*.noarch.rpm


StackLight Elasticsearch-Kibana Fuel Plugin software components
---------------------------------------------------------------

List of software components installed by the plugin

+---------------+--------------------------------------------------------+
| Components    | Version                                                |
+===============+========================================================+
| Elasticsearch | v2.3.3 for Ubuntu (64-bit)                             |
+---------------+--------------------------------------------------------+
| Kibana        | v4.5                                                   |
+---------------+--------------------------------------------------------+
| Apache        | Version coming by default with the Ubuntu distribution |
+---------------+--------------------------------------------------------+
