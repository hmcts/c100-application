class AuditHelper
  attr_reader :c100_application
  alias_attribute :c100, :c100_application

  PERMISSION_NOT_REQUIRED = 'not_required'.freeze

  def initialize(c100_application)
    @c100_application = c100_application
  end

  # rubocop:disable Metrics/AbcSize
  def metadata
    {
      v: c100.version,
      postcode: postcode,
      centralised: court.centralised?,
      c1a_form: c100.has_safety_concerns?,
      c8_form: c100.confidentiality_enabled?,
      under_age: c100.applicants.under_age?,
      children_sgo: c100.children.with_special_guardianship_order?,
      relationships: relationships_to_children,
      saved_for_later: c100.user_id.present?,
      consent_order: c100.consent_order,
      legal_representation: c100.has_solicitor,
      urgent_hearing: c100.urgent_hearing,
      without_notice: c100.without_notice,
      permission_sought: c100_application.permission_sought || PERMISSION_NOT_REQUIRED,
      reduced_litigation: c100.reduced_litigation_capacity,
      payment_type: c100.payment_type,
      signee_capacity: c100.declaration_signee_capacity,
      arrangements: arrangements_metadata,
      payment_details: payment_metadata,
    }
  end
  # rubocop:enable Metrics/AbcSize

  private

  def court
    @_court ||= c100.court
  end

  def arrangement
    @_arrangement ||= c100.court_arrangement
  end

  def postcode
    # We blind a bit the postcode to anonymize it
    postcode = c100.children_postcode
    postcode.sub(/\s+/, '').upcase.at(0..-3) + '**'
  end

  def arrangements_metadata
    return [] unless arrangement.present?

    [].tap do |options|
      options << 'intermediary' if arrangement.intermediary_help.eql?(GenericYesNo::YES.to_s)
      options << arrangement.language_options
      options << arrangement.special_arrangements
      options << arrangement.special_assistance
    end.flatten
  end

  # Applicant(s) relation to the main child(ren), removing repetitions, i.e. ["father", "other"]
  def relationships_to_children
    Relationship.distinct.where(
      person_id: c100.applicant_ids, minor_id: c100.child_ids
    ).pluck(:relation)
  end

  def payment_metadata
    return {} unless c100.online_payment?

    {
      gbs_code: court.gbs,
      payment_id: c100.payment_intent.payment_id,
    }
  end
end
