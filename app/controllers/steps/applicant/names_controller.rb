module Steps
  module Applicant
    class NamesController < Steps::ApplicantStepController
      include NamesCrudStep
    end
  end
end
