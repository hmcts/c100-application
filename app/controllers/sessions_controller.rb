class SessionsController < ApplicationController
  skip_before_action :ensure_session_validity, only: [:destroy]

  def ping
    head(:no_content)
  end

  def destroy
    reset_session

    respond_to do |format|
      format.html { redirect_to root_path }
      format.json { render json: {} }
    end
  end

  # :nocov:
  def bypass_postcode
    raise 'For development use only' unless helpers.dev_tools_enabled?

    c100_application.update(
      court: find_or_initialize_court,
      status: 1,
    )

    redirect_to edit_steps_opening_consent_order_path
  end

  def bypass_to_cya
    raise 'For development use only' unless helpers.dev_tools_enabled?

    find_or_create_people

    c100_application.update(
      court: find_or_initialize_court,
      status: 1,
      # fill out the first steps, so `save and return` button shows
      # if a value already exists we use it
      consent_order: c100_application.consent_order.presence || 'no',
      child_protection_cases: c100_application.child_protection_cases.presence || 'no',
    )

    redirect_to edit_steps_application_check_your_answers_path
  end
  # :nocov:

  private

  # :nocov:
  def c100_application
    current_c100_application || initialize_c100_application(
      children_postcode: postcode_fixture
    )
  end

  # If there is already a court assigned, we maintain it
  def find_or_initialize_court
    c100_application.court || Court.find_by(slug: slug_fixture) || Court.new(court_fixture)
  end

  def find_or_create_people
    [Child, Applicant, Respondent].each do |klass|
      klass.find_or_initialize_by(c100_application_id: c100_application.id).tap do |record|
        record.update(first_name: record.type, last_name: 'Test') unless record.persisted?
      end
    end
  end

  def postcode_fixture
    'MK9 2DT'.freeze
  end

  def slug_fixture
    'milton-keynes-county-court-and-family-court'.freeze
  end

  def court_fixture
    {
      "slug" => slug_fixture,
      "name" => "Milton Keynes County Court and Family Court",
      "email" => "family@miltonkeynes.countycourt.gsi.gov.uk",
      "gbs" => "Y610",
      "cci_code" => 388,
      "address" => {
        "town" => "Central Milton Keynes",
        "postcode" => "MK9 2DT",
        "address_lines" => ["351 Silbury Boulevard", "Witan Gate East"],
      },
    }
  end
  # :nocov:
end
