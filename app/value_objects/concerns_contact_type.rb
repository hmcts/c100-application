class ConcernsContactType < ValueObject
  VALUES = [
    UNSUPERVISED = new(:unsupervised),
    SUPERVISED   = new(:supervised),
    NONE         = new(:none)
  ].freeze

  def self.values
    VALUES
  end
end
