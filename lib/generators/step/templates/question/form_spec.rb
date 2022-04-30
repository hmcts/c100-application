require 'spec_helper'

RSpec.describe Steps::<%= task_name.camelize %>::<%= step_name.camelize %>Form do
  it_behaves_like 'a yes-no question form', attribute_name: :<%= step_name.underscore %>
end
