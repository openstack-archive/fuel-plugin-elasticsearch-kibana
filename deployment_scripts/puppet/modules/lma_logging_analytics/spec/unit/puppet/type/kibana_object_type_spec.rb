# Copyright 2016 Mirantis, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
require 'spec_helper'

describe Puppet::Type.type(:kibana_object) do
  context "when setting parameters" do

    it "should fail if elasticsearch url isn't HTTP-based" do
      expect {
        described_class.new :name => "foo", :url => "example.com",
                            :content => "{}", :ensure => :present,
                            :type => 'dashboard'
      }.to raise_error(Puppet::Error, /not a valid URL/)
    end

    it "should fail if content isn't provided" do
      expect {
        described_class.new :name => "foo", :url => "http://example.com",
                            :ensure => :present, :type => 'dashboard'
      }.to raise_error(Puppet::Error, /content is required/)
    end

    it "should fail if content isn't JSON" do
      expect {
        described_class.new :name => "foo", :url => "http://example.com/",
                            :content => "{invalid", :ensure => :present, :type => 'dashboard'
      }.to raise_error(Puppet::Error, /Invalid JSON/)
    end

    it "should accept valid parameters" do
      resource = described_class.new :name => "foo", :url => "http://example.com/",
                                     :content => "{}", :ensure => :present,
                                     :type => 'dashboard'
      expect(resource[:name]).to eq('foo')
      expect(resource[:url]).to eq('http://example.com/')
      expect(resource[:content]).to eq({})
    end

    it "should fail if invalide type is provided" do
      expect {
        resource = described_class.new :name => "foo", :url => "http://example.com/",
                                       :content => "{}", :ensure => :present,
                                       :type => 'wrong type'
      }.to raise_error(Puppet::ResourceError, /Valid values are dashboard, visualization, search, config, index-pattern/)
    end
  end
end

