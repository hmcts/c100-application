module Summary
  class PdfPresenter
    DEFAULT_BUNDLE_FORMS ||= [:c100, :c1a, :c8].freeze

    attr_reader :c100_application
    attr_reader :pdf_generator

    delegate :to_pdf, :has_forms_data?, to: :pdf_generator

    def initialize(c100_application, generator = C100App::PdfGenerator.new)
      @c100_application = c100_application
      @pdf_generator = generator
    end

    # Gentle reminder this method does not return anything of value. Its purpose
    # is to generate one or more forms, which will be bundled together.
    # Once all the required forms have been generated, it is neccessary to call
    # the instance method `#to_pdf` to return the final, combined PDF.
    #
    def generate(*args)
      forms = args.presence || DEFAULT_BUNDLE_FORMS

      generate_c100_form if forms.include?(:c100)
      generate_c1a_form  if forms.include?(:c1a)
      generate_c8_form   if forms.include?(:c8)
    end

    def filename
      'C100 child arrangements application.pdf'.freeze
    end

    private

    def generate_c100_form
      pdf_generator.generate(
        Summary::C100Form.new(c100_application), copies: 1
      )
    end

    def generate_c1a_form
      return unless c100_application.has_safety_concerns?

      add_blank_page_if_needed

      pdf_generator.generate(
        Summary::C1aForm.new(c100_application), copies: 1
      )
    end

    def generate_c8_form
      return unless c100_application.confidentiality_enabled?

      add_blank_page_if_needed

      pdf_generator.generate(
        Summary::C8Form.new(c100_application), copies: 1
      )
    end

    # Avoid adding unnecessary blank pages if there are no preceding forms,
    # for example in the case we are generating individual forms like the C8.
    #
    def add_blank_page_if_needed
      pdf_generator.generate(
        Summary::BlankPage.new(c100_application), copies: 1
      ) if has_forms_data?
    end
  end
end
