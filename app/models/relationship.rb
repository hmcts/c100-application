class Relationship < ApplicationRecord
  belongs_to :c100_application

  belongs_to :minor
  belongs_to :person

  # Used in non-parents journey, each being one question that we need
  # to ask in order to decide if permission to apply is required.
  #
  PERMISSION_ATTRIBUTES = %i[
    parental_responsibility
    living_order
    amendment
    time_order
    living_arrangement
    consent
    family
    local_authority
    relative
  ].freeze

  scope :with_permission_data, -> { where.not(PERMISSION_ATTRIBUTES.first => nil) }
end
