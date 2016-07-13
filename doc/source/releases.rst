.. _releases:

Release Notes
=============

Version 0.10.0
--------------

* Changes

  * Add supprt for LDAP(S) authentication to access the Kibana UI.
  * Add Support for TLS encryption to access the Kibana UI.
    A PEM file (obtained by concatenating the SSL certificate with the private key)
    must be provided in the settings of the plugin to configure the TLS termination.
  * Upgrade to Elasticsearch v2.3.3
  * Upgrade to Kibana v4.5

* Bug Fixes

  * Logs and notifications are dropped during a "long" Elasticsearch outage (`#1566748
    <https://bugs.launchpad.net/lma-toolchain/+bug/1566748>`_).

Version 0.9.0
-------------

* Support Elasticsearch and Kibana clustering for scale-out and high
  availability of those services.

* Upgrade to Elasticsearch 1.7.4.

* Upgrade to Kibana 3.1.3.

Version 0.8.0
-------------

* Add support for the "elasticsearch_kibana" Fuel Plugin role instead of
  the "base-os" role which had several limitations.

* Add support for retention policy configuration with `Elastic Curator <https://github.com/elastic/curator>`_.

* Upgrade to Elasticsearch 1.4.5.

Version 0.7.0
-------------

* Initial release of the plugin. This is a beta version.
