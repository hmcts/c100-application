module Summary
  class C8Form < BasePdfForm
    def name
      'C8'
    end

    def sections
      [
        Sections::FormHeader.new(c100_application, name: :c8_form),
        Sections::C8CourtDetails.new(c100_application),
        Partial.new(:c8_instructions),
        Sections::C8ApplicantsDetails.new(c100_application),
        Sections::C8OtherPartiesDetails.new(c100_application),
      ].flatten.select(&:show?)
    end
  end
end
