class CourtDeliveryJob < ApplicationJob
  queue_as :submissions

  def perform(c100_application)
    C100App::CourtOnlineSubmission.new(c100_application).process
  end
end
