class Relation < ValueObject
  VALUES = [
    MOTHER = new(:mother),
    FATHER = new(:father),
    GUARDIAN = new(:guardian),
    SPECIAL_GUARDIAN = new(:special_guardian),
    GRAND_PARENT = new(:grand_parent),
    OTHER = new(:other),
  ].freeze

  def self.values
    VALUES
  end
end
