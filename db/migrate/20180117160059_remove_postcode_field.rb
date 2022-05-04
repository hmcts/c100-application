class RemovePostcodeField < ActiveRecord::Migration[5.1]
  def change
    remove_column :people, :postcode, :string
  end
end
