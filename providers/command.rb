def whyrun_supported?
  true
end

use_inline_resources

action :create_or_update do
  fail 'we ran the commmand, whew!'
end