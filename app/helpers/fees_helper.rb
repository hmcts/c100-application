module FeesHelper
  def fee_amount
    ActionController::Base.helpers.number_to_currency(
      Rails.configuration.x.court_fee.amount_in_pence / 100
    )
  end

  def phase_banner_copy
    page = @c100_application.try(:navigation_stack).try(:last)
    if page == "/steps/completion/what_next"
      I18n.t('layouts.phase_banner.feedback_completed_html').html_safe
    else
      I18n.t('layouts.phase_banner.feedback_processing_html').html_safe
    end
  end
end
