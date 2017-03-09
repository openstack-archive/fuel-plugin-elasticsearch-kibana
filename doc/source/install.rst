.. _install:

Install the plugin
==================

Introduction
------------

You can install the StackLight Elasticsearch-Kibana Fuel plugin using one of
the following options:

* Install using the RPM file
* Install from source

The following is a list of software components installed by the StackLight
Elasticsearch-Kibana Fuel plugin:

+---------------+---------------------------------------------+
| Components    | Version                                     |
+===============+=============================================+
| Elasticsearch | v2.3.3 for Ubuntu (64-bit)                  |
+---------------+---------------------------------------------+
| Kibana        | v4.5                                        |
+---------------+---------------------------------------------+
| Apache        | Version coming with the Ubuntu distribution |
+---------------+---------------------------------------------+

Install using the RPM file
--------------------------

To install the StackLight Elasticsearch-Kibana Fuel plugin using the RPM file
from the Fuel plugins' catalog:

#. Go to the
   `Fuel plugins' catalog <https://www.mirantis.com/validated-solution-integrations/fuel-plugins>`_.

#. From the :guilabel:`Filter` drop-down menu, select the Mirantis OpenStack
   version you are using and the :guilabel:`MONITORING` category.

#. Download the RPM file.

#. Copy the RPM file to the Fuel Master node:

   .. code-block:: console

    [root@home ~]# scp elasticsearch_kibana-1.1-1.1.0-0.noarch.rpm \
    root@<Fuel Master node IP address>:

#. Install the plugin using the `Fuel Plugins CLI
   <http://docs.openstack.org/developer/fuel-docs/userdocs/fuel-user-guide/cli/cli_plugins.html>`_:

   .. code-block:: console

    [root@fuel ~]# fuel plugins --install elasticsearch_kibana-1.1-1.1.0-0.noarch.rpm

#. Verify that the plugin is installed correctly:

   .. code-block:: console

    [root@fuel ~]# fuel plugins --list
    id | name                 | version  | package_version
    ---|----------------------|----------|----------------
    1  | elasticsearch_kibana | 1.1.0   | 4.0.0


Install from source
-------------------

Alternatively, you can build the RPM file of the plugin from source if, for
example, you want to test the latest features of the master branch or
customize the plugin.

.. caution:: Running a Fuel plugin that you built from source is at your
   own risk and is not supported.

Before you install the StackLight Elasticsearch-Kibana plugin from source,
prepare an environment to build the RPM file. We recommend building the RPM
file directly on the Fuel Master node not to copy that file later on.

**To prepare an environment for building the plugin on the Fuel Master node:**

#. Install the standard Linux development tools:

   .. code-block:: console

    [root@home ~] yum install createrepo rpm rpm-build dpkg-devel

#. Install ``pip``:

   .. code-block:: console

    [root@home ~] easy_install pip

#. Install the Fuel Plugin Builder (the ``fpb`` command line) using ``pip``:

   .. code-block:: console

    [root@home ~] pip install fuel-plugin-builder

   .. note:: You may also need to build the Fuel Plugin Builder if the
    package version of the plugin is higher than the package version supported
    by the Fuel Plugin Builder you get from ``pypi``. For instructions on how
    to build the Fuel Plugin Builder, see the
    `Fuel Plugin SDK Guide <http://docs.openstack.org/developer/fuel-docs/plugindocs/fuel-plugin-sdk-guide/create-plugin/install-plugin-builder.html>`_.

#. Clone the plugin repository:

   .. code-block:: console

    [root@home ~] git clone \
      https://github.com/openstack/fuel-plugin-elasticsearch-kibana.git

#. Verify that the plugin is valid:

   .. code-block:: console

    [root@home ~] fpb --check ./fuel-plugin-elasticsearch-kibana

#.  Build the plugin:

   .. code-block:: console

    [root@home ~] fpb --build ./fuel-plugin-elasticsearch-kibana

**To install the plugin:**

#. Once you have created the RPM file, install the plugin:

   .. code-block:: console

    [root@fuel ~] fuel plugins --install \
      ./fuel-plugin-elasticsearch-kibana/*.noarch.rpm

#. Verify that the plugin is installed correctly:

   .. code-block:: console

    [root@fuel ~]# fuel plugins --list
    id | name                 | version | package_version
    ---|----------------------|---------|----------------
    1  | elasticsearch_kibana | 1.1.0   | 4.0.0

.. raw:: latex

   \pagebreak
