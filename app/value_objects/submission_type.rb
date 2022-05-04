class SubmissionType < ValueObject
  VALUES = [
    ONLINE = new(:online),
    PRINT_AND_POST = new(:print_and_post),
  ].freeze

  def self.values
    VALUES
  end
end
