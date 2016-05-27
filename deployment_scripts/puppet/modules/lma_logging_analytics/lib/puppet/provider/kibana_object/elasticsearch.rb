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
require 'json'

require File.expand_path(File.join(File.dirname(__FILE__), '..', 'elasticsearch'))

Puppet::Type.type(:kibana_object).provide(:elasticsearch, :parent => Puppet::Provider::Elasticsearch) do
    desc "Support for Kibana objects stored into Elasticsearch"

    defaultfor :kernel => 'Linux'

    def get_object_url
        url = "/%s/%s/%s" % [resource[:elasticsearch_index], resource[:type], resource[:id]]
    end

    # Return the object matching with the resource's title
    def find_object
        url = get_object_url()

        response = self.send_request('HEAD', url)

        case response.code
        when '404'
            return
        when '200'
            response = self.send_request('GET', url)
            @obj = JSON.parse(response.body)['_source']
        else
            fail("Fail to retrieve object '%s' (HTTP response: %s/%s)" %
                 [url, response.code, response.body])
        end
    end

    def content
        @obj
    end

    def check_response(operation, http_response)
        Puppet.debug http_response.body
        success = JSON.parse(http_response.body)['_shards']['successful']
        if success == 0
            url = get_object_url()
            fail("Fail to #{operation} object #{url} (HTTP response #{response.body})")
        end
    end

    def save_object(obj)
        url = get_object_url()
        response = self.send_request('PUT', url, obj)
        check_response('save', response)
    end

    def content=(value)
        self.save_object(value)
    end

    def create
        self.save_object(resource[:content])
    end

    def destroy
        url = get_object_url()
        response = self.send_request('DELETE', url)

        check_response('delete', response)
    end

    def exists?
        self.find_object()
    end
end
