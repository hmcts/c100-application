class CreateExemptionsTable < ActiveRecord::Migration[5.1]
  def change
    create_table :exemptions, id: :uuid do |t|
      t.boolean :group_police, default: false
      t.boolean :police_arrested, default: false
      t.boolean :police_caution, default: false
      t.boolean :police_ongoing_proceedings, default: false
      t.boolean :police_conviction, default: false
      t.boolean :police_dvpn, default: false

      t.boolean :group_court, default: false
      t.boolean :court_bound_over, default: false
      t.boolean :court_protective_injunction, default: false
      t.boolean :court_undertaking, default: false
      t.boolean :court_finding_of_fact, default: false
      t.boolean :court_expert_report, default: false

      t.boolean :group_specialist, default: false
      t.boolean :specialist_examination, default: false
      t.boolean :specialist_referral, default: false

      t.boolean :group_local_authority, default: false
      t.boolean :local_authority_marac, default: false
      t.boolean :local_authority_la_ha, default: false
      t.boolean :local_authority_public_authority, default: false

      t.boolean :group_da_service, default: false
      t.boolean :da_service_idva, default: false
      t.boolean :da_service_isva, default: false
      t.boolean :da_service_organisation, default: false
      t.boolean :da_service_refuge_refusal, default: false

      t.boolean :right_to_remain, default: false
      t.boolean :financial_abuse, default: false

      t.boolean :safety_none, default: false

      t.boolean :group_risk, default: false
      t.boolean :risk_applicant, default: false
      t.boolean :risk_unreasonable_hardship, default: false
      t.boolean :risk_children, default: false
      t.boolean :risk_unlawful_removal_retention, default: false

      t.boolean :group_miscarriage, default: false
      t.boolean :miscarriage_justice, default: false
      t.boolean :miscarriage_irretrievable_problems, default: false

      t.boolean :urgency_none, default: false
    end

    add_reference :exemptions, :c100_application, type: :uuid, foreign_key: true
  end
end
