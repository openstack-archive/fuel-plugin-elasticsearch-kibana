#    Copyright 2015 Mirantis, Inc.
#
#    Licensed under the Apache License, Version 2.0 (the "License"); you may
#    not use this file except in compliance with the License. You may obtain
#    a copy of the License at
#
#         http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
#    WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
#    License for the specific language governing permissions and limitations
#    under the License.
import os

from proboscis import test

from fuelweb_test.helpers.decorators import log_snapshot_after_test
from fuelweb_test.tests.base_test_case import SetupEnvironment
from fuelweb_test.tests.base_test_case import TestBasic
from helpers import openstack
from helpers import plugin


@test(groups=["plugins"])
class TestElasticsearchPlugin(TestBasic):
    """Class for testing the Elasticsearch-Kibana plugin."""

    role_name = 'elasticsearch_kibana'
    cluster_id = ''

    @test(depends_on=[SetupEnvironment.prepare_slaves_3],
          groups=["deploy_elasticsearch_kibana"])
    @log_snapshot_after_test
    def deploy_elasticsearch_kibana_plugin(self):
        """Deploy a cluster with the Elasticsearch-Kibana plugin

        Scenario:
            1. Upload plugin to the master node
            2. Install plugin
            3. Create cluster
            4. Add 1 node with controller role
            5. Add 1 node with compute role
            6. Add 1 node with elasticsearch_kibana role
            7. Deploy the cluster
            8. Check that plugin is working
            9. Run OSTF

        Duration 60m
        Snapshot deploy_elasticsearch_kibana_plugin
        """

        plugin.prepare_plugin(slaves=3)

        plugin.activate_plugin(self)

        self.fuel_web.update_nodes(
            self.cluster_id,
            {
                'slave-01': ['controller'],
                'slave-02': ['compute'],
                'slave-03': [self.role_name]
            }
        )

        openstack.deploy_cluster(self)

        plugin.check_elasticsearch_plugin(self)

        self.fuel_web.run_ostf(cluster_id=self.cluster_id)

        self.env.make_snapshot("deploy_elasticsearch_kibana_plugin")

    @test(depends_on=[SetupEnvironment.prepare_slaves_5],
          groups=["deploy_elasticsearch_kibana_ha_mode"])
    @log_snapshot_after_test
    def deploy_elasticsearch_kibana_plugin_ha_mode(self):
        """Deploy a cluster with the Elasticsearch-Kibana plugin

        Scenario:
            1. Upload plugin to the master node
            2. Install plugin
            3. Create cluster
            4. Add 1 node with controller role
            5. Add 1 node with compute role
            6. Add 3 nodes with elasticsearch_kibana role
            7. Deploy the cluster
            8. Check that plugin is working
            9. Run OSTF

        Duration 60m
        Snapshot deploy_elasticsearch_kibana_plugin_ha_mode
        """
        plugin.prepare_plugin(slaves=5)

        plugin.activate_plugin(self)

        self.fuel_web.update_nodes(
            self.cluster_id,
            {
                'slave-01': ['controller'],
                'slave-02': ['compute'],
                'slave-03': [self.role_name],
                'slave-04': [self.role_name],
                'slave-05': [self.role_name]
            }
        )

        openstack.deploy_cluster(self)

        plugin.check_elasticsearch_plugin(self)

        self.fuel_web.run_ostf(cluster_id=self.cluster_id)

        self.env.make_snapshot("deploy_elasticsearch_kibana_plugin_ha_mode")