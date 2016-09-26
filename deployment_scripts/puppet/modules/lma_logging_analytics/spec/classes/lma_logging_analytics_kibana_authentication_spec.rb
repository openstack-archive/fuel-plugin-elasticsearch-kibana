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

describe 'lma_logging_analytics::kibana_authentication' do
    let(:facts) do
        {:kernel => 'Linux', :operatingsystem => 'Ubuntu',
         :operatingsystemrelease => '12.4', :osfamily => 'Debian',
         :concat_basedir => '/foo' }
    end

    describe 'default parameters' do
        let(:params) do
            {:listen_address => '127.0.0.1', :listen_port => 80,
             :kibana_address  => '127.0.0.1', :kibana_port => 5106,
             :username => 'foouser', :password => 'foopass'
            }
        end

        it {
          should contain_class('apache')
          should contain_apache__custom_config('kibana-proxy')
          should contain_htpasswd('foouser')
          should contain_file('/etc/apache2/kibana.htpasswd')
        }
    end

    describe 'ldap parameters' do
        let(:params) do
            {:listen_address => '127.0.0.1', :listen_port => 80,
             :kibana_address  => '127.0.0.1', :kibana_port => 5106,
             :username => 'foouser', :password => 'foopass',
             :ldap_enabled => true,
             :ldap_protocol => 'ldap',
             :ldap_port => 389,
             :ldap_servers => ['ldap.foo.fr'],
             :ldap_bind_dn => 'cn=admin,dc=example,dc=com',
             :ldap_bind_password => 'foopass',
             :ldap_user_search_base_dns => 'ou=groups,dc=example,dc=com',
             :ldap_user_search_filter => '(&(objectClass=posixGroup)(memberUid=%s))',
             :ldap_user_attribute => 'uid',
            }
        end

        it {
          should contain_class('apache')
          should contain_apache__custom_config('kibana-proxy')
          should contain_htpasswd('foouser')
          should contain_file('/etc/apache2/kibana.htpasswd')
        }
    end

    describe 'ldap parameters with several ldap servers' do
        let(:params) do
            {:listen_address => '127.0.0.1', :listen_port => 80,
             :kibana_address  => '127.0.0.1', :kibana_port => 5106,
             :username => 'foouser', :password => 'foopass',
             :ldap_enabled => true,
             :ldap_protocol => 'ldap',
             :ldap_port => 389,
             :ldap_servers => ['ldap.foo1.fr', 'ldap.foo2.fr'],
             :ldap_bind_dn => 'cn=admin,dc=example,dc=com',
             :ldap_bind_password => 'foopass',
             :ldap_user_search_base_dns => 'ou=groups,dc=example,dc=com',
             :ldap_user_search_filter => '(&(objectClass=posixGroup)(memberUid=%s))',
             :ldap_user_attribute => 'uid',
            }
        end

        it {
          should contain_class('apache')
          should contain_apache__custom_config('kibana-proxy').
              with_content(/ldap:\/\/ldap.foo1.fr:389 ldap.foo2.fr:389/)
          should contain_htpasswd('foouser')
        }
    end

    describe 'ldap parameters are missing' do
        let(:params) do
            {:listen_address => '127.0.0.1', :listen_port => 80,
             :kibana_address  => '127.0.0.1', :kibana_port => 5106,
             :username => 'foouser', :password => 'foopass',
             :ldap_enabled => true,
             :ldap_protocol => 'ldap',
             :ldap_port => 389,
             :ldap_servers => ['ldap.foo.fr'],
             :ldap_user_search_base_dns => 'ou=groups,dc=example,dc=com',
             :ldap_user_search_filter => '(&(objectClass=posixGroup)(memberUid=%s))',
             :ldap_user_attribute => 'uid',
            }
        end

        it { is_expected.to raise_error(Puppet::Error, /Missing ldap_/) }
    end

    describe 'ldap parameters with authorization' do
        let(:params) do
            {:listen_address => '127.0.0.1', :listen_port => 80,
             :kibana_address  => '127.0.0.1', :kibana_port => 5106,
             :username => 'foouser', :password => 'foopass',
             :ldap_enabled => true,
             :ldap_protocol => 'ldap',
             :ldap_port => 389,
             :ldap_servers => ['ldap.foo.fr'],
             :ldap_bind_dn => 'cn=admin,dc=example,dc=com',
             :ldap_bind_password => 'foopass',
             :ldap_user_search_base_dns => 'ou=groups,dc=example,dc=com',
             :ldap_user_search_filter => '(&(objectClass=posixGroup)(memberUid=%s))',
             :ldap_user_attribute => 'uid',
             :ldap_authorization_enabled => true,
             :listen_port_viewer => 81,
             :ldap_group_attribute => 'memberUid',
             :ldap_admin_group_dn => 'cn=admin_group,dc=example,dc=com',
             :ldap_viewer_group_dn => 'cn=viewer_group,dc=example,dc=com',
            }
        end

        it {
          should contain_class('apache')
          should contain_apache__custom_config('kibana-proxy')
          should contain_htpasswd('foouser')
          should contain_file('/etc/apache2/kibana.htpasswd')
        }
    end

    describe 'ldap parameters with authorization missing' do
        let(:params) do
            {:listen_address => '127.0.0.1', :listen_port => 80,
             :kibana_address  => '127.0.0.1', :kibana_port => 5106,
             :username => 'foouser', :password => 'foopass',
             :ldap_enabled => true,
             :ldap_protocol => 'ldap',
             :ldap_port => 389,
             :ldap_servers => ['ldap.foo.fr'],
             :ldap_bind_dn => 'cn=admin,dc=example,dc=com',
             :ldap_bind_password => 'foopass',
             :ldap_user_search_base_dns => 'ou=groups,dc=example,dc=com',
             :ldap_user_search_filter => '(&(objectClass=posixGroup)(memberUid=%s))',
             :ldap_user_attribute => 'uid',
             :ldap_authorization_enabled => true,
             #:ldap_group_attribute => 'memberUid',
             #:ldap_admin_group_dn => 'cn=admin_group,dc=example,dc=com',
             #:ldap_viewer_group_dn => 'cn=viewer_group,dc=example,dc=com',
            }
        end

        it { is_expected.to raise_error(Puppet::Error, /Missing/) }
    end
end

