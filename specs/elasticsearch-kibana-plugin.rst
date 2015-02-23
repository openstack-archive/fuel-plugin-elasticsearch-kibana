..
 This work is licensed under a Creative Commons Attribution 3.0 Unported
 License.

 http://creativecommons.org/licenses/by/3.0/legalcode

===============================================
Fuel plugin to install Elasticsearch and Kibana
===============================================

https://blueprints.launchpad.net/fuel/+spec/elasticsearch-kibana-plugin

Elasticsearch [#]_ is an open source full-text search engine that allows
real-time search. To be able to also visualize data this plugin will
also provide Kibana [#]_ that is the natural choice as the visualization
platform for Elasticsearch.

Problem description
===================

With fuel come many other tools. When an error or if the behavior of our
deployed environment is modified we want to be able to explore data to
investigate the problem. Current solutions are either to search into the logs
panel of the fuel's dashboard or log directly onto fuel and directly look
into the log.

Proposed change
===============

We will provide a set of tools that will improve the way we can explore and
visualize data. To be useful this solution should be coupled to another one
that will feed the database of search engine. One candidate is the LMA [#]_
collector that is provided by the LMA collector plugin.

Alternatives
------------

???

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

Elasticsearch is based on Lucene and is written in Java. That means that
it is running on a JVM. Depending of the collector you are using the database
will probably consume disk space. So it is probably to dedicate a particular
node for this plugin.

Other deployer impact
---------------------

To be useful the search engine needs to be feed. It can be achieved by other
fuel plugins or an ad hoc solution

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
