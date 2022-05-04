class AddChildProtectionCasesField < ActiveRecord::Migration[5.1]
  def change
    add_column :c100_applications, :child_protection_cases, :string
  end
end
