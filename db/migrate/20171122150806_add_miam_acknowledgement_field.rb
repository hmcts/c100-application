class AddMiamAcknowledgementField < ActiveRecord::Migration[5.0]
  def change
    add_column :c100_applications, :miam_acknowledgement, :boolean
  end
end
