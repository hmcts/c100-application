module C100App
  class Status
    def response
      { healthy: success?, dependencies: results }
    end

    def success?
      results.values.all?
    end

    private

    def results
      checks.map(&:call).to_h
    end

    # If more checks are needed add them to this collection with the same syntax.
    # Redis is checked via Sidekiq so no need to add an explicit check.
    #
    # Note: `courtfinder` disabled because it is just too unreliable and we don't have
    # any control over it so even if it goes down, we should not consider our service
    # unhealthy. After all, in-progress/saved applications will continue working, it
    # only affects new applications.
    #
    # rubocop:disable Style/RescueModifier
    def checks
      [
        ->(name: 'database') { [name, (ActiveRecord::Base.connection.active? rescue false)] },
        ->(name: 'sidekiq') { [name, (Sidekiq::ProcessSet.new.size.positive? rescue false)] },
        ->(name: 'sidekiq_latency') { [name, (Sidekiq::Queue.all.sum(&:latency) rescue false)] },
        #->(name: 'courtfinder'){ [name, (C100App::CourtfinderAPI.new.is_ok? rescue false)] },
      ]
    end
    # rubocop:enable Style/RescueModifier
  end
end
