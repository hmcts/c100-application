require 'spec_helper'

RSpec.describe NotifyMailer, type: :mailer do
  let(:c100_application) {
    C100Application.new(
      id: '4a362e1c-48eb-40e3-9458-a31ead3f30a4',
    )
  }
  let(:user) { instance_double(User, email: 'test@example.com') }

  before do
    allow(c100_application).to receive(:user).and_return(user)

    allow(
      Rails.configuration
    ).to receive(:govuk_notify_templates).and_return(
      reset_password: 'reset_password_template_id',
      change_password: 'change_password_template_id',
      application_saved: 'application_saved_template_id',
      draft_first_reminder: 'draft_first_reminder_template_id',
      draft_last_reminder: 'draft_last_reminder_template_id',
    )
  end

  describe '#application_saved_confirmation' do
    let(:mail) { described_class.application_saved_confirmation(c100_application) }

    it_behaves_like 'a Notify mail', template_id: 'application_saved_template_id'

    it { expect(mail.to).to eq(['test@example.com']) }

    it 'has the right personalisation' do
      expect(mail.govuk_notify_personalisation).to eq({
        service_name: 'Apply to court about child arrangements',
        resume_draft_url: 'https://c100.justice.uk/users/drafts/4a362e1c-48eb-40e3-9458-a31ead3f30a4/resume',
        draft_expire_in_days: 28,
      })
    end
  end

  describe 'draft_first_reminder' do
    let(:mail) { described_class.draft_expire_reminder(c100_application, :draft_first_reminder) }

    it_behaves_like 'a Notify mail', template_id: 'draft_first_reminder_template_id'

    it { expect(mail.to).to eq(['test@example.com']) }

    context 'personalisation' do
      it 'sets the personalisation' do
        expect(mail.govuk_notify_personalisation).to eq({
          service_name: 'Apply to court about child arrangements',
          resume_draft_url: 'https://c100.justice.uk/users/drafts/4a362e1c-48eb-40e3-9458-a31ead3f30a4/resume',
          user_expire_in_days: 30,
        })
      end
    end
  end

  describe 'draft_last_reminder' do
    let(:mail) { described_class.draft_expire_reminder(c100_application, :draft_last_reminder) }

    it_behaves_like 'a Notify mail', template_id: 'draft_last_reminder_template_id'

    it { expect(mail.to).to eq(['test@example.com']) }

    context 'personalisation' do
      it 'sets the personalisation' do
        expect(mail.govuk_notify_personalisation).to eq({
          service_name: 'Apply to court about child arrangements',
          resume_draft_url: 'https://c100.justice.uk/users/drafts/4a362e1c-48eb-40e3-9458-a31ead3f30a4/resume',
          user_expire_in_days: 30,
        })
      end
    end
  end

  describe '#reset_password_instructions' do
    let(:mail)  { described_class.reset_password_instructions(user, token) }
    let(:token) { '0xDEADBEEF' }

    it_behaves_like 'a Notify mail', template_id: 'reset_password_template_id'

    it { expect(mail.to).to eq(['test@example.com']) }

    it 'has the right keys' do
      expect(mail.govuk_notify_personalisation).to eq({
        service_name: 'Apply to court about child arrangements',
        reset_password_url: 'https://c100.justice.uk/users/password/edit?reset_password_token=0xDEADBEEF',
      })
    end
  end

  describe '#password_change' do
    let(:mail) { described_class.password_change(user) }

    it_behaves_like 'a Notify mail', template_id: 'change_password_template_id'

    it { expect(mail.to).to eq(['test@example.com']) }

    it 'has the right keys' do
      expect(mail.govuk_notify_personalisation).to eq({
        service_name: 'Apply to court about child arrangements',
        drafts_url: 'https://c100.justice.uk/users/drafts',
      })
    end
  end

  context 'unexpected errors' do
    let(:mail) { described_class.reset_password_instructions(nil, 'token') }

    it 'should just raise the error (let the job processor handle it)' do
      expect { mail.deliver_now }.to raise_error
    end
  end
end
