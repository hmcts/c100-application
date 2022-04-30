class AddConsentOrderField < ActiveRecord::Migration[5.1]
  def change
    add_column :c100_applications, :consent_order, :string
  end
end
