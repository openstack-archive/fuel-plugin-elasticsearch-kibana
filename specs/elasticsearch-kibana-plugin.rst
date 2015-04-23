..
 This work is licensed under a Creative Commons Attribution 3.0 Unported
 License.

http://creativecommons.org/licenses/by/3.0/legalcode

===============================================
Fuel plugin to install Elasticsearch and Kibana
===============================================

https://blueprints.launchpad.net/fuel/+spec/elasticsearch-kibana-fuel-plugin

Elasticsearch [#]_ is an open source full-text search engine that allows
real-time search. This plugin will also provide Kibana [#]_, a flexible web
interface for exploring and visualizing the data stored in Elasticsearch.

Problem description
===================

A cloud operator needs a tool to easily search into a large amount of logs
and to visualize them in an efficient way.

Proposed change
===============

We will provide a set of tools that will improve the way we can explore and
visualize data. This solution should be coupled to another one in order to
get data to analyze. One candidate is the Logging, Monitoring and
Alerting collector [#]_ plugin.

Alternatives
------------

* It might have been implemented as the part of Fuel core but we decided to
  make it as a plugin for several reasons:

  - This isn't something that all operators may want to deploy.

  - Any new additional functionality makes the project's testing more difficult,
    which is an additional risk for the Fuel release.

  - Ideally, this effort may be of interest for non-Fuel based deployments, too.

* Search into the logs panel of the Fuel's dashboard.

  - This solution doesn't scale.

  - It offers no capabilites for filtering and searching.

  - It offers no capabilites for statistics.

* Log directly onto Fuel and use a grep like tool.

  - This solution doesn't scale.

  - It offers no capabilites for statistics.

Data model impact
-----------------

None

REST API impact
---------------

None

Upgrade impact
--------------

None

Security impact
---------------

None

Notifications impact
--------------------

None

Other end user impact
---------------------

None

Performance Impact
------------------

The amount of resources (RAM, CPU, disk) required for Elasticsearch depends
on the number of clients but a typical setup would have at least 8GB of RAM
and fast disks (ideally SSD drives). As a consequence, it is highly recommended
to use a dedicated node for deploying the plugin. Good insights are given by
the Elasticsearch guide [#]_.

Other deployer impact
---------------------

To be useful the search engine needs to be feed. It can be achieved by other
Fuel plugins or an ad hoc solution.

Developer impact
----------------

None

Implementation
==============

Assignee(s)
-----------

Primary assignee:
  Guillaume Thouvenin <gthouvenin@mirantis.com> (feature lead, developer)

Other contributors:
  Irina Povolotskaya <ipovolotskaya@mirantis.com> (tech writer)
  Simon Pasquier <spasquier@mirantis.com> (developer)
  Swann Croiset <scroiset@mirantis.com> (developer)


Work Items
----------

* Implement the Elasticsearch Kibana plugin.

* Implement the Puppet manifests.

* Testing.

* Write the documentation.

Dependencies
============

* Fuel 6.1 and higher.

* It will be installed in an empty role [#]_.


Testing
=======

* Prepare a test plan.

* Test the plugin by deploying environments with all Fuel deployment modes.

* Integration tests with LMA collector.

Documentation Impact
====================

* Deployment Guide

* User Guide (what features the plugin provides, how to use them in the
  deployed OpenStack environment).

* Test Plan.

* Test Report.

References
==========

.. [#] http://www.elasticsearch.org/

.. [#] http://www.elasticsearch.org/guide/en/kibana/

.. [#] https://blueprints.launchpad.net/fuel/+spec/lma-collector-plugin

.. [#] http://www.elasticsearch.org/guide/en/elasticsearch/guide/current/hardware.html

.. [#] https://blueprints.launchpad.net/fuel/+spec/blank-role-node
