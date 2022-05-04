class AddVoicemailConsentToPeople < ActiveRecord::Migration[5.2]
  def change
    add_column :people, :voicemail_consent, :string
  end
end
