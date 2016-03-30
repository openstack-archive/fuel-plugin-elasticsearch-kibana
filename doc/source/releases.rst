.. _releases:

Release Notes
=============

Version 0.8.1
-------------

* Bug fixes

  * Fix the cron job running Elastic Curator (`#1535435
    <https://bugs.launchpad.net/lma-toolchain/+bug/1535435>`_).
  * Specify explicitly one data.path for Elasticsearch (`#1559126
    <https://bugs.launchpad.net/lma-toolchain/+bug/1559126>`_):

.. note::

      When upgrading from the previous release *0.8.0* and in order to avoid to
      lost data, manual operations are required:

         * Before upgrading the plugin, perform a manual Elasticsearch snapshot
           (make sure there is enough space on the target repository, the required
           size corresponds to the sum of both directories
           */usr/lib/elasticsearch-* and */opt/es-data/*)
         * After the plugin upgrade perform the snapshot restoration.

      Refer to `#1559126 <https://bugs.launchpad.net/lma-toolchain/+bug/1559126>`_
      for further details.


Version 0.8.0
-------------

* Add support for the "elasticsearch_kibana" Fuel Plugin role instead of
  the "base-os" role which had several limitations.

* Add support for retention policy configuration with `Elastic Curator <https://github.com/elastic/curator>`_.

* Upgrade to Elasticsearch 1.4.5.

Version 0.7.0
-------------

* Initial release of the plugin. This is a beta version.
