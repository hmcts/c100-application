class ProtectionExemptions < ValueObject
  VALUES = [
    AUTHORITY_INVOLVEMENT = [
      new(:authority_enquiring),
      new(:authority_protection_order),
    ].freeze,

    PROTECTION_NONE = new(:protection_none)
  ].flatten.freeze

  # :nocov:
  def self.values
    VALUES
  end
  # :nocov:
end
