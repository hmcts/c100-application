module Steps
  module AbuseConcerns
    class BaseAbuseForm < BaseForm
      attribute :subject, String
      attribute :kind, String

      # This ensures no tampering with the values
      validates_inclusion_of :subject, in: AbuseSubject.string_values
      validates_inclusion_of :kind,    in: AbuseType.string_values

      # As this form object is reused permuting `subject` and `kind`, sharing the
      # same view, this key will allow us to render the appropriate translations.
      def i18n_key
        [subject, kind].join('.')
      end

      private

      def persist!(attributes)
        raise C100ApplicationNotFound unless c100_application

        c100_application.abuse_concerns.find_or_initialize_by(
          subject: AbuseSubject.new(subject),
          kind: AbuseType.new(kind),
        ).update(
          attributes.except(:subject, :kind)
        )
      end
    end
  end
end
