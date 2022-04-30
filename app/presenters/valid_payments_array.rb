class ValidPaymentsArray < SimpleDelegator
  COMMON_CHOICES = [
    PaymentType::HELP_WITH_FEES,
    PaymentType::SELF_PAYMENT_CHEQUE,
  ].freeze

  GOVUK_PAY_CONFIG = YAML.load_file(
    File.join(Rails.root, 'config', 'govuk_pay.yml')
  ).freeze

  attr_reader :c100_application

  def initialize(c100_application)
    @c100_application = c100_application

    super(
      choices_to_present
    )
  end

  def include?(other)
    collection.include?(PaymentType.new(other.to_s))
  end

  def pay_blocklist
    GOVUK_PAY_CONFIG.fetch('blocklist')
  end

  private

  def collection
    __getobj__
  end

  def court
    @_court ||= c100_application.court
  end

  def choices_to_present
    COMMON_CHOICES.dup.tap do |choices|
      choices.append(
        PaymentType::SOLICITOR
      ) if c100_application.has_solicitor?

      choices.append(
        PaymentType::ONLINE
      ) if govuk_pay_enabled?

      choices.append(
        PaymentType::SELF_PAYMENT_CARD
      ) if phone_pay_enabled?

      choices.delete(
        PaymentType::SELF_PAYMENT_CHEQUE
      ) if c100_application.online_submission?
    end
  end

  def govuk_pay_enabled?
    return false unless c100_application.online_submission?

    court.gbs_known? && pay_blocklist.exclude?(court.slug)
  end

  # Do not show `pay by phone` option if the application can
  # use online payment, or if it is print&post.
  #
  def phone_pay_enabled?
    # RST-3529 disable phone payment
    # return false unless c100_application.online_submission?
    # !govuk_pay_enabled?
    false
  end
end
