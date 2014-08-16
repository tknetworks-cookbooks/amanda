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
    'PUBKEY',
  ].each do |l|
    its(:content) {
      should include l
    }
  end
end

describe file('/var/backups/.ssh/id_rsa') do
  it {
    should contain 'SSH_KEY'
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
