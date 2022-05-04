class User < ApplicationRecord
  devise :database_authenticatable, :recoverable, :registerable, :validatable, :trackable

  has_many :c100_applications, dependent: :destroy
  has_many :drafts, -> { not_completed }, class_name: 'C100Application'
  has_many :completed_applications, -> { completed }, class_name: 'C100Application'

  attribute :email, NormalisedEmailType.new
  validates :email, email: true, allow_blank: true

  # Devise requires several DB attributes for the `trackable` module, but we are not
  # using all of them. Using virtual attributes so Devise doesn't complain.
  attr_accessor :last_sign_in_ip, :current_sign_in_ip, :sign_in_count

  def self.purge!(date)
    # Using `#created_at` as the secondary criteria because `#current_sign_in_at`
    # does not get set until the first time they have actually signed in.
    # This does *not* automatically happen when they create their account.
    where('current_sign_in_at <= :date OR (created_at <= :date AND current_sign_in_at IS NULL)', date: date).destroy_all
  end

  # Needed in order to deliver Devise emails in the background.
  # https://github.com/heartcombo/devise#activejob-integration
  #
  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end
end
