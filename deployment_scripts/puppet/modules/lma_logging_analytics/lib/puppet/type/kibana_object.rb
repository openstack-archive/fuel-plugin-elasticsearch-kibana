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

Puppet::Type.newtype(:kibana_object) do
    @doc = "Manage Kibana objects"

    ensurable

    newparam(:id, :namevar => true) do
        desc "The id of the object."
    end

    newparam(:type) do
        desc "The type of the object.
        valid type is one of: search, visualization, index-pattern or config
        "
        newvalues(:dashboard, :visualization, :search, :config, "index-pattern")
    end

    newproperty(:content) do
        desc "The JSON representation of the object."

        validate do |value|
            begin
                JSON.parse(value)
            rescue JSON::ParserError
                raise ArgumentError , "Invalid JSON string for content"
            end
        end

        munge do |value|
            JSON.parse(value)
        end

        def should_to_s(value)
            if value.length > 12
                "#{value.to_s.slice(0,12)}..."
            else
                value
            end
        end

        def is_to_s(value)
            should_to_s(value)
        end
    end

    newparam(:url) do
        desc "The URL of the Elasticseach server"
        defaultto ""

        validate do |value|
            unless value =~ /^https?:\/\//
                raise ArgumentError , "'%s' is not a valid URL" % value
            end
        end
    end

    newparam(:elasticsearch_index) do
        defaultto ".kibana"

        desc "The Elasticseach index server (optional)"
    end

    validate do
        fail('content is required when ensure is present') if self[:ensure] == :present and self[:content].nil?
    end
end
