module Steps
  module MiamExemptions
    class DomesticForm < BaseForm
      include MiamExemptionsForm
      setup_attributes_for DomesticExemptions, attribute_name: :domestic
    end
  end
end
