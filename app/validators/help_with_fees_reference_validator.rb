class HelpWithFeesReferenceValidator < ActiveModel::EachValidator
  HWF_REFERENCE_REGEX ||= /^HWF([- ])?[[:alnum:]]{3}([- ])?[[:alnum:]]{3}$/i.freeze

  def validate_each(record, attribute, value)
    record.errors.add(attribute, :invalid) unless value.strip.match?(HWF_REFERENCE_REGEX)
  end
end
