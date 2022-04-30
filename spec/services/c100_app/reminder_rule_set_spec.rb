require 'rails_helper'

RSpec.describe C100App::ReminderRuleSet do
  describe '.first_reminder' do
    subject { described_class.first_reminder }

    it { expect(subject.created_days_ago).to eq(23) }
    it { expect(subject.status).to eq(nil) }
    it { expect(subject.status_transition_to).to eq(:first_reminder_sent) }
    it { expect(subject.email_template_name).to eq('draft_first_reminder') }
  end

  describe '.last_reminder' do
    subject { described_class.last_reminder }

    it { expect(subject.created_days_ago).to eq(27) }
    it { expect(subject.status).to eq(:first_reminder_sent) }
    it { expect(subject.status_transition_to).to eq(:last_reminder_sent) }
    it { expect(subject.email_template_name).to eq('draft_last_reminder') }
  end

  describe '#find_each' do
    let(:dummy_config) do
      {
        created_days_ago: 3,
        status: :test_status,
        status_transition_to: :another_status,
        email_template_name: :template_name
      }
    end
    let(:finder_double) { double.as_null_object }

    subject { described_class.new(**dummy_config) }

    before do
      travel_to Time.now
    end

    it 'filters the c100 applications' do
      expect(C100Application).to receive(:with_owner).and_return(finder_double)
      expect(finder_double).to receive(:not_completed).and_return(finder_double)
      expect(finder_double).to receive(:where).with(reminder_status: :test_status).and_return(finder_double)
      expect(finder_double).to receive(:where).with('created_at <= ?', 3.days.ago).and_return(finder_double)
      subject.find_each
    end

    it 'it returns an enumerator' do
      expect(subject.find_each).to be_an(Enumerator)
    end
  end
end
