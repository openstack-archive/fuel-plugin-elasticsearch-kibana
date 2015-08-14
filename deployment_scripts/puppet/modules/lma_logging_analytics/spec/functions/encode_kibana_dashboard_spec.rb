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
require 'json'

describe 'encode_kibana_dashboard' do
    it "should return a JSON hash" do
        should run.with_params('bob', 'admin', 'some title', '{}').and_return(/"user":"bob"/).and_return(/"group":"admin"/)
    end

    it "should fail when invalid number of parameters are passed" do
        should run.with_params('bob', 'admin', 'some title').and_raise_error(/wrong number of arguments/i)
        should run.with_params('bob', 'admin', 'some title', '{}', 'extra').and_raise_error(/wrong number of arguments/i)
    end
end

