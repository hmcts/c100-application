module CourtContactDetails
  extend ActiveSupport::Concern

  # Find a Court or Tribunal - URL used for user-facing access.
  # For API access, refer to `services/c100_app/courtfinder_api.rb`
  FACT_COURT_BASE_URL = 'https://www.find-court-tribunal.service.gov.uk/courts/'.freeze

  CENTRAL_HUB_EMAIL = 'C100applications@justice.gov.uk'.freeze
  CENTRAL_HUB_ADDRESS = [
    'C100 Applications',
    'PO Box 1792',
    'Southampton',
    'SO15 9GG',
    'DX: 135986 Southampton 32',
  ].freeze

  def centralised?
    centralised_slugs.include?(slug)
  end

  def url
    URI.join(FACT_COURT_BASE_URL, slug).to_s
  end

  def full_address
    return CENTRAL_HUB_ADDRESS if centralised?

    # If the court is not yet centralised we default to its postal address
    [
      name,
      address.fetch_values(
        'address_lines',
        'town',
        'postcode',
      )
    ].flatten.reject(&:blank?).uniq
  end

  def documents_email
    return CENTRAL_HUB_EMAIL if centralised?

    # If the court is not yet centralised we default to its email address
    email
  end

  private

  def centralised_slugs
    Rails.configuration.court_slugs.fetch('centralisation')
  end
end
