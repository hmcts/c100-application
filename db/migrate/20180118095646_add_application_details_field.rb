class AddApplicationDetailsField < ActiveRecord::Migration[5.1]
  def change
    add_column :c100_applications, :application_details, :text
  end
end
