require 'rails_helper'

RSpec.describe ApplicationController do
  controller do
    def my_url; true; end
    def invalid_session; raise Errors::InvalidSession; end
    def application_not_found; raise Errors::ApplicationNotFound; end
    def application_completed; raise Errors::ApplicationCompleted; end
    def application_screening; raise Errors::ApplicationScreening; end
    def payment_error; raise Errors::PaymentError; end
    def another_exception; raise Exception; end
  end

  before do
    allow(Rails.application).to receive_message_chain(:config, :consider_all_requests_local).and_return(false)
    allow(Rails.configuration).to receive_message_chain(:x, :session, :expires_in_minutes).and_return(1)
  end

  context 'Security handling' do
    before do
      routes.draw { get 'my_url' => 'anonymous#my_url' }
    end

    context '#drop_dangerous_headers!' do
      it 'removes dangerous headers' do
        request.headers.merge!('HTTP_X_FORWARDED_HOST' => 'foobar.com')
        get :my_url
        expect(request.env).not_to include('HTTP_X_FORWARDED_HOST')
      end
    end

    context 'basic HTTP auth' do
      it 'checks for the ENV variable' do
        expect(ENV).to receive(:key?).with('HTTP_AUTH_ENABLED')
        get :my_url
      end
    end
  end

  context 'Session handling' do
    context 'ensure_session_validity' do
      before do
        travel_to Time.at(555555)
      end

      context 'when cookie is not present' do
        it 'sets the `last_seen` value' do
          routes.draw { get 'my_url' => 'anonymous#my_url' }

          get :my_url
          expect(session[:last_seen]).to eq(555555)
        end

        it 'does not reset the session' do
          routes.draw { get 'my_url' => 'anonymous#my_url' }

          expect(controller).not_to receive(:reset_session)
          get :my_url
        end
      end

      context 'when cookie is present but not expired' do
        before do
          session[:last_seen] = Time.now.to_i
        end

        it 'sets the `last_seen` value' do
          routes.draw { get 'my_url' => 'anonymous#my_url' }

          get :my_url
          expect(session[:last_seen]).to eq(555555)
        end

        it 'does not reset the session' do
          routes.draw { get 'my_url' => 'anonymous#my_url' }

          expect(controller).not_to receive(:reset_session)
          get :my_url
        end
      end

      context 'when cookie is present but expired' do
        before do
          session[:last_seen] = Time.now.to_i - 155
        end

        it 'sets the `last_seen` value' do
          routes.draw { get 'my_url' => 'anonymous#my_url' }

          expect(session[:last_seen]).to eq(555400)
          get :my_url
          expect(session[:last_seen]).to eq(555555)
        end

        it 'resets the session' do
          routes.draw { get 'my_url' => 'anonymous#my_url' }

          expect(controller).to receive(:reset_session)
          get :my_url
        end
      end
    end
  end

  context 'Exceptions handling' do
    context 'Errors::InvalidSession' do
      it 'should not report the exception, and redirect to the error page' do
        routes.draw { get 'invalid_session' => 'anonymous#invalid_session' }

        expect(Raven).not_to receive(:capture_exception)

        get :invalid_session
        expect(response).to redirect_to(invalid_session_errors_path)
      end
    end

    context 'Errors::ApplicationNotFound' do
      it 'should not report the exception, and redirect to the error page' do
        routes.draw { get 'application_not_found' => 'anonymous#application_not_found' }

        expect(Raven).not_to receive(:capture_exception)

        get :application_not_found
        expect(response).to redirect_to(application_not_found_errors_path)
      end
    end

    context 'Errors::ApplicationScreening' do
      it 'should not report the exception, and redirect to the error page' do
        routes.draw { get 'application_screening' => 'anonymous#application_screening' }

        expect(Raven).not_to receive(:capture_exception)

        get :application_screening
        expect(response).to redirect_to(application_screening_errors_path)
      end
    end

    context 'Errors::ApplicationCompleted' do
      it 'should not report the exception, and redirect to the error page' do
        routes.draw { get 'application_completed' => 'anonymous#application_completed' }

        expect(Raven).not_to receive(:capture_exception)

        get :application_completed
        expect(response).to redirect_to(application_completed_errors_path)
      end
    end

    context 'Errors::PaymentError' do
      it 'should report the exception, and redirect to the payment error page' do
        routes.draw { get 'payment_error' => 'anonymous#payment_error' }

        expect(Raven).to receive(:capture_exception).with(
          Errors::PaymentError, tags: { c100_application_id: nil }
        )

        get :payment_error
        expect(response).to redirect_to(payment_error_errors_path)
      end
    end

    context 'Other exceptions' do
      it 'should report the exception, and redirect to the error page' do
        routes.draw { get 'another_exception' => 'anonymous#another_exception' }

        expect(Raven).to receive(:capture_exception)

        get :another_exception
        expect(response).to redirect_to(unhandled_errors_path)
      end
    end
  end
end
