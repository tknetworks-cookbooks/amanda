#
# Author:: TANABE Ken-ichi (<nabeken@tknetworks.org>)
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
require 'spec_helper'

describe package('amanda-client') do
  it { should be_installed }
end

describe file("/var/backups/.ssh/authorized_keys") do
  [
    'from="192.168.1.1"',
    'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD4yyx7vfZ635j5kd5j7ZnkT9hJ6eKCF0eTMlBBbOB9e8WR6NPiKimnnht24Fn64Vco/VYSleXIiHv4StOpvzyoJPX33lE6f6PRW18EDSAtWBN+xDEcSn+5BnZIn02yonr9zfrtMNF3cD9h3BlbWukrNRwZKU7T9ABJCa/xr5NPb7l+bhAGRQKvRS+iFqvSSP8c4hrH+8OhTwShw4jyZsOUkU9/t2Xx+w1D+Ma2lwdO0RD7RQIfQqPwzacmpR0EHjDTFsMLrViUSoXxDbsOCut7bs+AcBVH9AX5VCctR3R0qD6vgKxjZu7Kpi3nulrt94V2mRHm06vfml6/a9sNsyCD amanda-test-ssh-key'
  ].each do |l|
    its(:content) {
      should include l
    }
  end
end

describe file('/var/backups/.ssh/id_rsa') do
  it {
    should contain '----BEGIN RSA PRIVATE KEY-----'
    should be_file
    should be_owned_by 'backup'
    should be_grouped_into 'backup'
    should be_mode 600
  }
end

describe file('/var/backups/.ssh') do
  it {
    should be_directory
    should be_owned_by 'backup'
    should be_grouped_into 'backup'
    should be_mode 700
  }
end
