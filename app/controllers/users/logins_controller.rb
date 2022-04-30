module Users
  class LoginsController < Devise::SessionsController
    def save_confirmation
      @email_address = session[:confirmation_email_address]
    end

    def logged_out; end

    protected

    def sign_in(_resource_name, user)
      super
      save_for_later = C100App::SaveApplicationForLater.new(current_c100_application, user)
      save_for_later.save
      session[:confirmation_email_address] = user.email if save_for_later.email_sent?
    end

    # Devise will try to return to a previously login-protected page if available,
    # otherwise this is the fallback route to redirect the user after login
    def signed_in_root_path(_)
      current_c100_application ? users_login_save_confirmation_path : users_drafts_path
    end

    def after_sign_out_path_for(_)
      users_login_logged_out_path
    end
  end
end
