module SingleQuestionForm
  extend ActiveSupport::Concern

  module ClassMethods
    attr_accessor :reset_attributes

    private

    def yes_no_attribute(name, reset_when_yes: [], reset_when_no: [])
      attribute name, YesNo
      validates_inclusion_of name, in: GenericYesNo.values

      self.reset_attributes = {
        GenericYesNo::YES => expand_attributes(reset_when_yes),
        GenericYesNo::NO  => expand_attributes(reset_when_no)
      }
    end

    def expand_attributes(attributes)
      attributes.map do |obj|
        obj.is_a?(Symbol) ? obj : obj.attribute_names
      end.flatten.uniq
    end
  end

  private

  def answer
    attributes_map.values.first
  end

  def attributes_to_reset
    Hash[self.class.reset_attributes[answer].collect { |att| [att, nil] }]
  end

  def persist!
    raise BaseForm::C100ApplicationNotFound unless c100_application

    record_to_persist.update(
      attributes_map.merge(attributes_to_reset)
    )
  end
end
