class FullUkPostcodeValidator < ActiveModel::EachValidator
  def parsed_postcode(postcode)
    UKPostcode.parse(postcode)
  end

  def validate_each(record, attribute, value)
    entries = value.to_s.split('\n').reject(&:blank?).compact
    entries.each do |entry|
      record.errors.add(attribute, :invalid) unless parsed_postcode(entry).full_valid?
    end
  end
end
