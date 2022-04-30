class RemoveHelpPayingAttribute < ActiveRecord::Migration[5.1]
  def change
    remove_column :c100_applications, :help_paying, :string
  end
end
