module Steps
  module AbuseConcerns
    class DetailsForm < BaseAbuseForm
      attribute :behaviour_description, String
      attribute :behaviour_start, String
      attribute :behaviour_ongoing, YesNo
      attribute :behaviour_stop, String
      attribute :asked_for_help, YesNo
      attribute :help_party, String
      attribute :help_provided, YesNo
      attribute :help_description, String

      validates_presence_of :behaviour_description, :behaviour_start,
                            :behaviour_ongoing, :asked_for_help,
                            message: proc { |_error, attributes| err_msg(attributes) }
      validates_presence_of :behaviour_stop,
                            message: proc { |_error, attributes| err_msg(attributes) },
                            if: -> { behaviour_ongoing == GenericYesNo.new(:no) }
      validates_presence_of :help_party,
                            message: proc { |_error, attributes| err_msg(attributes) },
                            if: -> { asked_for_help == GenericYesNo.new(:yes) }
      validates_presence_of :help_provided,
                            message: proc { |_error, attributes| err_msg(attributes) },
                            if: -> { asked_for_help == GenericYesNo.new(:yes) }
      validates_presence_of :help_description,
                            message: proc { |_error, attributes| err_msg(attributes) },
                            if: lambda {
                                  asked_for_help == GenericYesNo.new(:yes) &&
                                    help_provided == GenericYesNo.new(:yes)
                                }

      def self.err_msg(attributes)
        I18n.translate!("steps.abuse_concerns.details.edit.errors.#{
          attributes[:attribute].parameterize.underscore}")
      end

      private

      def persist!
        super(attributes_map)
      end
    end
  end
end
