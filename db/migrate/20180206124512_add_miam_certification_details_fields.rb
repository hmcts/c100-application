class AddMiamCertificationDetailsFields < ActiveRecord::Migration[5.1]
  def change
    add_column :c100_applications, :miam_certification_service_name, :string
    add_column :c100_applications, :miam_certification_sole_trader_name, :string
  end
end
