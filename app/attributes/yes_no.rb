class YesNo < Virtus::Attribute
  def coerce(value)
    case value
    when String, Symbol
      GenericYesNo.new(value)
    when GenericYesNo
      value
    end
  end
end
