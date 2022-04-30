class Person < ApplicationRecord
  include PersonWithAddress

  belongs_to :c100_application
  has_many :relationships, source: :person, dependent: :destroy

  # Using UUIDs as the record IDs. We can't trust sequential ordering by ID
  default_scope { order(created_at: :asc) }

  self.ignored_columns = %w[
    special_guardianship_order
  ]

  def full_name
    [first_name, last_name].compact.join(' ')
  end
end
