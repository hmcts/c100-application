module ArrangementsCheckBoxesForm
  extend ActiveSupport::Concern
  include HasOneAssociationForm

  included do
    has_one_association :court_arrangement
  end

  class_methods do
    attr_accessor :attribute_name, :allowed_values

    def setup_attributes_for(value_object, attribute_name:)
      self.attribute_name = attribute_name
      self.allowed_values = value_object.string_values

      attribute attribute_name, Array[String]

      # Define the query method for each of the attributes
      value_object.values.each do |name|
        define_method("#{name}?") do
          public_send(attribute_name).include?(name.to_s)
        end
      end
    end
  end

  private

  def additional_attributes_map
    {}
  end

  def selected_options
    public_send(self.class.attribute_name) & self.class.allowed_values
  end

  def persist!
    raise BaseForm::C100ApplicationNotFound unless c100_application

    record_to_persist.update(
      attributes_map.merge(
        self.class.attribute_name => selected_options
      ).merge(
        additional_attributes_map
      )
    )
  end
end
