#
# Author:: Ken-ichi TANABE (<nabeken@tknetworks.org>)
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

case node['platform_family']
when 'debian'
  package 'amanda-client' do
    action :install
  end

  directory "#{node['etc']['passwd']['backup']['dir']}/.ssh" do
    owner 'backup'
    group 'backup'
    mode '0700'
  end

  template "#{node['etc']['passwd']['backup']['dir']}/.ssh/authorized_keys" do
    owner 'backup'
    group 'backup'
    mode '0600'
    source 'authorized_keys.erb'
    variables(
      :from => node['amanda']['client']['from'],
      :command => '/usr/lib/amanda/amandad -auth=ssh amdump',
      :pubkey => node['amanda']['client']['pubkey'],
    )
  end

  ssh_keys = Chef::EncryptedDataBagItem.load('ssh_keys', 'amanda-client')
  file "#{node['etc']['passwd']['backup']['dir']}/.ssh/id_rsa" do
    mode 0600
    owner 'backup'
    group 'backup'
    content ssh_keys["key"]
    backup false
  end
else
  raise NotImplementedError
end
