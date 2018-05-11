module CustomFormHelpers
  delegate :t,
           :current_c100_application,
           :user_signed_in?, to: :@template

  def continue_button(continue: :continue, save_and_continue: :save_and_continue)
    content_tag(:div, class: 'form-submit') do
      if save_and_return_disabled?
        submit_button(continue)
      elsif user_signed_in?
        submit_button(save_and_continue)
      else
        safe_concat [
          submit_button(continue),
          submit_button(:save_and_come_back_later, name: :commit_draft, class: %w[button button-secondary commit-draft-link])
        ].join
      end
    end
  end

  # Note: `#form_group_id` must receive a symbol (not a value-object)
  def single_check_box(attribute, options = {})
    content_tag(:div, merge_attributes(options, default: {class: 'multiple-choice single-cb', id: form_group_id(attribute.to_sym)})) do
      safe_concat [
        check_box(attribute),
        label(attribute) { localized_label(attribute) }
      ].join
    end
  end

  private

  def save_and_return_disabled?
    current_c100_application.nil? || current_c100_application.screening?
  end

  def submit_button(i18n_key, opts = {})
    submit t("helpers.submit.#{i18n_key}"), {class: 'button'}.merge(opts)
  end
end
