module Backoffice
  class Auth0Controller < Backoffice::ApplicationController
    def index
      redirect_to backoffice_dashboard_index_path if helpers.admin_signed_in?
    end

    def logout
      audit!(action: :logout)
      session.delete(:backoffice_userinfo)

      redirect_to helpers.admin_logout_url
    end

    def callback
      # OmniAuth places the User Profile information (retrieved by omniauth-auth0)
      # in request.env['omniauth.auth'].
      # Refer to https://github.com/auth0/omniauth-auth0#auth-hash for complete
      # information on 'omniauth.auth' contents.
      #
      session[:backoffice_userinfo] = request.env['omniauth.auth']

      redirect_to backoffice_dashboard_index_path
    end

    def local_auth
      raise 'For development use only' unless helpers.auth0_bypass_in_local?

      request.env['omniauth.auth'] = { info: { name: 'Test User' } }
      callback
    end

    def failure
      error = request.env['omniauth.error']

      Raven.capture_exception(
        RuntimeError.new("Auth0 Error: #{error.message}")
      )

      redirect_to backoffice_path, flash: { alert: error.message }
    end
  end
end
