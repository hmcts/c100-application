class MigrateDeclarationOfTruth < ActiveRecord::Migration[5.2]
  def up
    remove_column :c100_applications, :declaration_made
    change_column :completed_applications_audit, :metadata, :jsonb, default: {}, null: false

    C100Application.completed.update_all(declaration_signee_capacity: 'applicant')

    # Up until now all applications have been done by the applicant,
    # with no legal representation, so for the sake of maintaining
    # accurate stats we are going to save these details.
    #
    CompletedApplicationsAudit.unscoped.update_all(
      "metadata = jsonb_set(jsonb_set(metadata, '{legal_representation}', to_json('no'::varchar)::jsonb), '{signee_capacity}', to_json('applicant'::varchar)::jsonb)"
    )
  end

  # Most of the stuff we do on the `up`, we do not need to revert on rollback
  def down
    add_column :c100_applications, :declaration_made, :boolean
  end
end
