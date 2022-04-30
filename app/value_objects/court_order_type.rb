class CourtOrderType < ValueObject
  VALUES = [
    NON_MOLESTATION = new(:non_molestation),
    OCCUPATION = new(:occupation),
    FORCED_MARRIAGE_PROTECTION = new(:forced_marriage_protection),
    RESTRAINING = new(:restraining),
    INJUNCTIVE = new(:injunctive),
    UNDERTAKING = new(:undertaking),
  ].freeze

  def self.values
    VALUES
  end
end
