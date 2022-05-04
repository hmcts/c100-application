class Child < Minor
  has_one :child_order, dependent: :destroy
  has_one :child_residence, dependent: :destroy

  scope :with_special_guardianship_order, -> { where(special_guardianship_order: GenericYesNo::YES.to_s) }

  def self.with_special_guardianship_order?
    with_special_guardianship_order.any?
  end
end
