class AddCaseTypeToC100Applications < ActiveRecord::Migration[5.0]
  def change
    add_column :c100_applications, :case_type, :string
  end
end
