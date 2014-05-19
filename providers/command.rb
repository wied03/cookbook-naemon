def whyrun_supported?
  true
end

use_inline_resources

action :create_or_update do
  node['naemon']['server']['packages'].each do |pname|
    package pname do

    end
  end
end