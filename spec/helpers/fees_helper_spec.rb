require 'rails_helper'

RSpec.describe FeesHelper, type: :helper do
  describe '#fee_amount' do
    it 'returns the localised version of the court fee' do
      expect(helper.fee_amount).to eq('£232')
    end
  end

  describe '#phase_banner_copy' do
    it 'completed application feedback' do
      stack = ['/steps/completion/next', '/steps/completion/what_next']
      @c100_application = C100Application.new(navigation_stack: stack)
      expect(helper.phase_banner_copy).to eq(I18n.t('layouts.phase_banner.feedback_completed_html'))
    end

    it 'in progress application feedback' do
      stack = ['/steps/completion/next']
      @c100_application = C100Application.new(navigation_stack: stack)

      expect(helper.phase_banner_copy).to eq(I18n.t('layouts.phase_banner.feedback_processing_html'))
    end

    it 'before start feedback' do
      expect(helper.phase_banner_copy).to eq(I18n.t('layouts.phase_banner.feedback_processing_html'))
    end
  end
end
