class AdrExemptions < ValueObject
  VALUES = [
    PREVIOUS_ADR = [
      new(:previous_attendance),
      new(:ongoing_attendance),
      new(:existing_proceedings_attendance),
    ].freeze,

    PREVIOUS_MIAM = [
      new(:previous_exemption),
      new(:existing_proceedings_exemption),
    ].freeze,

    ADR_NONE = new(:adr_none)
  ].flatten.freeze

  # :nocov:
  def self.values
    VALUES
  end
  # :nocov:
end
