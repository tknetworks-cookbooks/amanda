source "https://supermarket.getchef.com"

metadata

%w{
  chef-openbsd
}.each do |c|
  cookbook c, git: "git://github.com/tknetworks-cookbooks/#{c}.git", branch: 'fullspec'
end

group :integration do
  cookbook 'minitest-handler'
  cookbook 'amanda_test', :path => './test/cookbooks/amanda_test'
end
