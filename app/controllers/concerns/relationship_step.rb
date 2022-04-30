module RelationshipStep
  extend ActiveSupport::Concern

  def edit
    @form_object = Steps::Shared::RelationshipForm.build(
      relationship_record, c100_application: current_c100_application
    )
  end

  def update
    update_and_advance(
      Steps::Shared::RelationshipForm,
      record: relationship_record,
      as: :relationship
    )
  end

  private

  def child_record
    current_c100_application.minors.find(params[:child_id])
  end

  def relationship_record
    current_c100_application.relationships.find_or_initialize_by(
      person: current_record, minor: child_record
    )
  end
end
