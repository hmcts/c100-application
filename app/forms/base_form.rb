class BaseForm
  class C100ApplicationNotFound < RuntimeError; end

  include Virtus.model
  include ActiveModel::Validations
  include FormAttributeMethods
  extend ActiveModel::Callbacks

  attr_accessor :c100_application
  attr_accessor :record

  # This will allow subclasses to define after_initialize callbacks
  # and is needed for some functionality to work, i.e. acts_as_gov_uk_date
  define_model_callbacks :initialize

  def initialize(*)
    run_callbacks(:initialize) { super }
  end

  # Initialize a new form object given an AR model, setting its attributes
  def self.build(record, c100_application: nil)
    raise "expected `ApplicationRecord`, got `#{record.class}`" unless record.is_a?(ApplicationRecord)

    attributes = attributes_map(record)

    attributes.merge!(
      c100_application: c100_application || record,
      record: record
    )

    new(attributes)
  end

  def save
    if valid?
      persist!
    else
      false
    end
  end

  # This is a `save if you can, but it's fine if not` method, bypassing validations
  def save!
    persist!
  rescue StandardError
    false
  end

  def to_key
    # Intentionally returns nil so the form builder picks up _only_
    # the class name to generate the HTML attributes.
    nil
  end

  def persisted?
    false
  end

  def new_record?
    true
  end

  private

  def record_id
    record&.id
  end

  # When using concerns like `HasOneAssociationForm` or `SingleQuestionForm`, this ensures
  # a common interface to always have the correct record being updated in the `persist!` method.
  # The default is the main model, i.e. `c100_application` unless overridden by subclasses.
  def record_to_persist
    c100_application
  end

  # :nocov:
  def persist!
    raise 'Subclasses of BaseForm need to implement #persist!'
  end
  # :nocov:
end
