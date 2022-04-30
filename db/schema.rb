# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_04_11_170515) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "abduction_details", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "children_have_passport"
    t.string "passport_office_notified"
    t.string "children_multiple_passports"
    t.text "passport_possession_other_details"
    t.string "previous_attempt"
    t.text "previous_attempt_details"
    t.string "previous_attempt_agency_involved"
    t.text "previous_attempt_agency_details"
    t.text "risk_details"
    t.uuid "c100_application_id"
    t.text "current_location"
    t.string "passport_possession", default: [], array: true
    t.index ["c100_application_id"], name: "index_abduction_details_on_c100_application_id", unique: true
  end

  create_table "abuse_concerns", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "subject"
    t.string "kind"
    t.string "answer"
    t.text "behaviour_description"
    t.string "behaviour_start"
    t.string "behaviour_ongoing"
    t.string "behaviour_stop"
    t.string "asked_for_help"
    t.string "help_party"
    t.string "help_provided"
    t.text "help_description"
    t.uuid "c100_application_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["c100_application_id"], name: "index_abuse_concerns_on_c100_application_id"
  end

  create_table "backoffice_audit_records", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "author", null: false
    t.string "action", null: false
    t.json "details", default: {}
    t.index ["author"], name: "index_backoffice_audit_records_on_author"
  end

  create_table "backoffice_users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email", null: false
    t.boolean "active", default: true
    t.integer "logins_count", default: 0
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.index ["email"], name: "index_backoffice_users_on_email", unique: true
  end

  create_table "c100_applications", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "navigation_stack", default: [], array: true
    t.uuid "user_id"
    t.string "user_type"
    t.string "hwf_reference_number"
    t.string "children_known_to_authorities"
    t.text "children_known_to_authorities_details"
    t.string "children_protection_plan"
    t.text "children_protection_plan_details"
    t.string "has_court_orders"
    t.string "concerns_contact_type"
    t.string "concerns_contact_other"
    t.string "children_previous_proceedings"
    t.string "risk_of_abduction"
    t.string "substance_abuse"
    t.text "substance_abuse_details"
    t.string "children_abuse"
    t.string "domestic_abuse"
    t.string "other_abuse"
    t.boolean "miam_acknowledgement"
    t.string "miam_attended"
    t.string "miam_certification"
    t.string "alternative_negotiation_tools"
    t.string "alternative_mediation"
    t.string "alternative_lawyer_negotiation"
    t.string "alternative_collaborative_law"
    t.date "miam_certification_date"
    t.string "miam_certification_number"
    t.string "has_other_children"
    t.string "has_other_parties"
    t.string "address_confidentiality"
    t.boolean "court_acknowledgement"
    t.string "without_notice"
    t.text "without_notice_details"
    t.string "without_notice_frustrate"
    t.text "without_notice_frustrate_details"
    t.string "without_notice_impossible"
    t.text "without_notice_impossible_details"
    t.string "international_resident"
    t.string "international_jurisdiction"
    t.text "international_jurisdiction_details"
    t.string "international_request"
    t.text "international_request_details"
    t.string "reduced_litigation_capacity"
    t.text "participation_capacity_details"
    t.text "participation_referral_or_assessment_details"
    t.text "participation_other_factors_details"
    t.string "consent_order"
    t.string "child_protection_cases"
    t.text "application_details"
    t.string "miam_certification_service_name"
    t.string "miam_certification_sole_trader_name"
    t.string "miam_exemption_claim"
    t.string "orders", default: [], array: true
    t.text "orders_additional_details"
    t.integer "status", default: 0
    t.string "protection_orders"
    t.text "protection_orders_details"
    t.string "payment_type"
    t.string "solicitor_account_number"
    t.string "submission_type"
    t.string "receipt_email"
    t.string "urgent_hearing"
    t.text "urgent_hearing_details"
    t.string "urgent_hearing_when"
    t.string "urgent_hearing_short_notice"
    t.text "urgent_hearing_short_notice_details"
    t.string "has_solicitor"
    t.integer "version", default: 5
    t.string "declaration_signee"
    t.string "declaration_signee_capacity"
    t.text "international_resident_details"
    t.string "reminder_status"
    t.string "permission_sought"
    t.text "permission_details"
    t.string "children_postcode"
    t.string "court_id"
    t.string "research_consent"
    t.string "research_consent_email"
    t.string "miam_mediator_exemption"
    t.datetime "completed_at"
    t.string "declaration_confirmation"
    t.string "mediation_voucher_scheme"
    t.index ["court_id"], name: "index_c100_applications_on_court_id"
    t.index ["status"], name: "index_c100_applications_on_status"
    t.index ["user_id"], name: "index_c100_applications_on_user_id"
  end

  create_table "child_orders", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid "child_id"
    t.string "orders", default: [], array: true
    t.index ["child_id"], name: "index_child_orders_on_child_id", unique: true
  end

  create_table "child_residences", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "child_id"
    t.string "person_ids", default: [], array: true
    t.index ["child_id"], name: "index_child_residences_on_child_id", unique: true
  end

  create_table "completed_applications_audit", id: false, force: :cascade do |t|
    t.datetime "started_at", null: false
    t.datetime "completed_at", null: false
    t.string "submission_type"
    t.string "court", null: false
    t.string "reference_code", null: false
    t.jsonb "metadata", default: {}, null: false
    t.index ["reference_code"], name: "index_completed_applications_audit_on_reference_code", unique: true
  end

  create_table "court_arrangements", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "language_options", array: true
    t.text "language_interpreter_details"
    t.text "sign_language_interpreter_details"
    t.uuid "c100_application_id"
    t.text "welsh_language_details"
    t.string "intermediary_help"
    t.text "intermediary_help_details"
    t.string "special_arrangements", array: true
    t.text "special_arrangements_details"
    t.string "special_assistance", array: true
    t.text "special_assistance_details"
    t.index ["c100_application_id"], name: "index_court_arrangements_on_c100_application_id", unique: true
  end

  create_table "court_orders", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "non_molestation"
    t.date "non_molestation_issue_date"
    t.string "non_molestation_length"
    t.string "non_molestation_is_current"
    t.string "non_molestation_court_name"
    t.string "occupation"
    t.date "occupation_issue_date"
    t.string "occupation_length"
    t.string "occupation_is_current"
    t.string "occupation_court_name"
    t.string "forced_marriage_protection"
    t.date "forced_marriage_protection_issue_date"
    t.string "forced_marriage_protection_length"
    t.string "forced_marriage_protection_is_current"
    t.string "forced_marriage_protection_court_name"
    t.string "restraining"
    t.date "restraining_issue_date"
    t.string "restraining_length"
    t.string "restraining_is_current"
    t.string "restraining_court_name"
    t.string "injunctive"
    t.date "injunctive_issue_date"
    t.string "injunctive_length"
    t.string "injunctive_is_current"
    t.string "injunctive_court_name"
    t.string "undertaking"
    t.date "undertaking_issue_date"
    t.string "undertaking_length"
    t.string "undertaking_is_current"
    t.string "undertaking_court_name"
    t.uuid "c100_application_id"
    t.string "non_molestation_case_number"
    t.string "occupation_case_number"
    t.string "forced_marriage_protection_case_number"
    t.string "restraining_case_number"
    t.string "injunctive_case_number"
    t.string "undertaking_case_number"
    t.index ["c100_application_id"], name: "index_court_orders_on_c100_application_id"
  end

  create_table "court_proceedings", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "children_names"
    t.string "court_name"
    t.string "case_number"
    t.string "proceedings_date"
    t.text "cafcass_details"
    t.text "order_types"
    t.text "previous_details"
    t.uuid "c100_application_id"
    t.index ["c100_application_id"], name: "index_court_proceedings_on_c100_application_id"
  end

  create_table "courts", id: :string, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", null: false
    t.string "email", null: false
    t.string "gbs", null: false
    t.jsonb "address", default: {}, null: false
    t.integer "cci_code"
  end

  create_table "email_submissions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "to_address"
    t.string "email_copy_to"
    t.datetime "sent_at"
    t.datetime "user_copy_sent_at"
    t.uuid "c100_application_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["c100_application_id"], name: "index_email_submissions_on_c100_application_id", unique: true
  end

  create_table "email_submissions_audit", id: :uuid, default: nil, force: :cascade do |t|
    t.string "to", null: false
    t.string "reference", null: false
    t.string "status", null: false
    t.datetime "created_at", null: false
    t.datetime "completed_at", null: false
    t.datetime "sent_at"
    t.index ["reference"], name: "index_email_submissions_audit_on_reference"
  end

  create_table "miam_exemptions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "domestic", default: [], array: true
    t.string "protection", default: [], array: true
    t.string "urgency", default: [], array: true
    t.string "adr", default: [], array: true
    t.string "misc", default: [], array: true
    t.uuid "c100_application_id"
    t.index ["c100_application_id"], name: "index_miam_exemptions_on_c100_application_id", unique: true
  end

  create_table "payment_intents", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "nonce"
    t.string "payment_id"
    t.uuid "c100_application_id"
    t.jsonb "state", default: {}, null: false
    t.index ["c100_application_id"], name: "index_payment_intents_on_c100_application_id", unique: true
  end

  create_table "people", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "type", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "has_previous_name"
    t.string "previous_name"
    t.string "gender"
    t.date "dob"
    t.boolean "dob_unknown", default: false
    t.string "age_estimate"
    t.string "birthplace"
    t.boolean "address_unknown", default: false
    t.string "home_phone"
    t.boolean "home_phone_unknown", default: false
    t.string "mobile_phone"
    t.boolean "mobile_phone_unknown", default: false
    t.string "email"
    t.boolean "email_unknown", default: false
    t.string "residence_requirement_met"
    t.text "residence_history"
    t.uuid "c100_application_id"
    t.json "address_data", default: {}
    t.string "voicemail_consent"
    t.boolean "under_age"
    t.string "special_guardianship_order"
    t.string "email_provided"
    t.string "residence_keep_private"
    t.string "email_keep_private"
    t.string "phone_keep_private"
    t.string "mobile_keep_private"
    t.boolean "birthplace_unknown", default: false
    t.date "dob_estimate"
    t.index ["c100_application_id"], name: "index_people_on_c100_application_id"
  end

  create_table "relationships", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "relation"
    t.string "relation_other_value"
    t.uuid "minor_id", null: false
    t.uuid "person_id", null: false
    t.uuid "c100_application_id"
    t.string "parental_responsibility"
    t.string "living_order"
    t.string "amendment"
    t.string "time_order"
    t.string "living_arrangement"
    t.string "consent"
    t.string "family"
    t.string "local_authority"
    t.string "relative"
    t.index ["c100_application_id"], name: "index_relationships_on_c100_application_id"
    t.index ["minor_id", "person_id"], name: "index_relationships_on_minor_id_and_person_id", unique: true
  end

  create_table "short_urls", primary_key: "path", id: :string, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "target_url"
    t.string "target_path"
    t.string "utm_source"
    t.string "utm_medium"
    t.string "utm_campaign"
    t.integer "visits", default: 0
  end

  create_table "solicitors", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "full_name"
    t.string "firm_name"
    t.string "reference"
    t.string "dx_number"
    t.string "phone_number"
    t.string "fax_number"
    t.string "email"
    t.uuid "c100_application_id"
    t.json "address_data", default: {}
    t.string "email_provided"
    t.index ["c100_application_id"], name: "index_solicitors_on_c100_application_id", unique: true
  end

  create_table "users", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "abduction_details", "c100_applications"
  add_foreign_key "abuse_concerns", "c100_applications"
  add_foreign_key "c100_applications", "courts"
  add_foreign_key "c100_applications", "users"
  add_foreign_key "child_orders", "people", column: "child_id"
  add_foreign_key "child_residences", "people", column: "child_id"
  add_foreign_key "court_arrangements", "c100_applications"
  add_foreign_key "court_orders", "c100_applications"
  add_foreign_key "court_proceedings", "c100_applications"
  add_foreign_key "email_submissions", "c100_applications"
  add_foreign_key "miam_exemptions", "c100_applications"
  add_foreign_key "payment_intents", "c100_applications"
  add_foreign_key "people", "c100_applications"
  add_foreign_key "relationships", "c100_applications"
  add_foreign_key "relationships", "people"
  add_foreign_key "relationships", "people", column: "minor_id"
  add_foreign_key "solicitors", "c100_applications"
end
