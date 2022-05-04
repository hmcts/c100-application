require 'rails_helper'

RSpec.describe Steps::Opening::ConsentOrderController, type: :controller do
  it_behaves_like 'a controller that checks the application payment status', for_action: :edit
  it_behaves_like 'a savepoint step controller'

  # Following examples will stub the court sanity check for simplicity,
  # as the above `savepoint` examples already test the involved code.

  it_behaves_like 'an intermediate step controller', Steps::Opening::ConsentOrderForm, C100App::OpeningDecisionTree do
    before do
      allow(controller).to receive(:court_sanity_check).and_return(true)
    end
  end

  # The following shared specs can really be used in any other step controller.
  # The important thing is to be tested in at least one, as any other will behave the same.
  it_behaves_like 'a step that can be drafted', Steps::Opening::ConsentOrderForm do
    before do
      allow(controller).to receive(:court_sanity_check).and_return(true)
    end
  end
end
