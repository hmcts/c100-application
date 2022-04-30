require 'rails_helper'

RSpec.describe C100App::DraftReminders do
  subject { described_class.new(rule_set: rule_set) }

  let(:rule_set) {
    instance_double(
      C100App::ReminderRuleSet,
      email_template_name: :template_name,
      status_transition_to: :another_status
    )
  }
  let(:c100_application) { instance_double(C100Application) }

  describe '#run' do
    let(:mailer_double) { double.as_null_object }

    before do
      allow(rule_set).to receive(:find_each).and_yield(c100_application)
      allow(NotifyMailer).to receive(:draft_expire_reminder).with(c100_application, :template_name).and_return(mailer_double)
    end

    it 'should send the email and update the `reminder_status` attribute' do
      expect(mailer_double).to receive(:deliver_later)
      expect(c100_application).to receive(:update).with(reminder_status: :another_status)
      subject.run
    end
  end
end
