class CrudStepController < StepController
  private

  # :nocov:
  def names_form_class
    raise 'implement in subclasses if needed'
  end

  def record_collection
    raise 'implement in subclasses'
  end
  # :nocov:

  def current_record
    @_current_record ||= record_collection.find_or_initialize_by(id: params[:id])
  end

  def set_existing_records
    @existing_records = record_collection.persisted
  end
end
