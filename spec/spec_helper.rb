require 'webmock/rspec'

ENV['RAILS_ENV'] ||= 'test'

require 'simplecov'
require "simplecov_json_formatter"
SimpleCov.formatter = SimpleCov::Formatter::JSONFormatter
SimpleCov.minimum_coverage 100

# SimpleCov conflicts with mutant. This lets us turn it off, when necessary.
unless ENV['NOCOVERAGE']
  SimpleCov.start do
    add_filter '.bundle'
    add_filter 'spec/support'
    add_filter 'spec/rails_helper.rb'
    add_filter 'config/initializers'
    add_filter 'config/environments'
    add_filter 'controllers/backoffice'
    add_filter 'helpers/auth0'
  end
end

Dir['./spec/support/**/*.rb'].each {|f| require f}

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.profile_examples = true
  config.filter_run_when_matching focus: true
end
