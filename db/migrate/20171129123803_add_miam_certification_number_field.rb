class AddMiamCertificationNumberField < ActiveRecord::Migration[5.0]
  def change
    add_column :c100_applications, :miam_certification_number, :string
  end
end
