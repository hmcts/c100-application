class Gender < ValueObject
  VALUES = [
    FEMALE      = new(:female),
    MALE        = new(:male),
    UNSPECIFIED = new(:unspecified),
  ].freeze

  def self.values
    VALUES
  end
end
