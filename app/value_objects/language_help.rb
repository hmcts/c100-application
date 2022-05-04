class LanguageHelp < ValueObject
  VALUES = [
    LANGUAGE_INTERPRETER      = new(:language_interpreter),
    SIGN_LANGUAGE_INTERPRETER = new(:sign_language_interpreter),
    WELSH_LANGUAGE            = new(:welsh_language),
  ].freeze

  # :nocov:
  def self.values
    VALUES
  end
  # :nocov:
end
