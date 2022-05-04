module Steps
  module Completion
    class SummaryController < Steps::CompletionStepController
      def show
        respond_to do |format|
          format.pdf do
            presenter = Summary::PdfPresenter.new(current_c100_application)
            presenter.generate

            # Will render the template defined in `BasePdfForm#template`
            # i.e. `steps/completion/summary/show.pdf.erb`
            send_data(presenter.to_pdf, filename: presenter.filename)
          end
        end
      end
    end
  end
end
