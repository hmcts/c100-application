class NotifyMailer < GovukNotifyRails::Mailer
  before_action do
    @service_name = I18n.translate!('service.name')
    @template_ids = Rails.configuration.govuk_notify_templates
  end

  # Triggered automatically by Devise when the user resets its password.
  # Do not change the method name unless you configure Devise with the new name.
  def reset_password_instructions(user, token, _opts = {})
    set_template(:reset_password)

    set_personalisation(
      reset_password_url: edit_user_password_url(reset_password_token: token),
    )

    mail(to: user.email)
  end

  # Triggered automatically by Devise when the user changes its password.
  # Do not change the method name unless you configure Devise with the new name.
  def password_change(user, _opts = {})
    set_template(:change_password)

    set_personalisation(
      drafts_url: users_drafts_url,
    )

    mail(to: user.email)
  end

  def application_saved_confirmation(c100_application)
    set_template(:application_saved)

    set_personalisation(
      resume_draft_url: resume_users_draft_url(c100_application),
      draft_expire_in_days: Rails.configuration.x.drafts.expire_in_days,
    )

    mail(to: c100_application.user.email)
  end

  def draft_expire_reminder(c100_application, template_name)
    set_template(template_name)

    set_personalisation(
      resume_draft_url: resume_users_draft_url(c100_application),
      user_expire_in_days: Rails.configuration.x.users.expire_in_days,
    )

    mail(to: c100_application.user.email)
  end

  protected

  # rubocop:disable Naming/AccessorMethodName
  def set_template(name)
    super(@template_ids.fetch(name))
  end

  def set_personalisation(personalisation)
    super({ service_name: @service_name }.merge(personalisation))
  end
  # rubocop:enable Naming/AccessorMethodName

  # GOV.UK Notify expects booleans to be literals `yes` or `no`
  # to show/hide optional content.
  def notify_boolean(value)
    value.present? ? 'yes' : 'no'
  end
end
