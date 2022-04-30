class AddHasOtherPartiesField < ActiveRecord::Migration[5.0]
  def change
    add_column :c100_applications, :has_other_parties, :string
  end
end
