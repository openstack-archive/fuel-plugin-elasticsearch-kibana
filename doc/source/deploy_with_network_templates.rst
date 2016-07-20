.. _network_templates:

Deploy an OpenStack environment using network templates
=======================================================

By default, the Elasticsearch-Kibana cluster will be deployed on the Fuel management
network. If this default configuration does not meet your requirements, you can leverage the
Fuel `network templates
<https://docs.mirantis.com/openstack/fuel/fuel-8.0/operations.html#using-networking-templates>`_
capability to change that default configuration to use a dedicated network instead.

Below is a network template example to define a new network named `monitoring`.

.. literalinclude:: ./network_template.yaml

You can use this configuration example as a starting point and adapt it to your requirements.

The deployment of the environment should work as described in the
:ref:`configuration section <plugin_configuration>`. But before deploying an
environment, complete the following steps:

#. Upload the network template::

    $ fuel2 network-template upload -f ./network_template <ENVIRONMENT_ID>

#. Allocate an IP subnet for the `monitoring` network::

    $ fuel2 network-group create -N <ENVIRONMENT_ID> -C 10.109.5.0/24 monitoring

#. Adjust the IP range through the Fuel user interface (optional).

   .. image:: ../images/network_group_configuration.png
      :width: 800
      :align: center

#. Deploy the environment.

For more details, refer to the official `Fuel documentation
<https://docs.mirantis.com/openstack/fuel/fuel-8.0/operations.html#using-networking-templates>`_.
