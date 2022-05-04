module Summary
  class BlankPage < BasePdfForm
    def name
      nil
    end

    def page_number
      nil
    end

    def sections
      [
        Partial.blank_page
      ]
    end
  end
end
