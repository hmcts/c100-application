class MultiParamDate < Virtus::Attribute
  #
  # Used to coerce a Rails multi parameter date into a standard date.
  # Works together with method `#normalise_date_attributes!`
  # in `controllers/step_controller.rb`
  #
  def coerce(value)
    return value unless value.is_a?(Array)

    set_values = value.values_at(1, 2, 3) # index 0 not in use
    return if set_values.any?(&:nil?)
    return if set_values.all?(&:zero?)

    Date.new(*set_values)
  rescue ArgumentError
    nil
  end
end
