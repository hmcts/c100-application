require 'optparse'

namespace :short_urls do
  task list: :environment do
    ShortUrl.order(created_at: :asc).each do |url|
      url.target_url ||= default_target_url
      puts "[created: #{url.created_at}][visits: #{url.visits}] #{default_host_domain}/#{url.path} => #{url.to_str}"
    end
  end

  task create: :environment do
    ARGV.shift(2)

    options = {}

    OptionParser.new do |opts|
      opts.on("--path ARG", String) { |str| options[:path] = str }
      opts.on("--target_url [ARG]", String) { |str| options[:target_url] = str }
      opts.on("--target_path [ARG]", String) { |str| options[:target_path] = str }
      opts.on("--utm_source [ARG]", String) { |str| options[:utm_source] = str }
      opts.on("--utm_medium [ARG]", String) { |str| options[:utm_medium] = str }
      opts.on("--utm_campaign [ARG]", String) { |str| options[:utm_campaign] = str }
    end.parse!

    unless options[:path]
      raise ArgumentError, '`--path ARG` is a mandatory parameter'
    end

    ShortUrl.create(options)

    Rake::Task['short_urls:list'].invoke

    exit(0)
  end
end

private

def default_host_domain
  'https://c100.service.justice.gov.uk'.freeze
end

def default_target_url
  'https://apply-to-court-about-child-arrangements.service.justice.gov.uk'.freeze
end
