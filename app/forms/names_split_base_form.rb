class NamesSplitBaseForm < BaseForm
  attribute :names_attributes, Hash
  attribute :new_first_name, StrippedString
  attribute :new_last_name, StrippedString

  validates_presence_of :new_first_name, :new_last_name, if: :first_record?

  validates_presence_of :new_first_name, if: -> { new_last_name.present? },  unless: :first_record?
  validates_presence_of :new_last_name,  if: -> { new_first_name.present? }, unless: :first_record?

  private

  def persist!
    raise C100ApplicationNotFound unless c100_application

    create_new_record
    update_existing_record

    true
  end

  def create_new_record
    return if new_first_name.blank?
    record_collection.create(first_name: new_first_name, last_name: new_last_name)
  end

  def update_existing_record
    names_attributes.each_value do |attrs|
      next if attrs.fetch('first_name').blank? || attrs.fetch('last_name').blank?
      record_collection.update(attrs.fetch('id'), attrs)
    end
  end

  def first_record?
    return if c100_application.nil?
    record_collection.empty?
  end

  # :nocov:
  def record_collection
    raise 'implement in subclasses'
  end
  # :nocov:
end
