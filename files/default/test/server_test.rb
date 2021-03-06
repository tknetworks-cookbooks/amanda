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
require 'minitest/spec'

describe_recipe 'amanda::server' do
  it 'downloads amanda-3.3.6.tar.gz' do
    file(File.join(Chef::Config[:file_cache_path], File.basename(node['amanda']['package']['tarball_url'])))
    .must_exist
    .with(:owner, 'root')
    .and(:group, 'wheel')
    .and(:mode, '0600')
  end

  it 'creates directories' do
    %w{
      /etc/amanda
      /etc/amanda/MyConfig
      /srv/amanda/holding
      /srv/amanda/state
      /srv/amanda/vtapes
      /var/amanda
      /var/amanda/gnutar-lists
    }.each do |d|
      directory(d)
      .must_exist
      .with(:owner, node['amanda']['user'])
      .and(:group, node['amanda']['group'])
      .and(:mode, '0700')
    end
  end

  it 'install binaries' do
    file('/usr/local/sbin/amcheck')
    .must_exist
    .with(:owner, 'root')
    .and(:group, 'backup')
    .and(:mode, '4750')
  end

  it 'install configs' do
    file('/etc/amanda/MyConfig/amanda.conf')
    .must_exist
    .must_include('org "MyConfig"')
    .must_include('infofile "/srv/amanda/state/curinfo')
    .with(:owner, 'amanda')
    .and(:group, 'backup')
    .and(:mode, '0640')

    file('/etc/amanda/MyConfig/disklist')
    .must_exist
    .must_include('localhost /etc simple-gnutar-local')
    .with(:owner, 'amanda')
    .and(:group, 'backup')
    .and(:mode, '0640')
  end

  it 'creates .ssh directory' do
    directory('/home/amanda/.ssh')
    .must_exist
    .with(:owner, 'amanda')
    .and(:group, 'backup')
    .and(:mode, '0700')
  end

  it 'sets ssh private key' do
    file('/home/amanda/.ssh/id_rsa')
    .must_exist
    .must_include('----BEGIN RSA PRIVATE KEY-----')
    .with(:owner, 'amanda')
    .and(:group, 'backup')
    .and(:mode, '0600')
  end

  it 'sets ssh public key' do
    file('/home/amanda/.ssh/authorized_keys')
    .must_exist
    .must_include('no-port-forwarding,no-X11-forwarding,no-agent-forwarding,command="/usr/local/libexec/amanda/amandad -auth=ssh amindexd amidxtaped" ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD4yyx7vfZ635j5kd5j7ZnkT9hJ6eKCF0eTMlBBbOB9e8WR6NPiKimnnht24Fn64Vco/VYSleXIiHv4StOpvzyoJPX33lE6f6PRW18EDSAtWBN+xDEcSn+5BnZIn02yonr9zfrtMNF3cD9h3BlbWukrNRwZKU7T9ABJCa/xr5NPb7l+bhAGRQKvRS+iFqvSSP8c4hrH+8OhTwShw4jyZsOUkU9/t2Xx+w1D+Ma2lwdO0RD7RQIfQqPwzacmpR0EHjDTFsMLrViUSoXxDbsOCut7bs+AcBVH9AX5VCctR3R0qD6vgKxjZu7Kpi3nulrt94V2mRHm06vfml6/a9sNsyCD amanda-test-ssh-key')
    .with(:owner, 'amanda')
    .and(:group, 'backup')
    .and(:mode, '0600')
  end
end
