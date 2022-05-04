module C100App
  class NavigationStack
    attr_reader :c100_application, :request

    CYA_FUNNEL = %w[
      /steps/application/payment
      /steps/application/check_your_answers
    ].freeze

    FAST_FORWARD_STEPS = [
      %r{^/steps/safety_questions/address_confidentiality$},
      %r{^/steps/abuse_concerns/details.*},
      %r{^/steps/abuse_concerns/contact$},
      %r{^/steps/petition/protection$},
      %r{^/steps/.+/personal_details.*},
      %r{^/steps/.+/address_details.*},
      %r{^/steps/.+/contact_details.*},
      %r{^/steps/children/additional_details$},
      %r{^/steps/application/court_proceedings$},
      %r{^/steps/application/.*details$},
      %r{^/steps/attending_court/.+},
    ].freeze

    def initialize(c100_application, request)
      @c100_application = c100_application
      @request = request
    end

    # This method serves two purposes, related one with another:
    #
    #   1. Set a session flag if a page is visited through the CYA `change` link,
    #      so we can return the user back to the CYA again if possible, but only
    #      if they've already completed all the steps (thus the funnel).
    #
    #   2. Update the `navigation_stack` record attribute, used for the `back` links.
    #      Only if the above session flag is not set, otherwise we would be wiping
    #      parts of the navigation stack when using the "fast forward" functionality.
    #
    def update!
      session[:cya_origin] = CYA_FUNNEL.eql?(
        c100_application.navigation_stack.last(CYA_FUNNEL.size)
      )

      return if fast_forward_to_cya?

      stack_until_current_page = c100_application.navigation_stack.take_while { |path| !path.eql?(current_path) }

      c100_application.navigation_stack = stack_until_current_page + [current_path]
      c100_application.save!(touch: false)
    end

    def fast_forward_to_cya?
      session[:cya_origin] &&
        Regexp.union(FAST_FORWARD_STEPS).match?(current_path)
    end

    private

    def session
      request.session
    end

    def current_path
      request.fullpath
    end
  end
end
