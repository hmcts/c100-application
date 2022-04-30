module SavepointStep
  extend ActiveSupport::Concern

  included do
    before_action :court_sanity_check
    before_action :mark_in_progress, only: [:update]
    before_action :save_application_for_later, if: :user_signed_in?, only: [:update]
  end

  private

  def court_sanity_check
    raise Errors::ApplicationScreening unless current_c100_application.court.present?
  end

  def mark_in_progress
    current_c100_application.in_progress! if current_c100_application.screening?
  end

  def save_application_for_later
    C100App::SaveApplicationForLater.new(
      current_c100_application, current_user
    ).save
  end
end
