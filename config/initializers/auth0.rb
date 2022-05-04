Rails.application.config.middleware.use OmniAuth::Builder do
  provider(
    :auth0,
    ENV['AUTH0_CLIENT_ID'],
    ENV['AUTH0_CLIENT_SECRET'],
    ENV['AUTH0_DOMAIN'],
    callback_path: '/backoffice/auth0/callback',
    authorize_params: {
      scope: 'openid profile'
    }
  )
end

OmniAuth.config.allowed_request_methods = [:post]
OmniAuth.config.on_failure = Backoffice::Auth0Controller.action(:failure)
