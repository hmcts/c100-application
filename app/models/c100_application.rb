class C100Application < ApplicationRecord
  include ApplicationInquiryMethods
  include ApplicationReference

  enum status: {
    screening: 0,
    in_progress: 1,
    payment_in_progress: 8,
    completed: 10,
  }

  enum reminder_status: {
    first_reminder_sent: 'first_reminder_sent',
    last_reminder_sent: 'last_reminder_sent',
  }

  belongs_to :user, optional: true
  belongs_to :court, optional: true

  has_one  :solicitor,          dependent: :destroy
  has_one  :abduction_detail,   dependent: :destroy
  has_one  :court_order,        dependent: :destroy
  has_one  :court_proceeding,   dependent: :destroy
  has_one  :court_arrangement,  dependent: :destroy
  has_one  :miam_exemption,     dependent: :destroy
  has_one  :email_submission,   dependent: :destroy
  has_one  :payment_intent,     dependent: :destroy

  has_many :abuse_concerns,     dependent: :destroy
  has_many :relationships,      dependent: :destroy

  has_many :people,             dependent: :destroy
  has_many :minors
  has_many :children
  has_many :applicants
  has_many :respondents
  has_many :other_children,     dependent: :destroy
  has_many :other_parties,      dependent: :destroy

  scope :with_owner,    -> { where.not(user: nil) }
  scope :not_completed, -> { where.not(status: :completed) }
  scope :not_eligible_orphans, -> { where.not(children_postcode: nil).where(court: nil) }

  # Before marking the application as completed we run a final
  # validation to ensure the basic details are fulfilled.
  #
  validates_with ApplicationFulfilmentValidator, on: :completion

  # There is a 20 minute grace period, in case an application is being updated
  # by the time the purge kicks off. If so, will be purged in the next daily run.
  #
  def self.purge!(date)
    where(
      'c100_applications.created_at <= :date', date: date
    ).where(
      'c100_applications.updated_at <= :date', date: 20.minutes.ago
    ).destroy_all
  end

  def mark_as_completed!
    transaction do
      update!(status: :completed, completed_at: Time.current)
      CompletedApplicationsAudit.log!(self)
    end
  end
end
