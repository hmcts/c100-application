# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.1'

# Add additional assets to the asset load path.
Rails.application.config.assets.paths << Rails.root.join('node_modules')

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
Rails.application.config.assets.precompile << %r{fonts/[\w-]+\.(?:eot|svg|ttf|woff2?)$}
Rails.application.config.assets.precompile << %r{images/[\w-]+\.(?:png|svg)$}
Rails.application.config.assets.precompile << %w(
  application-ie8.css
  html5shiv-printshiv.js
  apple-touch-icon.png
  apple-touch-icon-180x180.png
  apple-touch-icon-167x167.png
)
