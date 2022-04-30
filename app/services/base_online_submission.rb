class BaseOnlineSubmission
  attr_reader :c100_application
  attr_reader :documents

  def initialize(c100_application)
    @c100_application = c100_application
    @documents = {}
  end

  # :nocov:
  def to_address
    raise 'implement in subclasses'
  end
  # :nocov:

  # Any exception in this method will bubble up to the Job classes
  # :nocov:
  def process
    raise 'implement in subclasses'
  end
  # :nocov:

  private

  def generate_pdf(*args)
    presenter = Summary::PdfPresenter.new(c100_application)
    presenter.generate(*args)

    StringIO.new(presenter.to_pdf)
  end

  # :nocov:
  def generate_documents
    raise 'implement in subclasses'
  end
  # :nocov:

  # :nocov:
  def deliver_email
    raise 'implement in subclasses'
  end
  # :nocov:

  def application_details
    {
      c100_application: c100_application,
      documents: documents,
    }
  end
end
