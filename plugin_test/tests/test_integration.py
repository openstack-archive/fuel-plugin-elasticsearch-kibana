#    Copyright 2016 Mirantis, Inc.
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

from proboscis import test

from fuelweb_test.helpers.decorators import log_snapshot_after_test
from fuelweb_test.tests.base_test_case import SetupEnvironment

from helpers import openstack_utils
from helpers.plugin import TestPlugin


@test(groups=["plugins"])
class IntegrationTests(TestPlugin):
    """Class with integration tests for the Elasticsearch-Kibana plugin."""

    role_name = 'elasticsearch_kibana'
    cluster_id = ''

    @test(depends_on=[SetupEnvironment.prepare_slaves_5],
          groups=["elasticsearch_kibana_ha"])
    @log_snapshot_after_test
    def elasticsearch_kibana_ha(self):
        """BVT test for Elasticsearch Kibana plugin
        Install Elasticsearch Kibana plugin and deploy cluster
        with 3 controllers, 1 compute, 1 elasticsearch_kibana role

        Scenario:
            1. Upload plugin to the master node
            2. Install plugin
            3. Create cluster
            4. Add 3 nodes with controller role
            5. Add 1 node with compute and cinder role
            6. Add 1 node with elasticsearch_kibana role
            7. Deploy the cluster
            8. Check that plugin is working
            9. Run OSTF

        Duration 120m
        Snapshot elasticsearch_kibana_ha
        """

        self.prepare_plugin(slaves=5)

        self.activate_plugin(self)

        self.fuel_web.update_nodes(
            self.cluster_id,
            {
                'slave-01': ['controller'],
                'slave-02': ['controller'],
                'slave-03': ['controller'],
                'slave-04': ['compute'],
                'slave-05': [self.role_name]
            }
        )

        openstack_utils.deploy_cluster(self)

        self.check_elasticsearch_plugin(self)

        self.fuel_web.run_ostf(cluster_id=self.cluster_id)

        self.env.make_snapshot("elasticsearch_kibana_ha")

    @test(depends_on=[SetupEnvironment.prepare_slaves_5],
          groups=["elasticsearch_kibana_clustering"])
    @log_snapshot_after_test
    def elasticsearch_kibana_clustering(self):
        """Deploy a cluster with the Elasticsearch-Kibana plugin clustering

        Scenario:
            1. Upload plugin to the master node
            2. Install plugin
            3. Create cluster
            4. Add 1 node with controller role
            5. Add 1 node with compute and cinder role
            6. Add 3 nodes with elasticsearch_kibana role
            7. Deploy the cluster
            8. Check that plugin is working
            9. Run OSTF

        Duration 120m
        Snapshot elasticsearch_kibana_clustering
        """
        self.prepare_plugin(slaves=5)

        self.activate_plugin(self)

        self.fuel_web.update_nodes(
            self.cluster_id,
            {
                'slave-01': ['controller'],
                'slave-02': ['compute', 'cinder'],
                'slave-03': [self.role_name],
                'slave-04': [self.role_name],
                'slave-05': [self.role_name]
            }
        )

        openstack_utils.deploy_cluster(self)

        self.check_elasticsearch_plugin(self)

        self.fuel_web.run_ostf(cluster_id=self.cluster_id)

        self.env.make_snapshot("elasticsearch_kibana_clustering")

    @test(depends_on=[SetupEnvironment.prepare_slaves_9],
          groups=["elasticsearch_kibana_ha_clustering"])
    @log_snapshot_after_test
    def elasticsearch_kibana_ha_clustering(self):
        """Deploy a cluster in HA mode with the Elasticsearch-Kibana plugin
        clustering

        Scenario:
            1. Upload plugin to the master node
            2. Install plugin
            3. Create cluster
            4. Add 3 nodes with controller role
            5. Add 1 node with compute role
            6. Add 1 node with cinder role
            7. Add 3 nodes with elasticsearch_kibana role
            8. Deploy the cluster
            9. Check that plugin is working
            10. Run OSTF

        Duration 120m
        Snapshot elasticsearch_kibana_ha_clustering
        """
        self.prepare_plugin(slaves=9)

        self.activate_plugin(self)

        self.fuel_web.update_nodes(
            self.cluster_id,
            {
                'slave-01': ['controller'],
                'slave-02': ['controller'],
                'slave-03': ['controller'],
                'slave-04': ['compute'],
                'slave-05': ['cinder'],
                'slave-06': [self.role_name],
                'slave-07': [self.role_name],
                'slave-08': [self.role_name]
            }
        )

        openstack_utils.deploy_cluster(self)

        self.check_elasticsearch_plugin(self)

        self.fuel_web.run_ostf(cluster_id=self.cluster_id)

        self.env.make_snapshot("elasticsearch_kibana_ha_clustering")
