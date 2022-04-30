class AddScreenerEmailConsentAndEmailAddress < ActiveRecord::Migration[5.1]
  def change
    add_column  :screener_answers, :email_consent, :string, null: true
    add_column  :screener_answers, :email_address, :string, null: true

    add_index :screener_answers, :email_consent
    add_index :screener_answers, :email_address
  end
end
