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
require 'spec_helper'

describe 'lma_logging_analytics::curator', :type => :class do
    let(:facts) do
        {:kernel => 'Linux', :operatingsystem => 'Ubuntu'}
    end

    describe 'with defaults' do
        it { is_expected.to contain_package('python-elasticsearch-curator').with(
            :ensure => 'latest'
        )}

        it { is_expected.not_to contain_cron('es-curator') }
        it { is_expected.not_to contain_file('/etc/elasticsearch/curator.yaml') }
        it { is_expected.not_to contain_file('/etc/elasticsearch/delete_indices.yaml') }
    end

    describe 'with index prefixes and retention period > 0' do
        let(:params) do
            {:retention_period => 10, :prefixes => ['foo']}
        end

        it { is_expected.to contain_package('python-elasticsearch-curator').with(
            :ensure => 'latest'
        )}

        it { is_expected.to contain_cron('es-curator').with_command(
            '/usr/local/bin/curator --config /etc/elasticsearch/curator.yaml /etc/elasticsearch/delete_indices.yaml') }
        it { is_expected.to contain_file('/etc/elasticsearch/curator.yaml') }
        it { is_expected.to contain_file('/etc/elasticsearch/delete_indices.yaml') }
    end

    describe 'with index prefixes and retention period > 0 and host' do
        let(:params) do
            {:retention_period => 10, :prefixes => ['foo'], :host => 'foo.org'}
        end

        it { is_expected.to contain_cron('es-curator').with_command(
            '/usr/local/bin/curator --config /etc/elasticsearch/curator.yaml /etc/elasticsearch/delete_indices.yaml') }
    end
end
