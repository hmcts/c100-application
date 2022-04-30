module C100App
  class NotifyCallback
    require 'bcrypt'

    attr_reader :payload

    PERMITTED_ATTRIBUTES ||= %i[
      id to reference status created_at completed_at sent_at
    ].freeze

    SECURE_ATTRIBUTES ||= %i[
      to
    ].freeze

    def initialize(payload)
      @payload = HashWithIndifferentAccess.new(payload).slice(*PERMITTED_ATTRIBUTES)
    end

    def process!
      return if payload[:reference].blank?
      EmailSubmissionsAudit.create!(secure_payload)
    end

    private

    def secure_payload
      payload.merge(payload.slice(*SECURE_ATTRIBUTES)) do |_key, value|
        BCrypt::Password.create(value)
      end
    end
  end
end
