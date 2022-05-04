# Note: this will setup a session-only cookie, which will expire as soon as
# the browser is closed.
#
# While the browser is open, there is a JS mechanism to alert the user if
# there is no activity (i.e. server-side requests) for a prolonged period
# of time (see `config.x.session.expires_in_minutes` and
# `config.x.session.warning_when_remaining` for the time values, and
# `/assets/javascripts/modules/session-timeout.js` for the details).
#
# As we can't rely only on JS, there is also a request-based check to expire
# the session if the cookie is too old (see `/concerns/security_handling.rb`).
#
Rails.application.config.session_store :cookie_store, key: '_c100_application_session'
