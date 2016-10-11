.. _network_templates:

Deploy an OpenStack environment using networking templates
==========================================================

By default, the Elasticsearch-Kibana cluster will be deployed on the Fuel
management network. If this default configuration does not meet your
requirements, you can leverage the Fuel
`networking templates' <http://docs.openstack.org/developer/fuel-docs/userdocs/fuel-user-guide/configure-environment/network-templates.html>`_
capability to change that default configuration and use a dedicated network
instead.

Below is a networking template example to define a new network named
``monitoring``. You can use this configuration example as a starting point
and adapt it to your requirements.

.. literalinclude:: ./network_template.yaml

**To deploy an environment using networking templates:**

#. Upload the networking template:

   .. code-block:: console

    $ fuel2 network-template upload -f ./network_template <ENVIRONMENT_ID>

#. Allocate an IP subnet for the ``monitoring`` network:

   .. code-block:: console

    $ fuel2 network-group create -N <ENVIRONMENT_ID> -C 10.109.5.0/24 monitoring

#. Optional. Using the Fuel web UI, adjust the IP range:

   .. image:: ../images/network_group_configuration.png
      :width: 800
      :align: center

#. Proceed to :ref:`Configure the plugin <plugin_configuration>`.

For details on networking templates, see the
`Fuel User Guide <http://docs.openstack.org/developer/fuel-docs/userdocs/fuel-user-guide/configure-environment/network-templates.html>`_.

.. raw:: latex

   \pagebreak