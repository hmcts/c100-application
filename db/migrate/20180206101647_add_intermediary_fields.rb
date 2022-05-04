class AddIntermediaryFields < ActiveRecord::Migration[5.1]
  def change
    add_column :c100_applications, :intermediary_help, :string
    add_column :c100_applications, :intermediary_help_details, :text
  end
end
