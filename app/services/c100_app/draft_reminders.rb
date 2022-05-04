module C100App
  class DraftReminders
    attr_reader :rule_set

    def initialize(rule_set:)
      @rule_set = rule_set
    end

    def run
      rule_set.find_each(&method(:send_reminder))
    end

    private

    def send_reminder(c100_application)
      NotifyMailer.draft_expire_reminder(
        c100_application, rule_set.email_template_name
      ).deliver_later

      c100_application.update(
        reminder_status: rule_set.status_transition_to
      )
    end
  end
end
