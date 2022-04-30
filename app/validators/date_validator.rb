class DateValidator < ActiveModel::EachValidator
  def validate_each(record, input_attribute, value)
    return if value.blank? || !value.is_a?(Array)
    set_values = value.values_at(1, 2, 3)
    return if set_values.all?(&:blank?) || set_values.all?(&:zero?)
    Date.new(*set_values)
  rescue ArgumentError
    attribute = input_attribute.to_s.delete_prefix('input_').to_sym
    record.errors.add(attribute, :invalid)
  end
end
