class ApplicantDeliveryJob < ApplicationJob
  queue_as :submissions

  def perform(c100_application)
    C100App::ApplicantOnlineSubmission.new(c100_application).process
  end
end
