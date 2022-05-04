module CustomFormHelpers
  delegate :t,
           :current_c100_application,
           :user_signed_in?, to: :@template

  def continue_button(continue: :continue, save_and_continue: :save_and_continue)
    if user_signed_in?
      submit_button(save_and_continue)
    else
      submit_button(continue) do
        draft_button(:save_and_come_back_later, secondary: true) if show_draft_button?
      end
    end
  end

  private

  # The `save and return` button will show once the application has advanced
  # a few steps, currently 3 steps (`child_protection_cases` attr is present).
  def show_draft_button?
    current_c100_application.try(:child_protection_cases)
  end

  def submit_button(i18n_key, opts = {}, &block)
    govuk_submit t("helpers.submit.#{i18n_key}"), **opts, &block
  end

  # Kind of hackish but `govuk_submit` does not currently accept `name` attribute
  def draft_button(i18n_key, opts = {})
    html = Nokogiri::HTML.fragment(
      submit_button(i18n_key, opts)
    ).at(:button)
    html['name'] = 'commit_draft'
    html['value'] = html.children.text
    html.to_html.html_safe
  end
end
