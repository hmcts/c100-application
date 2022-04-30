class RenameRelationshipsForeignKey < ActiveRecord::Migration[5.1]
  def change
    rename_column :relationships, :child_id, :minor_id
  end
end
