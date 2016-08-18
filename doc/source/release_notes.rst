.. _releases:

Release notes
=============

Version 0.10.1
--------------

* Bug fixes:

  * Support wildcard SSL certificates. See
    `#1608665 <https://bugs.launchpad.net/lma-toolchain/+bug/1608665>`_.

  * Fix UI issue with the LDAP protocol radio button. See
    `#1599778 <https://bugs.launchpad.net/lma-toolchain/+bug/1599778>`_.


Version 0.10.0
--------------

The StackLight Elasticsearch-Kibana plugin 0.10.0 contains the following
updates:

* Added support for the LDAP(S) authentication to access the Kibana UI.
* Added support for the TLS encryption to access the Kibana UI.

  To configure the TLS termination, update the plugin settings with a PEM
  file obtained by concatenating the SSL certificate with the private key.

* Upgraded to Elasticsearch v2.3.3.
* Upgraded to Kibana v4.5.
* Fixed the issue in logs and notifications being dropped during a long
  Elasticsearch outage. See
  `#1566748 <https://bugs.launchpad.net/lma-toolchain/+bug/1566748>`_.

Version 0.9.0
-------------

The StackLight Elasticsearch-Kibana plugin 0.9.0 contains the following
updates:

* Added support for Elasticsearch and Kibana clustering for scale-out and
  high availability of those services.
* Upgraded to Elasticsearch 1.7.4.
* Upgraded to Kibana 3.1.3.

Version 0.8.0
-------------

The StackLight Elasticsearch-Kibana plugin 0.8.0 contains the following
updates:

* Added support for the ``elasticsearch_kibana`` Fuel plugin role instead of
  the ``base-os`` role which had several limitations.
* Added support for the retention policy configuration with
  `Elastic Curator <https://github.com/elastic/curator>`_.
* Upgraded to Elasticsearch 1.4.5.

Version 0.7.0
-------------

The initial release of the plugin (beta version).

.. raw:: latex

   \pagebreak
