class YesNoUnknown < Virtus::Attribute
  def coerce(value)
    case value
    when String, Symbol
      GenericYesNoUnknown.new(value)
    when GenericYesNoUnknown
      value
    end
  end
end
