class ValueObject
  attr_reader :value

  def initialize(raw_value)
    raise ArgumentError, 'Raw value must be symbol or implicitly convertible' unless raw_value.respond_to?(:to_sym)
    @value = raw_value.to_sym
    freeze
  end

  def ==(other)
    other.is_a?(self.class) && other.value == value
  end
  alias === ==
  alias eql? ==

  def self.string_values
    values.map(&:to_s)
  end

  def self.sym_values
    values.map(&:to_sym)
  end

  def hash
    [ValueObject, self.class, value].hash
  end

  def to_s
    value.to_s
  end

  def to_sym
    value
  end
end
