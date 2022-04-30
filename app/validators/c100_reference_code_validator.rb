class C100ReferenceCodeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors.add(attribute, :invalid) unless value.to_s.match?(C100Application::REFERENCE_CODE_FORMAT)
  end
end
