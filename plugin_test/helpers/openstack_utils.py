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

import time

from devops.helpers.helpers import wait
from fuelweb_test.helpers.checkers import check_repo_managment
from fuelweb_test import logger
from fuelweb_test.settings import DEPLOYMENT_MODE

from plugin import TestPlugin


def create_cluster_with_neutron(test_case, **options):
    """Assign neutron with tunneling segmentation."""

    default_settings = {
        "net_provider": 'neutron',
        "net_segment_type": 'tun',
        "assign_to_all_nodes": False,
        "images_ceph": False,
        "volumes_ceph": False,
        "ephemeral_ceph": False,
        "objects_ceph": False,
        "volumes_lvm": True,
        "ceilometer": False,
        "osd_pool_size": '1',
    }

    default_settings.update(options)
    test_case.cluster_id = test_case.fuel_web.create_cluster(
        name=test_case.__class__.__name__,
        mode=DEPLOYMENT_MODE,
        settings=default_settings)
    return test_case.cluster_id


def deploy_cluster(test_case, wait_for_status='operational'):
    """Deploy cluster with additional time for waiting on node's availability
    """
    try:
        test_case.fuel_web.deploy_cluster_wait(
            test_case.cluster_id, check_services=False,
            timeout=180 * 60)
    except Exception:
        nailgun_nodes = test_case.env.fuel_web.client.list_cluster_nodes(
            test_case.env.fuel_web.get_last_created_cluster())
        time.sleep(420)
        for n in nailgun_nodes:
            check_repo_managment(
                test_case.env.d_env.get_ssh_to_remote(n['ip']))
            logger.info('ip is {0}'.format(n['ip'], n['name']))
    if wait_for_status:
        wait_for_cluster_status(
            test_case, test_case.cluster_id, status=wait_for_status)


def update_deploy_check(test_case, nodes, delete=False, run_ostf=True):
    # Cluster configuration
    test_case.fuel_web.update_nodes(test_case.cluster_id, nodes_dict=nodes,
                                    pending_addition=not delete,
                                    pending_deletion=delete)
    # deploy cluster
    deploy_cluster(test_case)

    # check plugin works
    TestPlugin.check_plugin(test_case)

    # Run OSTF tests
    if run_ostf:
        test_case.fuel_web.run_ostf(cluster_id=test_case.cluster_id)


def wait_for_cluster_status(test_case, cluster_id, status='operational',
                            timeout=60*25):
    """Wait for cluster status until timeout is reached.
        :param test_case: Test case object, usually it is 'self'
        :param cluster_id: cluster identifier
        :param status: Cluster status, available values:

          - new
          - deployment
          - stopped
          - operational
          - error
          - remove
          - update
          - update_error
        :param timeout: the time that we are waiting.
        :return: time that we are actually waited.

    """
    def check_func():
        for c in test_case.fuel_web.client.list_clusters():
            if c['id'] == cluster_id and c['status'] == status:
                return True
        return False
    wtime = wait(check_func, interval=30, timeout=timeout)
    logger.info('Wait cluster id:"{}" deploy done in {} sec.'.format(
        cluster_id, wtime))
    return wtime
