class RemoveEmailConsentFromScreener < ActiveRecord::Migration[5.2]
  def change
    remove_column :screener_answers, :email_consent, :string
    remove_column :screener_answers, :email_address, :string
  end
end
