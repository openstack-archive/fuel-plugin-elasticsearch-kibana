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
require 'spec_helper'

describe 'lma_logging_analytics::elasticsearch', :type => :class do
    let(:facts) do
        {:kernel => 'Linux', :operatingsystem => 'Ubuntu'}
    end

    describe 'minimal parameters' do
        let(:params) do
            {:listen_address => '127.0.0.1',
             :data_dir => '/tmp/es-data',
             :node_name => 'foo-host',
             :cluster_name => 'es-cluster',
             :instance_name => 'es-42',
             :nodes => ['node-1', 'node-2', 'foo-host'],
             :version => '5.0.0',
            }
        end

        it { is_expected.to contain_class('elasticsearch').with(
             :version => '5.0.0'
        )}

        it { is_expected.to contain_elasticsearch__instance('es-42') }
        it { is_expected.to contain_file('/tmp/es-data').with(
            :ensure => 'directory'
        )}
        it { is_expected.to contain_file('/etc/logrotate.d/elasticsearch-es-42.conf') }
    end

end
