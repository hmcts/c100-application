class MiscExemptions < ValueObject
  VALUES = [
    NO_RESPONDENT_ADDRESS = new(:no_respondent_address),
    WITHOUT_NOTICE = new(:without_notice),

    GROUP_MIAM_ACCESS = new(:group_miam_access),
    MIAM_ACCESS = [
      new(:no_disabled_facilities),
      new(:no_appointment),
      new(:no_mediator_nearby),
    ].freeze,

    ACCESS_PROHIBITED = new(:access_prohibited),
    NON_RESIDENT = new(:non_resident),
    APPLICANT_UNDER_AGE = new(:applicant_under_age),

    MISC_NONE = new(:misc_none)
  ].flatten.freeze

  # :nocov:
  def self.values
    VALUES
  end
  # :nocov:
end
