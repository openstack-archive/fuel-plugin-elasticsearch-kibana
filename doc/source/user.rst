.. _user:

Use the plugin
==============

Dashboards management
---------------------

The StackLight Elasticsearch-Kibana plugin comes with two built-in dashboards:

  * The Logs Analytics Dashboard that is used to visualize and search the logs.
  * The Notifications Analytics Dashboard that is used to visualize and
    search the OpenStack notifications if you enabled the feature in the
    Collector settings.

You can switch from one dashboard to another by clicking on the top-right *Load*
icon in the toolbar to select the requested dashboard from the list, as shown below.

.. image:: ../images/kibana_dash.png
   :align: center
   :width: 800

Each dashboard provides a single pane of glass for visualizing and searching
all the logs and the notifications of your OpenStack environment.
Note that in the Collector settings it is possible to tag the logs by
environment name so that you can distinguish which logs (and notifications)
belong to what environment.

As you can see, the Kibana dashboard for logs is divided in several sections:

.. image:: ../images/kibana_logs_sections_1.png
   :align: center
   :width: 800

1. A time-picker control that lets you choose the time period you want
   to select and refresh frequency.

2. A text-box to enter search queries.

3. Various logs analytics with six different panels:

  a. A stack graph showing all the logs per source.
  b. A stack graph showing all the logs per severity.
  c. A stack graph showing all logs top 10 sources.
  d. A stack graph showing all the logs top 10 programs.
  e. A stack graph showing all logs top 10 hosts.
  f. A graph showing the number of logs per severity.
  g. A graph showing the number of logs per role.

4. A table of log messages sorted in reverse chronological order.

.. image:: ../images/kibana_logs_sections_2.png
  :align: center
  :width: 800

Filters and queries
-------------------

Filters and queries have similar syntax but they are used for different purposes.

  * The filters are used to restrict what is displayed in the dashboard.
  * The queries are used for free-text search.

You can also combine multiple queries and compare their results.
To further filter the log messages to, for example, select the *deployment_id*,
you need to expand a log entry and then select the *deployment_id* field
by clicking on the magnifying glass icon as shown below.

.. image:: ../images/kibana_logs_filter1.png
   :align: center
   :width: 800

This will apply a new filter in the dashboard.

.. image:: ../images/kibana_logs_filter2.png
   :align: center
   :width: 800

Filtering will work for any field that has been indexed for the log entries that
are in the dashboard.

Filters and queries can also use wildcards that can be combined with *field names* like in::

    programname: <name>*

For example, to display only the Nova logs you could enter::

    programname:nova*

in the query textbox as shown below.

.. image:: ../images/kibana_logs_query1.png
   :align: center
   :width: 800
