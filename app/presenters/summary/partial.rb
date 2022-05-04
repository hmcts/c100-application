module Summary
  class Partial
    attr_reader :name, :ivar

    def initialize(name, ivar = nil)
      @name = name
      @ivar = ivar
    end

    class << self
      def page_break
        new(:page_break)
      end

      def blank_page
        new(:blank_page)
      end

      def row_blank_space
        new(:row_blank_space)
      end

      def horizontal_rule
        new(:horizontal_rule)
      end
    end

    def show?
      true
    end

    def to_partial_path
      "steps/completion/shared/#{name}"
    end
  end
end
