module Auth0Helper
  def admin_signed_in?
    session[:backoffice_userinfo].present?
  end

  def admin_name
    session[:backoffice_userinfo].dig('info', 'name') if admin_signed_in?
  end

  def admin_auth_url
    auth0_bypass_in_local? ? backoffice_auth0_local_auth_path : 'auth/auth0'
  end

  def admin_logout_url
    params = {
      client_id: ENV['AUTH0_CLIENT_ID'],
      returnTo:  backoffice_url
    }

    URI::HTTPS.build(
      host: ENV['AUTH0_DOMAIN'],
      path: '/v2/logout',
      query: params.to_query
    ).to_s
  end

  def auth0_bypass_in_local?
    Rails.env.development? &&
      ENV['AUTH0_BYPASS_LOCALHOST'].present?
  end
end
