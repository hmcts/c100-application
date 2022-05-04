class Court < ApplicationRecord
  include CourtContactDetails

  REFRESH_DATA_AFTER = 72.hours
  UNKNOWN_GBS = 'unknown'.freeze

  has_many :c100_applications

  alias_attribute :slug, :id
  alias_attribute :county_location_code, :cci_code

  # Using `fetch` so an exception is raised and we are alerted if the json
  # schema ever changes, instead of silently let the user continue, as all
  # details are needed for the application to progress
  #
  def self.build(data)
    new(
      slug: data.fetch('slug'),
      name: data.fetch('name'),
      address: fetch_address(data),
      cci_code: data.fetch('county_location_code'),
      # Email and GBS code, if not already present, come from a separate API request
      email: data['email'],
      gbs: data['gbs'],
    )
  rescue StandardError => ex
    log_and_raise(ex, data)
  end

  # If this is the first time we see this court (slug) then we create
  # a new record in the `courts` table. If we already have this court,
  # we check if its data has become stale, and if so, we refresh it.
  #
  def self.create_or_refresh(data)
    court = find_or_initialize_by(slug: data.fetch('slug'))

    if court.stale?
      court.slug_will_change! # Touch `updated_at` on save, even if there are no changes

      court.update(
        build(data).attributes.except('created_at', 'updated_at')
      )
    end

    court
  rescue StandardError => ex
    log_and_raise(ex, data)
  end

  def email=(email)
    self[:email] = email || best_enquiries_email
  end

  def gbs=(gbs)
    self[:gbs] = gbs || retrieve_gbs_from_api
  end

  def best_enquiries_email
    # There's no consistency to how courts list their email addresses, so we try to find
    # the most suitable one by looking for keywords.
    #
    # We prioritise the `explanation` field, and look for the `c100` keyword, as many of
    # the courts will have an email entry with the words "Including C100 applications".
    #
    # After that, if no match is found, we look in the address itself, and if no match
    # is found, as a last resort we try to find an email containing the word `enquiries`,
    # and if still nothing is found, we pick the first entry.
    #
    emails = retrieve_emails_from_api
    best = best_match_in_explanation(emails) ||
           best_match_in_address(emails) ||
           fallback_address(emails)

    # We want this to raise a `KeyError` exception when no email is found
    best ||= {}
    best.fetch('address')
  end

  def gbs_known?
    !gbs.eql?(UNKNOWN_GBS)
  end

  def stale?
    updated_at.nil? || updated_at <= REFRESH_DATA_AFTER.ago
  end

  def self.fetch_address(data)
    if data.key?('address')
      data.fetch('address')
    else
      data.fetch('addresses').first
    end
  end

  private

  def best_match_in_address(emails)
    emails.find { |e| e['address'] =~ /c100/i }       || \
      emails.find { |e| e['address'] =~ /family/i }   || \
      emails.find { |e| e['address'] =~ /children/i }
  end

  def best_match_in_explanation(emails)
    emails.find { |e| e['explanation'] =~ /c100/i }
  end

  def fallback_address(emails)
    emails.find { |e| e['address'] =~ /enquiries/i } || emails.first
  end

  def retrieve_gbs_from_api
    court_data.fetch('gbs').presence || UNKNOWN_GBS
  end

  def retrieve_emails_from_api
    court_data.fetch('emails')
  end

  def court_data
    @_court_data ||= C100App::CourtfinderAPI.new.court_lookup(slug)
  end

  def self.log_and_raise(exception, data)
    Raven.extra_context(data: data)
    Raven.capture_exception(exception)
    raise
  end
  private_class_method :log_and_raise
end
