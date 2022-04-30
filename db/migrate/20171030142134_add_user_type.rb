class AddUserType < ActiveRecord::Migration[5.0]
  def change
    add_column :c100_applications, :user_type, :string
  end
end
