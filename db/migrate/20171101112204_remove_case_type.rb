class RemoveCaseType < ActiveRecord::Migration[5.0]
  def change
    remove_column :c100_applications, :case_type
  end
end
