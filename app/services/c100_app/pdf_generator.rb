module C100App
  class PdfGenerator
    def generate(presenter, copies:)
      main_doc = pdf_from_presenter(presenter)
      raw_file = presenter.raw_file_path

      copies.times do
        combiner << CombinePDF.parse(main_doc)
        combiner << CombinePDF.load(raw_file) if raw_file
      end
    end

    def has_forms_data?
      combiner.forms_data.present?
    end

    def to_pdf
      return '' unless has_forms_data?
      combiner.to_pdf
    end

    private

    def pdf_from_presenter(presenter)
      producer.pdf_from_string(
        render(presenter),
        footer: { right: footer_line(presenter) },
        extra: '--enable-forms',
      )
    end

    def render(presenter)
      ApplicationController.render(
        template: presenter.template,
        locals: { presenter: presenter }
      )
    end

    def footer_line(presenter)
      [
        presenter.c100_application.reference_code,
        presenter.name,
        presenter.page_number,
      ].join('   ')
    end

    def producer
      @_producer ||= WickedPdf.new
    end

    def combiner
      @_combiner ||= CombinePDF.new
    end
  end
end
