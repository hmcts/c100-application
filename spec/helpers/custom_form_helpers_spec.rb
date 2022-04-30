#TODO is there a better way to do this?

require 'rails_helper'

class TestHelper < ActionView::Base
  #:nocov:
  def user_signed_in?
    false
  end
  #:nocov:
end

# The module `CustomFormHelpers` gets mixed in and extends the helpers already
# provided by `GOVUKDesignSystemFormBuilder::FormBuilder`. These are app-specific
# form helpers so can be coupled to application business and logic.
#
# Refer to: `config/initializers/form_builder.rb`
#
RSpec.describe GOVUKDesignSystemFormBuilder::FormBuilder do
  let(:helper) { TestHelper.new }

  describe '#continue_button' do
    let(:builder) { described_class.new :applicant, Applicant.new, helper, {} }
    let(:html_output) { builder.continue_button }

    let(:c100_application) { nil }
    let(:user_signed_in)   { false }

    before do
      allow(helper).to receive(:current_c100_application).and_return(c100_application)
      allow(helper).to receive(:user_signed_in?).and_return(user_signed_in)
    end

    context 'no c100 application yet' do
      it 'outputs the continue button' do
        expect(
          html_output
        ).to eq('<button type="submit" formnovalidate="formnovalidate" class="govuk-button" data-module="govuk-button" data-prevent-double-click="true">Continue</button>')
      end
    end

    context 'for a logged in user' do
      let(:c100_application) { instance_double(C100Application) }
      let(:user_signed_in)   { true }

      it 'outputs the save and continue button' do
        expect(
          html_output
        ).to eq('<button type="submit" formnovalidate="formnovalidate" class="govuk-button" data-module="govuk-button" data-prevent-double-click="true">Save and continue</button>')
      end

      context 'with button value customised' do
        let(:html_output) { builder.continue_button save_and_continue: :confirm_and_finish }

        it 'outputs the custom value' do
          expect(
            html_output
          ).to eq('<button type="submit" formnovalidate="formnovalidate" class="govuk-button" data-module="govuk-button" data-prevent-double-click="true">Confirm and finish</button>')
        end
      end
    end

    context 'for a logged out user' do
      let(:c100_application) { instance_double(C100Application, child_protection_cases: child_protection_cases) }

      context 'for an application that can not be drafted yet' do
        let(:child_protection_cases) { nil }

        it 'outputs the continue button' do
          expect(
            html_output
          ).to eq('<button type="submit" formnovalidate="formnovalidate" class="govuk-button" data-module="govuk-button" data-prevent-double-click="true">Continue</button>')
        end
      end

      context 'for an application that can be drafted' do
        let(:child_protection_cases) { 'foobar' }

        it 'outputs the continue button together with a save draft button' do
          expect(
            html_output
          ).to eq('<div class="govuk-button-group"><button type="submit" formnovalidate="formnovalidate" class="govuk-button" data-module="govuk-button" data-prevent-double-click="true">Continue</button><button type="submit" formnovalidate="formnovalidate" class="govuk-button govuk-button--secondary" data-module="govuk-button" data-prevent-double-click="true" name="commit_draft" value="Save and come back later">Save and come back later</button></div>')
        end

        context 'with button value customised' do
          let(:html_output) { builder.continue_button continue: :confirm_and_finish }

          it 'outputs the custom value' do
            expect(
              html_output
            ).to eq('<div class="govuk-button-group"><button type="submit" formnovalidate="formnovalidate" class="govuk-button" data-module="govuk-button" data-prevent-double-click="true">Confirm and finish</button><button type="submit" formnovalidate="formnovalidate" class="govuk-button govuk-button--secondary" data-module="govuk-button" data-prevent-double-click="true" name="commit_draft" value="Save and come back later">Save and come back later</button></div>')
          end
        end
      end
    end
  end
end
