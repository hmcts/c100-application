module Steps
  module <%= task_name.camelize %>
    class <%= step_name.camelize %>Form < BaseForm
      # TODO: Add more attributes or change type if necessary
      attribute :<%= step_name.underscore %>, String

      # TODO: Delete this method and add different validation if you don't have a value object
      def self.choices
        <%= step_name.camelize %>.string_values
      end
      validates_inclusion_of :<%= step_name.underscore %>, in: choices

      private

      # TODO: Delete this method if you don't have a value object
      def <%= step_name.underscore %>_value
        <%= step_name.camelize %>.new(<%= step_name.underscore %>)
      end

      # TODO: Change this method if you don't have a single value object
      def changed?
        !c100_application.<%= step_name.underscore %>.eql?(<%= step_name.underscore %>_value)
      end

      def persist!
        raise C100ApplicationNotFound unless c100_application
        return true unless changed?

        # TODO: Update this to persist your form object if you don't have a single value object
        c100_application.update(
          <%= step_name.underscore %>: <%= step_name.underscore %>_value
          # The following are dependent attributes that need to be reset
          # TODO: Are there any dependent attributes? Reset them here.
        )
      end
    end
  end
end
