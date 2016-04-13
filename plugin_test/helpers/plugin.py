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
import requests

from proboscis.asserts import assert_equal
from proboscis.asserts import assert_is_not_none
from proboscis.asserts import assert_true

from fuelweb_test import logger
from fuelweb_test.settings import ELASTICSEARCH_KIBANA_PLUGIN_PATH
from fuelweb_test.tests.base_test_case import TestBasic

import openstack_utils


NAME = 'elasticsearch_kibana'
VERSION = '0.9.0'


class TestPlugin(TestBasic):
    """Helper methods for testing of plugin."""

    def get_vip(self):
        networks = self.fuel_web.client.get_networks(self.cluster_id)
        return networks.get('vips').get('es_vip_mgmt', {}).get('ipaddr', None)

    def prepare_plugin(self, slaves, options=None):
        self.env.revert_snapshot("ready_with_%d_slaves" % slaves)
        options = options or {}
        self.env.admin_actions.upload_plugin(
            plugin=ELASTICSEARCH_KIBANA_PLUGIN_PATH)
        self.env.admin_actions.install_plugin(
            plugin_file_name=os.path.basename(
                ELASTICSEARCH_KIBANA_PLUGIN_PATH))

        openstack_utils.create_cluster_with_neutron(self, **options)

    def activate_plugin(self):
        msg = "Plugin couldn't be enabled. Check plugin version. Test aborted"
        assert_true(
            self.fuel_web.check_plugin_exists(self.cluster_id, NAME), msg)

        self.fuel_web.update_plugin_settings(
            self.cluster_id, NAME, VERSION, {})

    def check_plugin(self):
        es_server_ip = self.get_vip()
        assert_is_not_none(es_server_ip,
                           "Failed to get the IP of Elasticsearch server")

        logger.debug("Check that Elasticsearch is ready")

        r = requests.get("http://{}:9200/".format(es_server_ip))
        msg = "Elasticsearch responded with {}, expected 200".format(
            r.status_code)
        assert_equal(r.status_code, 200, msg)

        logger.debug("Check that the HTTP server is running")

        r = requests.get("http://{}/".format(es_server_ip))
        msg = "HTTP server responded with {}, expected 200".format(
            r.status_code)
        assert_equal(r.status_code, 200, msg)
