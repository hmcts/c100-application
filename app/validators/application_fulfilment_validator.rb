class ApplicationFulfilmentValidator < ActiveModel::Validator
  include Rails.application.routes.url_helpers

  def validate(record)
    validations.each do |validation|
      if (attribute, error, change_path = validation.call(record))
        record.errors.add(attribute, error, change_path: change_path)
      end
    end
  end

  private

  # Individual validations to be added here
  # Errors, when more than one, will maintain this order
  #
  def validations
    [
      ->(record) { [:children, :blank, edit_steps_children_names_path(id: '')] unless record.children.any? },
      ->(record) { [:applicants, :blank, edit_steps_applicant_names_path(id: '')] unless record.applicants.any? },
      ->(record) { [:respondents, :blank, edit_steps_respondent_names_path(id: '')] unless record.respondents.any? },
      ->(record) { [:submission_type, :blank, edit_steps_application_submission_path] unless record.submission_type.present? },
      ->(record) { [:payment_type, :blank, edit_steps_application_payment_path] unless record.payment_type.present? },
    ]
  end
end
