class Court
  attr_reader :name, :slug, :email, :address

  # Using `fetch` so an exception is raised and we are alerted if the json
  # schema ever changes, instead of silently let the user continue, as all
  # details are needed for the application to progress
  #
  def initialize(data)
    @name = data.fetch('name')
    @slug = data.fetch('slug')
    @address = data.fetch('address')
    # The email, if not already present, comes from a separate API request
    @email = data['email'] || best_enquiries_email
  rescue StandardError => ex
    log_and_raise(ex, data)
  end

  def full_address
    [
      name,
      address.fetch_values(
        'address_lines',
        'town',
        'postcode',
      )
    ].flatten.reject(&:blank?).uniq
  end

  def best_enquiries_email
    # There's no consistency to how courts list their email address descriptions,
    # so we try to find the most suitable email address, by looking at the `description`
    # or the `explanation` for each of the emails, and if none found, use the first one

    emails = retrieve_emails_from_api
    best = best_match_for(emails, 'description') || best_match_for(emails, 'explanation') || emails.first

    # We want this to raise a `KeyError` exception when no email is found
    best ||= {}
    best.fetch('address')
  end

  private

  def best_match_for(emails, node)
    emails.find { |e| e[node] =~ /children/i }           || \
      emails.find { |e| e[node] =~ /\Aapplications\z/i } || \
      emails.find { |e| e[node] =~ /family/i }
  end

  def retrieve_emails_from_api
    this_court = C100App::CourtfinderAPI.new.court_lookup(slug)
    this_court.fetch('emails')
  end

  def log_and_raise(exception, data)
    Raven.extra_context(data: data)
    Raven.capture_exception(exception)
    raise
  end
end
