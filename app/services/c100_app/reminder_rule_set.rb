module C100App
  class ReminderRuleSet
    attr_accessor :created_days_ago,
                  :status,
                  :status_transition_to,
                  :email_template_name

    delegate :find_each, :count, to: :rule_query

    def initialize(created_days_ago:, status:, status_transition_to:, email_template_name:)
      @created_days_ago = created_days_ago
      @status = status
      @status_transition_to = status_transition_to
      @email_template_name = email_template_name
    end

    def self.first_reminder
      new(
        created_days_ago: 23,
        status: nil,
        status_transition_to: :first_reminder_sent,
        email_template_name: 'draft_first_reminder'
      )
    end

    def self.last_reminder
      new(
        created_days_ago: 27,
        status: :first_reminder_sent,
        status_transition_to: :last_reminder_sent,
        email_template_name: 'draft_last_reminder'
      )
    end

    private

    def rule_query
      C100Application
        .with_owner
        .not_completed
        .where(reminder_status: status)
        .where('created_at <= ?', created_days_ago.days.ago)
    end
  end
end
