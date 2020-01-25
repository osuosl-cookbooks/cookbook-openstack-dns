# encoding: UTF-8
#
# Cookbook Name:: openstack-dns
# Recipe:: producer
#
# Copyright 2017, x-ion GmbH
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
#

include_recipe 'openstack-dns::common'

platform_options = node['openstack']['dns']['platform']

service 'designate_producer' do
  service_name platform_options['designate_producer_service']
  supports status: true, restart: true
  action [:enable, :start]
  subscribes :restart, 'template[/etc/designate/designate.conf]'
end
