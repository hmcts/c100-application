class UserType < ValueObject
  VALUES = [
    APPLICANT      = new(:applicant),
    REPRESENTATIVE = new(:representative),
  ].freeze

  def self.values
    VALUES
  end
end
