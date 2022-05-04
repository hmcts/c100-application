class AbuseConcern < ApplicationRecord
  belongs_to :c100_application

  has_value_object :subject,           class_name: 'AbuseSubject'
  has_value_object :kind,              class_name: 'AbuseType'
  has_value_object :answer,            class_name: 'GenericYesNo'
  has_value_object :behaviour_ongoing, class_name: 'GenericYesNo'
  has_value_object :asked_for_help,    class_name: 'GenericYesNo'
  has_value_object :help_provided,     class_name: 'GenericYesNo'

  # Using UUIDs as the record IDs. We can't trust sequential ordering by ID.
  default_scope { order(created_at: :asc) }
end
