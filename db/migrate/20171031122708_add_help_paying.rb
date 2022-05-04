class AddHelpPaying < ActiveRecord::Migration[5.0]
  def change
    add_column :c100_applications, :help_paying, :string
  end
end
