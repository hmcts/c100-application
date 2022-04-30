class AddCourtLocationCode < ActiveRecord::Migration[5.2]
  def change
    add_column :courts, :cci_code, :integer
  end
end
