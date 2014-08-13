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

case node['platform']
when 'openbsd'
  tarball_url = node['amanda']['package']['tarball_url']
  r = remote_file File.join(Chef::Config[:file_cache_path], File.basename(tarball_url)) do
    source tarball_url
    backup false
    mode 0600
    not_if do
      ::File.exists?(tarball_url)
    end
  end
  r.run_action(:create_if_missing)

  %w{
    glib2 gmake gtar--static
  }.each do |pkg|
    package pkg do
      action :install
    end
  end

  group node['amanda']['group'] do
    action :create
  end
  user node['amanda']['user'] do
    action :create
    home '/home/amanda'
    group node['amanda']['group']
  end

  bash 'install-amanda-from-source' do
    user 'root'
    cwd Chef::Config[:file_cache_path]
    code <<-EOS
    tar zxf #{File.basename(tarball_url)} \
      && cd amanda-#{node['amanda']['package']['version']} \
      && ./configure #{node['amanda']['package']['configure']} \
      && gmake -j4 \
      && gmake install
    EOS
    not_if 'test -f /usr/local/sbin/amcheck'
  end

  %W{
    #{node['amanda']['conf_dir']}
    #{node['amanda']['conf_dir']}/MyConfig
    #{node['amanda']['srv_dir']}
    #{node['amanda']['srv_dir']}/holding
    #{node['amanda']['srv_dir']}/state
    #{node['amanda']['srv_dir']}/vtapes
    #{node['amanda']['state_dir']}
    #{node['amanda']['state_dir']}/gnutar-lists
  }.each do |d|
    directory d do
      user node['amanda']['user']
      group node['amanda']['group']
      mode '0700'
      recursive true
    end
  end

  %w{
    curinfo
    index
    log
  }.each do |d|
    directory "#{node['amanda']['srv_dir']}/state/#{d}" do
      user node['amanda']['user']
      group node['amanda']['group']
      mode '0700'
    end
  end
  (1..4).each do |i|
    directory "#{node['amanda']['srv_dir']}/vtapes/slot#{i}" do
      user node['amanda']['user']
      group node['amanda']['group']
      mode '0700'
      recursive true
    end
  end
else
  raise NotImplementedError
end
