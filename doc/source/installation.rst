.. _user_installation:

Installation Guide
==================

Elasticsearch-Kibana Fuel Plugin install using the RPM file
-----------------------------------------------------------

To install the Elasticsearch-Kibana Fuel Plugin using the RPM file
of the plugin, follow these steps:

1. Download the RPM file from the `Fuel Plugins Catalog <https://software.mirantis.com/download-mirantis-openstack-fuel-plug-ins/>`_.

2. Copy the RPM file to the Fuel Master node::

    [root@home ~]# scp elasticsearch_kibana-0.8-0.8.0-0.noarch.rpm root@<Fuel Master node IP address>:

3. Install the plugin using the `Fuel CLI <http://docs.mirantis.com/openstack/fuel/fuel-7.0/user-guide.html#using-fuel-cli>`_::

    [root@fuel ~]# fuel plugins --install elasticsearch_kibana-0.8-0.8.0-0.noarch.rpm 

4. Verify that the plugin is installed correctly::

    [root@fuel ~]# fuel plugins --list
    id | name                 | version | package_version
    ---|----------------------|---------|----------------
    1  | elasticsearch_kibana | 0.8.0   | 3.0.0


Elasticsearch-Kibana Fuel Plugin install from source 
----------------------------------------------------

Alternatively, you may want to build the RPM file of the plugin yourself if,
for example, you want to modify some configuration elements. But note that this
is at your own risk.

To install Elasticsearch-Kibana Plugin from source, you first need to prepare an
environement to build the RPM file of the plugin.
The recommended approach is to build the RPM file directly onto the Fuel Master
node so that you won't have to copy that file later.

**Prepare an environment for building the plugin on the Fuel Master Node**

1. Install the standard Linux development tools::

    [root@home ~] yum install createrepo rpm rpm-build dpkg-devel

2. Install the Fuel Plugin Builder. To do that, you should first get pip::

    [root@home ~] easy_install pip

3. Then install the Fuel Plugin Builder (the `fpb` command line) with `pip`::

    [root@home ~] pip install fuel-plugin-builder

*Note*: You may also need to build the Fuel Plugin Builder if the package version of the
plugin is higher than package version supported by the Fuel Plugin Builder you get from `pypi`.
In this case, please refer to the section "Preparing an environment for plugin development"
of the `Fuel Plugins wiki <https://wiki.openstack.org/wiki/Fuel/Plugins>`_
if you need further instructions about how to build the Fuel Plugin Builder.

4. Clone the plugin git repository::

    [root@home ~] git clone git@github.com:stackforge/fuel-plugin-elasticsearch-kibana.git 

5. Check that the plugin is valid::

    [root@home ~] fpb --check ./fuel-plugin-elasticsearch-kibana

6.  And finally, build the plugin::

    [root@home ~] fpb --build ./fuel-plugin-elasticsearch-kibana

7. Now that you have created the RPM file, you can install the plugin using the `fuel plugins --install` command::

    [root@home ~]# ls -l fuel-plugin-elasticsearch-kibana/elasticsearch_kibana-0.8-0.8.0-1.noarch.rpm
    -rw-r--r-- 1 root root 68582944  5 oct.  16:59 fuel-plugin-elasticsearch-kibana/elasticsearch_kibana-0.8-0.8.0-1.noarch.rpm

