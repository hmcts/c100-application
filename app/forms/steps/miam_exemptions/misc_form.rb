module Steps
  module MiamExemptions
    class MiscForm < BaseForm
      include MiamExemptionsForm
      setup_attributes_for MiscExemptions, attribute_name: :misc
    end
  end
end
