class AddApplicationStatusField < ActiveRecord::Migration[5.1]
  def change
    add_column :c100_applications, :status, :integer, default: 0
    add_index  :c100_applications, :status
  end
end
