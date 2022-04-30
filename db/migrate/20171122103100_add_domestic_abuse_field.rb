class AddDomesticAbuseField < ActiveRecord::Migration[5.0]
  def change
    add_column :c100_applications, :domestic_abuse, :string
  end
end
