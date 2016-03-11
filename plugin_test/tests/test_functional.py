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
    """IntegrationTests."""

    role_name = 'elasticsearch_kibana'
    cluster_id = ''

    @test(depends_on=[SetupEnvironment.prepare_slaves_9],
          groups=["elasticsearch_kibana_add_delete_controller_node"])
    @log_snapshot_after_test
    def contrail_plugin_add_delete_controller_node(self):
        """Verify that Controller node can be deleted
        and added after deploying

        Scenario:
            1. Create an environment with
               "Neutron with tunneling segmentation"
               as a network configuration
            2. Enable and configure Elasticsearch-Kibana plugin
            3. Add 3 controllers, compute and storage nodes
            4. Add 3 nodes with elasticsearch_kibana role
            5. Deploy cluster
            6. Run OSTF tests
            7. Delete a Controller node and deploy changes
            8. Run OSTF tests
            9. Add a node with "Controller" role and deploy changes
            10. Run OSTF tests. All steps must be completed successfully,
                without any errors.
        """
        self.prepare_plugin(self, slaves=9)

        self.activate_plugin(self)

        conf_no_controller = {
            'slave-01': ['controller'],
            'slave-02': ['controller'],
            # Here slave-03
            'slave-04': ['compute'],
            'slave-05': ['cinder'],
            'slave-06': [self.role_name],
            'slave-07': [self.role_name],
            'slave-08': [self.role_name],
        }
        conf_ctrl = {'slave-03': ['controller']}

        openstack_utils.update_deploy_check(
            self, dict(conf_no_controller, **conf_ctrl))

        openstack_utils.update_deploy_check(self, conf_ctrl, delete=True)
        openstack_utils.update_deploy_check(self, conf_ctrl)

    @test(depends_on=[SetupEnvironment.prepare_slaves_9],
          groups=["elasticsearch_kibana_plugin_add_delete_compute_node"])
    @log_snapshot_after_test
    def elasticsearch_kibana_plugin_add_delete_compute_node(self):
        """Verify that Compute node can be deleted and added after deploying

        Scenario:
            1. Create an environment with
            "Neutron with tunneling segmentation"
            as a network configuration
            2. Enable and configure Elasticsearch-Kibana plugin
            3. Add 3 controllers, 3 compute + storage nodes
            4. Add 3 nodes with elasticsearch_kibana roles
            5. Deploy cluster
            6. Run OSTF tests
            7. Delete a compute node and deploy changes
            8. Run OSTF tests
            9. Add a node with "compute" role and deploy changes
            10. Run OSTF tests

        """
        self.prepare_plugin(self, slaves=9)

        self.activate_plugin(self)

        conf_no_controller = {
            'slave-01': ['controller'],
            'slave-02': ['controller'],
            'slave-03': ['controller'],
            'slave-04': ['compute', 'cinder'],
            'slave-05': ['compute', 'cinder'],
            # Here slave-6
            'slave-07': [self.role_name],
            'slave-08': [self.role_name],
            'slave-09': [self.role_name],

        }
        conf_compute = {'slave-06': ['compute', 'cinder']}

        openstack_utils.update_deploy_check(
            self, dict(conf_no_controller, **conf_compute))
        openstack_utils.update_deploy_check(self, conf_compute, delete=True)
        openstack_utils.update_deploy_check(self, conf_compute)

    @test(depends_on=[SetupEnvironment.prepare_slaves_9],
          groups=["elasticsearch_kibana_plugin_add_delete_elasticsearch_node"])
    @log_snapshot_after_test
    def elasticsearch_kibana_plugin_add_delete_elasticsearch_node(self):
        """Verify that Compute node can be deleted and added after deploying

        Scenario:
            1. Create an environment with
            "Neutron with tunneling segmentation"
            as a network configuration
            2. Enable and configure Elasticsearch-Kibana plugin
            3. Add 3 controllers, 3 compute + storage nodes
            4. Add 3 nodes with elasticsearch_kibana roles
            5. Deploy cluster
            6. Run OSTF tests
            7. Delete an elasticsearch_kibana node and deploy changes
            8. Run OSTF tests
            9. Add a node with "elasticsearch_kibana" role and deploy changes
            10. Run OSTF tests

        """
        self.prepare_plugin(self, slaves=9)

        self.activate_plugin(self)

        conf_no_controller = {
            'slave-01': ['controller'],
            'slave-02': ['controller'],
            'slave-03': ['controller'],
            'slave-04': ['compute', 'cinder'],
            'slave-05': ['compute', 'cinder'],
            'slave-06': ['compute', 'cinder'],
            # Here slave-7
            'slave-08': [self.role_name],
            'slave-09': [self.role_name],

        }
        conf_compute = {'slave-07': [self.role_name]}

        openstack_utils.update_deploy_check(
            self, dict(conf_no_controller, **conf_compute))
        openstack_utils.update_deploy_check(self, conf_compute, delete=True)
        openstack_utils.update_deploy_check(self, conf_compute)
