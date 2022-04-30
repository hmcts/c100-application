module Summary
  module HtmlSections
    class SolicitorDetails < Sections::BaseSectionPresenter
      def name
        :solicitor_details
      end

      def answers
        [
          Answer.new(:has_solicitor, c100.has_solicitor, change_path: edit_steps_applicant_has_solicitor_path),
          solicitor_personal_details,
          solicitor_address_details,
          solicitor_contact_details,
        ].flatten.select(&:show?)
      end

      private

      def solicitor
        @_solicitor ||= (c100_application.solicitor || Solicitor.new)
      end

      def solicitor_personal_details
        [
          AnswersGroup.new(
            :solicitor_personal_details,
            [
              FreeTextAnswer.new(:solicitor_full_name, solicitor.full_name),
              FreeTextAnswer.new(:solicitor_firm_name, solicitor.firm_name),
              FreeTextAnswer.new(:solicitor_reference, solicitor.reference)
            ],
            change_path: edit_steps_solicitor_personal_details_path
          )
        ]
      end

      def solicitor_address_details
        AnswersGroup.new(
          :solicitor_address_details,
          [
            FreeTextAnswer.new(:solicitor_address, solicitor.full_address),
          ],
          change_path: edit_steps_solicitor_address_details_path
        )
      end

      def solicitor_contact_details
        AnswersGroup.new(
          :solicitor_contact_details,
          [
            FreeTextAnswer.new(:solicitor_email, solicitor.email),
            FreeTextAnswer.new(:solicitor_phone_number, solicitor.phone_number),
            FreeTextAnswer.new(:solicitor_fax_number, solicitor.fax_number),
            FreeTextAnswer.new(:solicitor_dx_number, solicitor.dx_number),
          ],
          change_path: edit_steps_solicitor_contact_details_path
        )
      end
    end
  end
end
