module MiamExemptionsForm
  extend ActiveSupport::Concern
  include HasOneAssociationForm

  included do
    has_one_association :miam_exemption
    validate :at_least_one_checkbox_validation
  end

  class_methods do
    attr_accessor :attribute_name, :allowed_values

    def setup_attributes_for(value_object, attribute_name:)
      self.attribute_name = attribute_name
      self.allowed_values = value_object.string_values

      attribute attribute_name, Array[String]
      attribute :exemptions_collection, Array[String]
    end
  end

  # Custom getter and setter so we always have both attributes synced,
  # as one attribute is the main categories and the other are subcategories.
  # Needed to make the revealing check boxes work nice with errors, etc.
  #
  def exemptions_collection
    super | public_send(self.class.attribute_name)
  end

  def exemptions_collection=(values)
    super(Array(values) | Array(public_send(self.class.attribute_name)))
  end

  private

  # We filter out `group_xxx` items, as the purpose of these are to present the exemptions
  # in groups for the user to show/hide them, and are not really an exemption by itself.
  #
  def valid_options
    selected_options.grep_v(/\Agroup_/)
  end

  def selected_options
    exemptions_collection & self.class.allowed_values
  end

  def at_least_one_checkbox_validation
    errors.add(self.class.attribute_name, :blank) unless valid_options.any?
  end

  def persist!
    raise BaseForm::C100ApplicationNotFound unless c100_application

    record_to_persist.update(
      self.class.attribute_name => selected_options
    )
  end
end
