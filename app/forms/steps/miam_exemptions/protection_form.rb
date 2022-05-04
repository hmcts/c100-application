module Steps
  module MiamExemptions
    class ProtectionForm < BaseForm
      include MiamExemptionsForm
      setup_attributes_for ProtectionExemptions, attribute_name: :protection
    end
  end
end
