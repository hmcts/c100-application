# :nocov:
class ActionDispatch::Routing::Mapper
  def edit_step(name, opts = {}, &block)
    resource name,
             only:       opts.fetch(:only, [:edit, :update]),
             controller: name,
             path_names: { edit: '' } do; block.call if block_given?; end
  end

  def crud_step(name, opts = {})
    edit_step name, opts do
      resources only: opts.fetch(:only, [:edit, :update, :destroy]),
                controller: name,
                path_names: { edit: '' }
    end
  end

  def show_step(name)
    resource name,
             only:       [:show],
             controller: name
  end

  def edit_routes(path)
    get   path, action: :edit
    put   path, action: :update
    patch path, action: :update
  end
end
# :nocov:

Rails.application.routes.draw do
  constraints host: 'c100.service.justice.gov.uk' do
    get '/(*path)' => redirect(
      ShortUrlExpander.new('https://apply-to-court-about-child-arrangements.service.justice.gov.uk'), status: 302
    )
  end

  # Back office
  namespace :backoffice do
    get '/', to: 'auth0#index'

    # Sidekiq Web UI (when signed in)
    constraints ->(req) { req.session[:backoffice_userinfo].present? } do
      require 'sidekiq/web'
      mount Sidekiq::Web => '/sidekiq'
    end

    # Sidekiq Web UI fallback when signed out
    get :sidekiq, to: redirect(path: '/backoffice', status: 307)

    namespace :auth0 do
      get :callback
      get :failure
      post :local_auth
      delete :logout
    end

    resources :users, only: [:index] do
      get :exists, on: :member, constraints: { id: /[^\/]+/ }
    end

    resource :errors, only: [] do
      get :unhandled
    end

    # Auth0-protected routes
    resources :dashboard, only: [:index] do
      post :lookup, on: :collection
      put :complete_application
    end

    resources :emails, only: [:index] do
      post :lookup, on: :collection
      put :resend
    end

    resources :audit, only: [:index]
  end

  devise_for :users,
             controllers: {
               registrations: 'users/registrations',
               passwords: 'users/passwords',
               sessions: 'users/logins'
             },
             path_names: {
               sign_in: 'login',
               sign_out: 'logout'
             }

  namespace :users do
    devise_scope :user do
      get 'login/logged_out',        to: 'logins#logged_out'
      get 'login/save_confirmation', to: 'logins#save_confirmation'

      get 'password/reset_sent',         to: 'passwords#reset_sent'
      get 'password/reset_confirmation', to: 'passwords#reset_confirmation'

      get 'registration/save_confirmation',   to: 'registrations#save_confirmation'
      get 'registration/update_confirmation', to: 'registrations#update_confirmation'
    end

    resources :drafts, only: [:index, :destroy] do
      get :resume, on: :member
    end
  end

  namespace :steps do
    namespace :opening do
      show_step :start
      show_step :warning
      edit_step :postcode
      show_step :error_but_continue
      show_step :no_court_found
      edit_step :research_consent
      edit_step :consent_order
      show_step :consent_order_sought
      edit_step :child_protection_cases
      show_step :child_protection_info
    end
    namespace :application do
      edit_step :previous_proceedings
      edit_step :court_proceedings
      edit_step :urgent_hearing
      edit_step :urgent_hearing_details
      edit_step :without_notice
      edit_step :without_notice_details
      edit_step :permission_sought
      edit_step :permission_details
      edit_step :details
      edit_step :litigation_capacity
      edit_step :litigation_capacity_details
      edit_step :submission
      show_step :receipt_email_check
      edit_step :payment
      edit_step :check_your_answers do
        get :resume, action: :resume
      end
    end
    namespace :petition do
      edit_step :orders
      show_step :playback
      edit_step :protection
    end
    namespace :miam do
      edit_step :acknowledgement
      edit_step :attended
      edit_step :mediator_exemption
      edit_step :exemption_claim
      edit_step :certification
      show_step :certification_exit
      edit_step :certification_date
      edit_step :certification_details
      show_step :certification_confirmation
    end
    namespace :miam_exemptions do
      edit_step :domestic
      edit_step :protection
      edit_step :urgency
      edit_step :adr
      edit_step :misc
      show_step :reasons_playback
      show_step :safety_playback
      show_step :exit_page
    end
    namespace :abduction do
      edit_step :international
      edit_step :children_have_passport
      edit_step :passport_details
      edit_step :previous_attempt
      edit_step :previous_attempt_details
      edit_step :risk_details
    end
    namespace :safety_questions do
      show_step :start
      edit_step :address_confidentiality
      edit_step :risk_of_abduction
      edit_step :substance_abuse
      edit_step :children_abuse
      edit_step :domestic_abuse
      edit_step :other_abuse
    end
    namespace :abuse_concerns do
      show_step :start
      show_step :children_info
      show_step :applicant_info
      edit_step :question do
        get '/:subject/:kind', action: :edit
      end
      edit_step :details do
        get '/:subject/:kind', action: :edit
      end
      edit_step :contact
    end
    namespace :court_orders do
      edit_step :has_orders
      edit_step :details
    end
    namespace :alternatives do
      show_step :start
      edit_step :negotiation_tools
      edit_step :mediation
      edit_step :lawyer_negotiation
      edit_step :collaborative_law
      edit_step :court
    end
    namespace :address do
      crud_step :lookup, only: [:edit, :update]
      crud_step :results, only: [:edit, :update]
    end
    namespace :children do
      crud_step :names
      crud_step :personal_details, only: [:edit, :update]
      crud_step :orders, only: [:edit, :update]
      crud_step :special_guardianship_order, only: [:edit, :update]
      edit_step :additional_details
      edit_step :has_other_children
      crud_step :residence, only: [:edit, :update]
    end
    namespace :other_children do
      crud_step :names
      crud_step :personal_details, only: [:edit, :update]
    end
    namespace :applicant do
      crud_step :names
      crud_step :personal_details, only: [:edit, :update]
      crud_step :under_age,        only: [:edit, :update]
      crud_step :contact_details,  only: [:edit, :update]
      crud_step :address_details,  only: [:edit, :update]
      edit_step :has_solicitor
      edit_step :relationship, only: [] do
        edit_routes ':id/child/:child_id'
      end
    end
    namespace :solicitor do
      edit_step :personal_details
      edit_step :address_details
      edit_step :contact_details
    end
    namespace :respondent do
      crud_step :names
      crud_step :personal_details, only: [:edit, :update]
      crud_step :contact_details,  only: [:edit, :update]
      crud_step :address_details,  only: [:edit, :update]
      edit_step :has_other_parties
      edit_step :relationship, only: [] do
        edit_routes ':id/child/:child_id'
      end
    end
    namespace :other_party do
      crud_step :names
      crud_step :personal_details, only: [:edit, :update]
      crud_step :address_details,  only: [:edit, :update]
      edit_step :relationship, only: [] do
        edit_routes ':id/child/:child_id'
      end
    end
    namespace :permission do
      namespace :question, path: ':question_name' do
        edit_routes 'relationship/:relationship_id'
      end
    end
    namespace :international do
      edit_step :resident
      edit_step :jurisdiction
      edit_step :request
    end
    namespace :attending_court do
      edit_step :language
      edit_step :intermediary
      edit_step :special_arrangements
      edit_step :special_assistance
    end
    namespace :completion do
      show_step :confirmation
      show_step :what_next
      show_step :summary
      # The following is an alias of the `what_next` route, for analytics tracking
      get :how_to_submit, to: 'what_next#show'
    end
  end

  resource :session, only: [:destroy] do
    member do
      get :ping
      post :bypass_postcode
      post :bypass_to_cya
    end
  end

  resource :callbacks, only: [] do
    post :notify
  end

  resources :payments, only: [] do
    get :validate, on: :member
  end

  resource :errors, only: [] do
    get :invalid_session
    get :application_not_found
    get :application_screening
    get :application_completed
    get :payment_error
    get :unhandled
    get :not_found
  end

  resource :cookies,
           path: '/about/cookies',
           path_names: { edit: '/' },
           only: [:edit, :update, :create]

  root 'steps/opening/start#show'

  get 'about/accessibility'
  get 'about/contact'
  get 'about/privacy'
  get 'about/terms_and_conditions'
  get 'about/privacy_consent'
  get 'about/miam_exemptions'

  # This route is used in court emails to point users to the survey
  get :survey, to: redirect(Rails.configuration.surveys[:success], status: 302)

  # Health and ping endpoints (`status` and `health` are alias)
  defaults format: :json do
    get :status, to: 'status#index'
    get :health, to: 'status#index'
    get :ping,   to: 'status#ping'
  end

  # catch-all route
  # :nocov:
  match '*path', to: 'errors#not_found', via: :all, constraints:
    lambda { |_request| !Rails.application.config.consider_all_requests_local }
  # :nocov:
end
