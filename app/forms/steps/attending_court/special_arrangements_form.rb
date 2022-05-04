module Steps
  module AttendingCourt
    class SpecialArrangementsForm < BaseForm
      include ArrangementsCheckBoxesForm
      setup_attributes_for SpecialArrangements, attribute_name: :special_arrangements

      # any other attributes
      attribute :special_arrangements_details, String
    end
  end
end
