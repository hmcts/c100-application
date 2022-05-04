class AddSolicitorFields < ActiveRecord::Migration[5.1]
  def change
    add_column :c100_applications, :has_solicitor, :string
  end
end
