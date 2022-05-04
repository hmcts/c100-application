class AddResearchConsentFields < ActiveRecord::Migration[5.2]
  def change
    add_column :c100_applications, :research_consent, :string
    add_column :c100_applications, :research_consent_email, :string
  end
end
