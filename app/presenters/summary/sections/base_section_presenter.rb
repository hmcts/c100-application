module Summary
  module Sections
    class BaseSectionPresenter
      include Rails.application.routes.url_helpers

      attr_reader :c100_application
      attr_reader :name

      alias_attribute :c100, :c100_application

      def initialize(c100_application, name: nil)
        @c100_application = c100_application
        @name = name
      end

      # Used by Rails to determine which partial to render. May be overridden in subclasses
      def to_partial_path
        'steps/completion/shared/section'
      end

      # May be overridden in subclasses to hide/show if appropriate
      def show?
        answers.any?
      end

      # May be overridden in subclasses to hide/show if appropriate
      def show_header?
        true
      end

      protected

      # :nocov:
      def answers
        raise 'must be implemented in subclasses'
      end
      # :nocov:
    end
  end
end
