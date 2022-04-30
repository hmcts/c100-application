module SessionHandling
  extend ActiveSupport::Concern

  included do
    before_action :ensure_session_validity
    helper_method :session_expire_in_minutes
  end

  def session_expire_in_minutes
    Rails.configuration.x.session.expires_in_minutes
  end

  def session_expire_in_seconds
    session_expire_in_minutes * 60
  end

  private

  def ensure_session_validity
    epoch = Time.now.to_i

    if epoch - session.fetch(:last_seen, epoch) > session_expire_in_seconds
      reset_session
    end

    session[:last_seen] = epoch
  end
end
