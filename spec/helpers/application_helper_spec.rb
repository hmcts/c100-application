require 'rails_helper'

# TestController doesn't have this method so we can't stub it nicely
class ActionView::TestCase::TestController
  def previous_step_path
    '/foo/bar'
  end

  def fast_forward_to_cya?
    false
  end
end

RSpec.describe ApplicationHelper, type: :helper do
  let(:record) { C100Application.new }

  describe '#step_form' do
    let(:expected_defaults) { {
      url: {
        controller: "application",
        action: :update
      },
      html: {
        class: 'edit_c100_application'
      },
      method: :put
    } }
    let(:form_block) { Proc.new {} }

    it 'acts like FormHelper#form_for with additional defaults' do
      expect(helper).to receive(:form_for).with(record, expected_defaults) do |*_args, &block|
        expect(block).to eq(form_block)
      end
      helper.step_form(record, &form_block)
    end

    it 'accepts additional options like FormHelper#form_for would' do
      expect(helper).to receive(:form_for).with(record, expected_defaults.merge(foo: 'bar'))
      helper.step_form(record, { foo: 'bar' })
    end

    it 'appends optional css classes if provided' do
      expect(helper).to receive(:form_for).with(record, expected_defaults.merge(html: {class: %w(test edit_c100_application)}))
      helper.step_form(record, html: {class: 'test'})
    end
  end

  describe '#step_header' do
    let(:form_object) { double('Form object') }

    it 'renders the expected content' do
      expect(helper).to receive(:render).with(partial: 'layouts/step_header', locals: {path: '/foo/bar'}).and_return('foobar')
      assign(:form_object, form_object)

      expect(helper.step_header).to eq('foobar')
    end

    context 'a specific path is provided' do
      it 'renders the back link with provided path' do
        expect(helper).to receive(:render).with(partial: 'layouts/step_header', locals: {path: '/another/step'}).and_return('foobar')
        assign(:form_object, form_object)

        expect(helper.step_header(path: '/another/step')).to eq('foobar')
      end
    end

    context 'when using fast-forward to CYA' do
      it 'renders the back link with the check your answers path' do
        expect(controller).to receive(:fast_forward_to_cya?).and_return(true)

        expect(helper).to receive(:render).with(partial: 'layouts/step_header', locals: {path: '/steps/application/check_your_answers'}).and_return('foobar')
        assign(:form_object, form_object)

        expect(helper.step_header).to eq('foobar')
      end
    end
  end

  describe '#govuk_error_summary' do
    context 'when no form object is given' do
      let(:form_object) { nil }

      it 'returns nil' do
        expect(helper.govuk_error_summary(form_object)).to be_nil
      end
    end

    context 'when a form object without errors is given' do
      let(:form_object) { BaseForm.new }

      it 'returns nil' do
        expect(helper.govuk_error_summary(form_object)).to be_nil
      end
    end

    context 'when a form object with errors is given' do
      let(:form_object) { BaseForm.new }
      let(:title) { helper.content_for(:page_title) }

      before do
        helper.title('A page')
        form_object.errors.add(:base, :blank)
      end

      it 'returns the summary' do
        expect(
          helper.govuk_error_summary(form_object)
        ).to eq(
          '<div class="govuk-error-summary" tabindex="-1" role="alert" data-module="govuk-error-summary" aria-labelledby="error-summary-title"><h2 id="error-summary-title" class="govuk-error-summary__title">There is a problem on this page</h2><div class="govuk-error-summary__body"><ul class="govuk-list govuk-error-summary__list"><li><a data-turbolinks="false" href="#base-form-base-field-error">Enter an answer</a></li></ul></div></div>'
        )
      end

      it 'prepends the page title with an error hint' do
        helper.govuk_error_summary(form_object)
        expect(title).to start_with('Error: A page')
      end
    end
  end

  describe '#analytics_tracking_id' do
    it 'retrieves the value from the application' do
      expect(Rails.application.config.x).to receive(:analytics_tracking_id)
      helper.analytics_tracking_id
    end
  end

  describe 'capture missing translations' do
    before do
      ActionView::Base.raise_on_missing_translations = false
    end

    it 'should not raise an exception, and capture in Sentry the missing translation' do
      expect(Raven).to receive(:capture_exception).with(an_instance_of(I18n::MissingTranslationData))
      expect(Raven).to receive(:extra_context).with(
        {
          locale: :en,
          scope: nil,
          key: 'a_missing_key_here'
        }
      )
      helper.translate('a_missing_key_here')
    end
  end

  describe '#title' do
    let(:title) { helper.content_for(:page_title) }

    before do
      helper.title(value)
    end

    context 'for a blank value' do
      let(:value) { '' }
      it { expect(title).to eq('Apply to court about child arrangements - GOV.UK') }
    end

    context 'for a provided value' do
      let(:value) { 'Test page' }
      it { expect(title).to eq('Test page - Apply to court about child arrangements - GOV.UK') }
    end
  end

  describe '#fallback_title' do
    before do
      allow(Rails).to receive_message_chain(:application, :config, :consider_all_requests_local).and_return(false)
      allow(helper).to receive(:controller_name).and_return('my_controller')
      allow(helper).to receive(:action_name).and_return('an_action')
    end

    it 'should notify in Sentry about the missing translation' do
      expect(Raven).to receive(:capture_exception).with(
        StandardError.new('page title missing: my_controller#an_action')
      )
      helper.fallback_title
    end

    it 'should call #title with a blank value' do
      expect(helper).to receive(:title).with('')
      helper.fallback_title
    end
  end

  describe '#link_button' do
    it 'builds the link markup styled as a button' do
      expect(
        helper.link_button('Continue', root_path)
      ).to eq('<a class="govuk-button" role="button" draggable="false" data-module="govuk-button" href="/">Continue</a>')
    end

    it 'appends to the default attributes where possible, otherwise overwrite them' do
      expect(
        helper.link_button('Continue', root_path, class: 'ga-pageLink', draggable: true, data: { module: 'govuk-button', ga_category: 'category', ga_label: 'label' })
      ).to eq('<a class="govuk-button ga-pageLink" role="button" draggable="true" data-module="govuk-button" data-ga-category="category" data-ga-label="label" href="/">Continue</a>')
    end
  end

  describe 'dev_tools_enabled?' do
    before do
      allow(Rails).to receive_message_chain(:env, :development?).and_return(development_env)
      allow(Rails).to receive_message_chain(:env, :test?).and_return(test_env)
      allow(ENV).to receive(:[]).with('DEV_TOOLS_ENABLED').and_return(dev_tools_enabled)
    end

    let(:development_env) { false }
    let(:test_env) { false }
    let(:dev_tools_enabled) { '0' }

    context 'for development envs' do
      let(:development_env) { true }
      it { expect(helper.dev_tools_enabled?).to eq(true) }
    end

    context 'for test envs' do
      let(:test_env) { true }
      it { expect(helper.dev_tools_enabled?).to eq(true) }
    end

    context 'for envs that declare the `DEV_TOOLS_ENABLED` env variable' do
      let(:dev_tools_enabled) { '1' }
      it { expect(helper.dev_tools_enabled?).to eq(true) }
    end
  end

  describe 'display_private_option?' do
    let(:c100_application) { instance_double(C100Application, address_confidentiality: address_confidentiality)}
    before {
      allow(helper).to receive(:current_c100_application).and_return c100_application
    }

    context 'no' do
      let(:address_confidentiality) { 'no' }
      it { expect(helper.display_private_option?).to eq(false) }
    end

    context 'nil' do
      let(:address_confidentiality) { nil }
      it { expect(helper.display_private_option?).to eq(false) }
    end

    context 'yes' do
      let(:address_confidentiality) { 'yes' }
      it { expect(helper.display_private_option?).to eq(true) }
    end
  end

end
