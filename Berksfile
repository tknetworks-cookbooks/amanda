source "https://supermarket.getchef.com"

metadata

%w{
  chef-openbsd
}.each do |c|
  cookbook c, git: "git://github.com/tknetworks-cookbooks/#{c}.git", branch: 'fullspec'
end

group :integration do
  cookbook 'minitest-handler'
end
