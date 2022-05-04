module C100App
  class ResearchSampler
    # Very simple utility class to give us the ability to run experiments
    # or A/B testing on a weighted pseudo random population (applications).
    #
    # Basically we use the `created_at` date of the application, as this will
    # never change, and extract the `seconds` part from it, giving us 0-59.
    # It is deterministic: given the same input, will produce the same output.
    #
    # Using a simple percentage 0% to 100% (weight) we return if this second is
    # part of the population sample or not.
    #
    # For example, given a 50% weight, only applications with a `created_at`
    # second ranging from 0 to 29 will be included, and those with seconds
    # 30 to 59 will be excluded from the sample.
    #
    def self.candidate?(c100_application, weight)
      unless (0..100).cover?(weight)
        raise ArgumentError, "Invalid weight `#{weight}`, only values 0 to 100 allowed"
      end

      # obtain a weighted sample from the seconds in a minute, i.e.
      #
      #   - a percentage of 0, or 0.0, will return a sample of 0
      #   - a percentage of 25, or 0.25, will return a sample of 15
      #   - a percentage of 100, or 1.0, will return a sample of 60
      #
      sample = (weight / 100.0) * 60

      # check if the `second` this application was created (0-59)
      # is part of the weighted sample
      c100_application.created_at.sec < sample
    end
  end
end
