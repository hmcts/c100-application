class ShortUrlsTable < ActiveRecord::Migration[5.1]
  def change
    create_table :short_urls, id: false do |t|
      t.timestamps

      t.string :path, primary_key: true

      t.string :target_url
      t.string :target_path

      t.string :utm_source
      t.string :utm_medium
      t.string :utm_campaign
    end
  end
end
