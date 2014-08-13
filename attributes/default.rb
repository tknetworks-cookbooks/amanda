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
default['amanda']['package']['version'] = '3.3.6'
default['amanda']['package']['tarball_url'] = "http://www.zmanda.com/downloads/community/Amanda/3.3.6/Source/amanda-#{node['amanda']['package']['version']}.tar.gz"
default['amanda']['package']['configure'] = '--sysconfdir=/etc --localstatedir=/var'

default['amanda']['user'] = 'amanda'
default['amanda']['group'] = 'backup'

default['amanda']['srv_dir'] = '/srv/amanda'
default['amanda']['conf_dir'] = '/etc/amanda'
default['amanda']['state_dir'] = '/var/amanda'

default['amanda']['conf_name'] = 'MyConfig'
default['amanda']['conf_cookbook'] = 'amanda'
