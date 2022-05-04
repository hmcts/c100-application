class AddDeclarationConfirmationToC100Application < ActiveRecord::Migration[5.2]
  def change
    add_column :c100_applications, :declaration_confirmation, :string
  end
end
