#!/usr/bin/env ruby
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
#
require 'rubygems'
require 'hiera'
require 'timeout'

HIERA_CONFIG  = '/etc/puppet/hiera.yaml'

RETRY_COUNT   = 5
RETRY_WAIT    = 1
RETRY_TIMEOUT = 10

def hiera
  return $hiera if $hiera
  $hiera = Hiera.new(:config => HIERA_CONFIG)
  Hiera.logger = "noop"
  $hiera
end

def nodes
  nodes_array = hiera.lookup 'nodes', [], {}, nil, :array
  raise 'Invalid nodes data!' unless nodes_array.is_a? Array
  nodes_array
end

def corosync_roles
  return $corosync_roles if $corosync_roles
  $corosync_roles = hiera.lookup 'lma::corosync_roles', [], {}, nil, :array
  raise 'Invalid corosync_roles!' unless $corosync_roles.is_a? Array
  raise 'Empty corosync_roles list!' if $corosync_roles.empty?
  $corosync_roles
end

def corosync_nodes_count
  return $corosync_nodes_count if $corosync_nodes_count
  $corosync_nodes_count = nodes.select do |node|
    corosync_roles.include? node['role']
  end.size
end

def set_quorum_policy(value)
  puts "Setting no-quorum-policy to: '#{value}'"
  RETRY_COUNT.times do |n|
    begin
      Timeout::timeout(RETRY_TIMEOUT) do
        system "/usr/sbin/crm_attribute --verbose --type crm_config --name no-quorum-policy --update #{value}"
        return if $?.exitstatus == 0
      end
    rescue Timeout::Error
      nil
    end
    puts "Error! Retry: #{n + 1}"
    sleep RETRY_WAIT
  end
  fail "Could not set no-quorum-policy to: '#{value}'!"
end

def get_quorum_policy
  RETRY_COUNT.times do |n|
    begin
      Timeout::timeout(RETRY_TIMEOUT) do
        policy = `/usr/sbin/crm_attribute --type crm_config --name no-quorum-policy --query --quiet`.chomp
        return policy if $?.exitstatus == 0
      end
    rescue Timeout::Error
      nil
    end
    puts "Error! Retry: #{n + 1}"
    sleep RETRY_WAIT
  end
  fail "Could not get no-quorum-policy!"
end

puts "Corosync nodes found: '#{corosync_nodes_count}'"

if corosync_nodes_count > 2
  set_quorum_policy 'stop' unless get_quorum_policy == 'stop'
else
  set_quorum_policy 'ignore' unless get_quorum_policy == 'ignore'
end

puts "Current no-quorum-policy is: '#{get_quorum_policy}'"
exit 0
