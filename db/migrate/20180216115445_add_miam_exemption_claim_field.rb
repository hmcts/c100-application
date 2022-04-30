class AddMiamExemptionClaimField < ActiveRecord::Migration[5.1]
  def change
    add_column :c100_applications, :miam_exemption_claim, :string
  end
end
