class GenderAttribute < Virtus::Attribute
  def coerce(value)
    case value
    when String, Symbol
      Gender.new(value)
    when Gender
      value
    end
  end
end
