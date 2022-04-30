class AddDeclarationOfTruthAttributes < ActiveRecord::Migration[5.2]
  def change
    add_column :c100_applications, :declaration_signee, :string
    add_column :c100_applications, :declaration_signee_capacity, :string
  end
end
