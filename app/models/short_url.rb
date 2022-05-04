class ShortUrl < ApplicationRecord
  def track_visit!
    increment!(:visits) if persisted?
  end

  class << self
    def resolve(path:, target_url:)
      url = find_or_initialize_by(path: path)
      url.target_url ||= target_url
      url.track_visit!
      url
    end
  end

  def to_str
    [target_url, target_path, analytics_query].join
  end

  private

  def analytics_query
    {
      utm_source: utm_source,
      utm_medium: utm_medium,
      utm_campaign: utm_campaign,
    }.compact.to_query.presence&.prepend('?')
  end
end
