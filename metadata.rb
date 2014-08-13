name             'amanda'
maintainer       'TKNetworks'
maintainer_email 'nabeken@tknetworks.org'
license          'Apache 2.0'
description      'Installs/Configures amanda'
long_description 'Installs/Configures amanda'
version          '0.1.0'

%w{
  openbsd
}.each do |os|
  supports os
end

%w{
  chef-openbsd
}.each do |c|
  depends c
end
