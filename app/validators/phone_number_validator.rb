class PhoneNumberValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors.add(attribute, :invalid) unless /^\+*[0-9() -]+$/.match?((value))
  end
end
