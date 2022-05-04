module Summary
  module Sections
    class ApplicantRespondent < BaseSectionPresenter
      def name
        :applicant_respondent
      end

      def answers
        [
          FreeTextAnswer.new(:applicants_full_name, c100.applicants.map(&:full_name).join(', ')),
          FreeTextAnswer.new(:respondents_full_name, c100.respondents.map(&:full_name).join(', ')),
        ].select(&:show?)
      end
    end
  end
end
