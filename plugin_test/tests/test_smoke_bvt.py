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

import os
import os.path

from proboscis import test
from fuelweb_test.helpers.decorators import log_snapshot_after_test
from fuelweb_test.tests.base_test_case import SetupEnvironment
from fuelweb_test.tests.base_test_case import TestBasic
from helpers import plugin
from helpers import openstack


@test(groups=["plugins"])
class ElasticsearchKibanaPlugin(TestBasic):
    """ElasticsearchKibanaPlugin."""

    role_name = 'elasticsearch_kibana'
    cluster_id = ''

    @test(depends_on=[SetupEnvironment.prepare_slaves_3],
          groups=["install_elasticsearch_kibana"])
    @log_snapshot_after_test
    def install_elasticsearch_kibana(self):
        """Install Elasticsearch Kibana Plugin and create cluster

        Scenario:
            1. Revert snapshot "ready_with_3_slaves"
            2. Upload plugin to the master node
            3. Install plugin
            4. Create cluster

        Duration 20 min

        """

        plugin.prepare_plugin(self, slaves=3)

    @test(depends_on=[SetupEnvironment.prepare_slaves_3],
          groups=["elasticsearch_kibana_smoke"])
    @log_snapshot_after_test
    def elasticsearch_kibana_smoke(self):
        """Deploy a cluster with Elasticsearch Kibana Plugin

        Scenario:
            1. Revert snapshot "ready_with_3_slaves"
            2. Create cluster
            3. Add a node with elasticsearch_kibana role
            4. Add a node with controller role
            4. Add a node with compute role
            6. Enable Elasticsearch Kibana plugin
            5. Deploy the cluster with plugin

        Duration 90 min

        """
        plugin.prepare_plugin(self, slaves=3)

        plugin.activate_plugin(self)

        self.fuel_web.update_nodes(
            self.cluster_id,
            {
                'slave-01': ['controller'],
                'slave-02': ['compute'],
                'slave-03': [self.role_name],
            })

        # deploy cluster
        openstack.deploy_cluster(self)

    @test(depends_on=[SetupEnvironment.prepare_slaves_3],
          groups=["elasticsearch_kibana_smoke_bvt"])
    @log_snapshot_after_test
    def elasticsearch_kibana_smoke_bvt(self):
        """BVT test for Elasticsearch Kibana plugin
        Install Elasticsearch Kibana plugin and deploy cluster
        with 1 controller, 1 compute, 1 elasticsearch_kibana role

        Scenario:
            1. Upload plugin to the master node
            2. Install plugin
            3. Create cluster
            4. Add 1 node with controller role
            5. Add 1 node with compute and cinder role
            6. Add 1 node with elasticsearch_kibana role
            7. Deploy the cluster
            8. Run OSTF

        Duration 120m
        Snapshot elasticsearch_kibana_ha
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

