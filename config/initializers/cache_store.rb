if ENV.key?('REDIS_URL')
  Rails.application.config.cache_store = :redis_cache_store, {
    connect_timeout: 2,
    read_timeout: 0.3,
    write_timeout: 0.3,

    error_handler: -> (method:, returning:, exception:) {
      Raven.capture_exception(exception, level: 'warning', tags: { method: method, returning: returning })
    }
  }
else
  Rails.application.config.cache_store = :memory_store
end

# http://stackoverflow.com/a/38619281/2066546
Rails.cache = ActiveSupport::Cache.lookup_store(Rails.application.config.cache_store)
