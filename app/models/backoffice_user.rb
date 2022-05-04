class BackofficeUser < ApplicationRecord
  attribute :email, NormalisedEmailType.new
  validates :email, email: true, allow_blank: false

  scope :active, -> { where(active: true) }
end
