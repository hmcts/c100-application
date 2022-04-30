module Steps
  module AttendingCourt
    class SpecialAssistanceForm < BaseForm
      include ArrangementsCheckBoxesForm
      setup_attributes_for SpecialAssistance, attribute_name: :special_assistance

      # any other attributes
      attribute :special_assistance_details, String
    end
  end
end
