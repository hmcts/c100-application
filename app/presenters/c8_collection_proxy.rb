class C8CollectionProxy < SimpleDelegator
  attr_reader :c100_application

  def initialize(c100_application, collection)
    @c100_application = c100_application

    super(
      confidentiality_enabled? ? decorate(collection) : collection
    )
  end

  private

  def decorate(collection)
    collection.map { |item| C8ConfidentialityPresenter.new(item) }
  end

  def confidentiality_enabled?
    c100_application.confidentiality_enabled?
  end
end
