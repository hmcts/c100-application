module Steps
  module Shared
    class UnderAgeForm < BaseForm
      attribute :under_age, Boolean

      validates_presence_of :under_age

      def persist!
        raise C100ApplicationNotFound unless c100_application

        applicant = c100_application.applicants.find_or_initialize_by(id: record_id)

        applicant.update(
          under_age: under_age
        )
      end
    end
  end
end
