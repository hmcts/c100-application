class AddConcernsContactFields < ActiveRecord::Migration[5.0]
  def change
    add_column :c100_applications, :concerns_contact_type, :string
    add_column :c100_applications, :concerns_contact_other, :string
  end
end
