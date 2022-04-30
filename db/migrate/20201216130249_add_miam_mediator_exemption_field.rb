class AddMiamMediatorExemptionField < ActiveRecord::Migration[5.2]
  def change
    add_column :c100_applications, :miam_mediator_exemption, :string
  end
end
