class EmailValidator < ActiveModel::EachValidator
  EMAIL_REGEX = /\A\s*([-\p{L}\d+._]{1,64})@((?:[-\p{L}\d]+\.)+?\p{L}{2,})\s*\z/i.freeze

  COMMON_DOMAIN_TYPOS = %w[
    cloud.com
    gamil.com
    gmial.com
    homail.com
  ].freeze

  # Gmail only has these 2 valid domains, no others
  VALID_GMAIL_DOMAINS = %w[
    gmail.com
    googlemail.com
  ].freeze

  # Hotmail has a few legacy valid domains
  VALID_HOTMAIL_DOMAINS = %w[
    hotmail.com
    hotmail.co.uk
    hotmail.fr
    hotmail.it
    hotmail.es
    hotmail.de
  ].freeze

  def validate_each(record, attribute, value)
    if valid_format?(value)
      record.errors.add(attribute, :typo) if domain_typo?(value)
    else
      record.errors.add(attribute, :invalid)
    end
  end

  private

  def valid_format?(value)
    EMAIL_REGEX.match?(value)
  end

  # Very simplistic but we see these typos quite frequently
  def domain_typo?(value)
    domain = value.rpartition('@').last.downcase

    # Gmail domain typos
    if domain.start_with?('gmai', 'goog')
      return VALID_GMAIL_DOMAINS.exclude?(domain)
    end

    # Hotmail domain typos
    if domain.start_with?('hotm')
      return VALID_HOTMAIL_DOMAINS.exclude?(domain)
    end

    COMMON_DOMAIN_TYPOS.include?(domain)
  end
end
