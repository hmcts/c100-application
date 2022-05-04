module ApplicationHelper
  # Render a form_for tag pointing to the update action of the current controller
  def step_form(record, options = {}, &block)
    opts = {
      url: { controller: controller.controller_path, action: :update },
      method: :put
    }.merge(options)

    # Support for appending optional css classes, maintaining the default one
    opts.merge!(
      html: { class: dom_class(record, :edit) }
    ) do |_key, old_value, new_value|
      { class: old_value.values | new_value.values }
    end

    form_for record, opts, &block
  end

  # Render a back link pointing to the user's previous step
  # or to the CYA page if using the fast-forward functionality.
  # If a specific path is provided, it takes precedence.
  #
  def step_header(path: nil)
    if path.nil? && controller.fast_forward_to_cya?
      path = edit_steps_application_check_your_answers_path
    end

    render partial: 'layouts/step_header', locals: {
      path: path || controller.previous_step_path
    }
  end

  def govuk_error_summary(form_object = @form_object)
    return unless form_object.try(:errors).present?

    # Prepend page title so screen readers read it out as soon as possible
    content_for(:page_title, flush: true) do
      content_for(:page_title).insert(0, t('errors.page_title_prefix'))
    end

    fields_for(form_object, form_object) do |f|
      f.govuk_error_summary t('errors.error_summary.heading')
    end
  end

  def analytics_tracking_id
    Rails.application.config.x.analytics_tracking_id
  end

  def service_name
    t('service.name')
  end

  def title(page_title)
    content_for :page_title, [page_title.presence, service_name, 'GOV.UK'].compact.join(' - ')
  end

  # We send a notification to Sentry to be alerted about any missing page titles.
  # If this happens, the title will default to a generic title for the service
  def fallback_title
    exception = StandardError.new("page title missing: #{controller_name}##{action_name}")
    raise exception if Rails.application.config.consider_all_requests_local
    Raven.capture_exception(exception)

    title ''
  end

  def link_button(name, href, options = {})
    html_options = {
      class: 'govuk-button',
      role: 'button',
      draggable: false,
      data: { module: 'govuk-button' },
    }.merge(options) do |_key, old_value, new_value|
      if new_value.is_a?(String) || new_value.is_a?(Array)
        # For strings or array attributes, merge (union) both values
        Array(old_value) | Array(new_value)
      else
        # For other attributes do not merge, override (i.e. draggable and data)
        new_value
      end
    end

    link_to name, href, html_options
  end

  # Use this to feature-flag code that should only show in test environments
  def dev_tools_enabled?
    Rails.env.development? || Rails.env.test? || %w[true yes 1].include?(ENV['DEV_TOOLS_ENABLED'])
  end

  def path_only(url)
    return nil if url.nil?

    URI.parse(url).tap do |uri|
      uri.host = nil
      uri.port = nil
      uri.scheme = nil
    end.to_s
  end

  def display_private_option?
    current_c100_application.address_confidentiality == 'yes'
  end
end
