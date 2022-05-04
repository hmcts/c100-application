class ShortUrlExpander
  attr_reader :target_url

  def initialize(target_url)
    @target_url = target_url
  end

  def call(params, _request)
    ShortUrl.resolve(path: params[:path], target_url: target_url)
  end
end
