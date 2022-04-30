class GenericYesNoUnknown < ValueObject
  VALUES = [
    YES = new(:yes),
    NO  = new(:no),
    UNKNOWN = new(:unknown)
  ].freeze

  def self.values
    VALUES
  end

  def yes?
    value == :yes
  end

  def no?
    value == :no
  end

  def unknown?
    value == :unknown
  end
end
