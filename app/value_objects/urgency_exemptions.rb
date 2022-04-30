class UrgencyExemptions < ValueObject
  VALUES = [
    RISK_APPLICANT = new(:risk_applicant),
    UNREASONABLE_HARDSHIP = new(:unreasonable_hardship),
    RISK_CHILDREN = new(:risk_children),
    RISK_UNLAWFUL_REMOVAL_RETENTION = new(:risk_unlawful_removal_retention),
    MISCARRIAGE_JUSTICE = new(:miscarriage_justice),
    IRRETRIEVABLE_PROBLEMS = new(:irretrievable_problems),
    INTERNATIONAL_PROCEEDINGS = new(:international_proceedings),

    URGENCY_NONE = new(:urgency_none)
  ].flatten.freeze

  # :nocov:
  def self.values
    VALUES
  end
  # :nocov:
end
