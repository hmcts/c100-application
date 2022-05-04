class SpecialAssistance < ValueObject
  VALUES = [
    HEARING_LOOP          = new(:hearing_loop),
    BRAILLE_DOCUMENTS     = new(:braille_documents),
    ADVANCE_COURT_VIEWING = new(:advance_court_viewing),
    OTHER_ASSISTANCE      = new(:other_assistance),
  ].freeze

  # :nocov:
  def self.values
    VALUES
  end
  # :nocov:
end
