class AddPermissionFieldsToRelationship < ActiveRecord::Migration[5.2]
  def change
    add_column :relationships, :parental_responsibility, :string
    add_column :relationships, :living_order,            :string
    add_column :relationships, :amendment,               :string
    add_column :relationships, :time_order,              :string
    add_column :relationships, :living_arrangements,     :string
    add_column :relationships, :consent,                 :string
    add_column :relationships, :family,                  :string
    add_column :relationships, :local_authority,         :string
    add_column :relationships, :relative,                :string
  end
end
