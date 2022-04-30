source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby File.read('.ruby-version')

gem 'devise', '~> 4.7.1'
gem 'govuk_design_system_formbuilder'
gem 'govuk_notify_rails', '~> 2.2.0'
gem 'govuk-pay-ruby-client', '~> 1.0.2'
gem 'jquery-rails'
gem 'mimemagic', '~> 0.3.7'
gem 'pg', '~> 1.1'
gem 'puma'
gem 'rails', '6.0.4.8'
gem 'responders'
gem 'sass-rails', '< 6.0.0'
gem 'sentry-raven', '~> 3.0'
gem 'uglifier'
gem 'uk_postcode'
gem 'virtus'
gem 'parser', '~> 3.1', '>= 3.1.1.0'

# Back office
gem 'omniauth-auth0'
gem 'omniauth-rails_csrf_protection'

# Caching and jobs processing
gem 'redis'
gem 'sidekiq', '~> 6.4'

# PDF generation
gem 'combine_pdf', '~> 1.0'
gem 'wicked_pdf', '~> 2.1.0'
gem 'wkhtmltopdf-binary', '~> 0.12.6.5'

group :production do
  gem 'lograge'
  gem 'logstash-event'
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'i18n-debug'
  gem 'web-console'
end

source 'https://oss:Q7U7p2q2XlpY45kwqjCpXLIPf122rjkR@gem.mutant.dev' do
  gem 'mutant-license',                '0.1.1.2.1739399027284447558325915053311580324856.4'
end

group :development, :test do
  gem 'dotenv-rails'
  gem 'mutant-rspec'
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'rspec-rails'
  gem 'spring', '~> 2.0'
  gem 'spring-commands-rspec'
end

group :test do
  gem 'brakeman'
  gem 'capybara'
  gem 'capybara-screenshot', '~> 1.0', '>= 1.0.25'
  gem 'cucumber', '< 4.0.0'
  gem 'cucumber-rails', require: false
  gem 'rails-controller-testing'
  gem 'rspec_junit_formatter'
  gem 'rubocop'
  gem 'rubocop-performance', require: false
  gem 'selenium-webdriver'
  gem 'simplecov', require: false
  gem 'simplecov-rcov'
  gem 'site_prism', '~> 3.7', '>= 3.7.1'
  gem 'webdrivers'
  gem 'webmock'
end
