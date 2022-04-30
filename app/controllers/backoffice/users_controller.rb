module Backoffice
  class UsersController < Backoffice::ApplicationController
    include Auth0Secured

    skip_before_action :logged_in_using_omniauth?, only: [:exists]
    before_action :authenticate, only: [:exists]

    def index
      @admins = BackofficeUser.active.order(email: :asc)
    end

    # This endpoint is used by an Auth0 rule to ensure the user signin-in to the
    # backoffice have been granted access.
    # To minimise bad actors hitting this endpoint, we use a bearer token.
    # Refer to the rule for details: `config/auth0/rules/check_user_exists.js`
    #
    def exists
      email = params[:id]
      user = BackofficeUser.where("LOWER(email) = ?", email.downcase).first

      if user.nil?
        process_forbidden(email)
        head(404)
      else
        process_login(user)
        head(200)
      end
    end

    private

    def process_login(user)
      user.logins_count += 1
      user.last_login_at = user.current_login_at
      user.current_login_at = Time.now.utc
      user.save

      audit!(author: user.email, action: :login)
    end

    def process_forbidden(email)
      audit!(author: email, action: :forbidden)
    end

    def authenticate
      authenticate_or_request_with_http_token do |token|
        ActiveSupport::SecurityUtils.secure_compare(token, ENV['AUTH0_RULES_BEARER_TOKEN'])
      end
    end
  end
end
