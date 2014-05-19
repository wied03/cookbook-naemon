def whyrun_supported?
  true
end

use_inline_resources

action :create_or_update do
  package 'foo' do

  end
end