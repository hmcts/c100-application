class AbuseSubject < ValueObject
  VALUES = [
    APPLICANT = new(:applicant),
    CHILDREN  = new(:children)
  ].freeze

  def self.values
    VALUES
  end
end
