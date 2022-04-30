require 'capybara-screenshot/cucumber'
if ENV.key?('SCREENSHOT_S3_ACCESS_KEY_ID')
  Capybara::Screenshot.prune_strategy = { keep: 20 }
  Capybara::Screenshot.s3_configuration = {
      s3_client_credentials: {
          access_key_id: ENV.fetch('SCREENSHOT_S3_ACCESS_KEY_ID'),
          secret_access_key: ENV.fetch('SCREENSHOT_S3_SECRET_ACCESS_KEY'),
          region: ENV.fetch('SCREENSHOT_S3_REGION'),
      },
      bucket_name: ENV.fetch('SCREENSHOT_S3_BUCKET'),
      key_prefix: ENV.fetch('SCREENSHOT_S3_KEY_PREFIX', '')
  }
end

Capybara::Screenshot.prune_strategy = :keep_last_run
Capybara::Screenshot.register_driver(:chrome_headless) do |driver, path|
  driver.browser.save_screenshot(path)
end
