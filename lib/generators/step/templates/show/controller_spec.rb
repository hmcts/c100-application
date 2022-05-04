require 'rails_helper'

RSpec.describe Steps::<%= task_name.camelize %>::<%= step_name.camelize %>Controller, type: :controller do
  it_behaves_like 'a show step controller'
end
