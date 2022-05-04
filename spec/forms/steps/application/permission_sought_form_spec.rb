require 'spec_helper'

RSpec.describe Steps::Application::PermissionSoughtForm do
  it_behaves_like 'a yes-no question form', attribute_name: :permission_sought,
                                            reset_when_yes: [:permission_details]
end
