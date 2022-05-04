class AddDeclarationMadeField < ActiveRecord::Migration[5.1]
  def change
    add_column :c100_applications, :declaration_made, :boolean
  end
end
