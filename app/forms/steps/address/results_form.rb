module Steps
  module Address
    class ResultsForm < BaseForm
      attribute :selected_address, SplitAddress
      validates_presence_of :selected_address

      private

      def persist!
        raise C100ApplicationNotFound unless c100_application

        record.update(
          selected_address
        )
      end
    end
  end
end
