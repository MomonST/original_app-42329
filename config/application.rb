require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module OriginalAppUserId
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.1

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w(assets tasks))

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    
    # API設定を追加
    config.api_only = false  # 通常のRailsアプリとして維持
    
    # CORS設定
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins Rails.env.development? ? 'http://localhost:3000' : ENV['FRONTEND_URL']
        resource '*',
          headers: :any,
          methods: [:get, :post, :put, :patch, :delete, :options, :head],
          credentials: true
      end
    end
    
    # タイムゾーン
    config.time_zone = 'Tokyo'

    # Active Storage設定
    config.active_storage.variant_processor = :mini_magick
    
    # 画像サイズ制限
    config.active_storage.max_file_size = 10.megabytes
  end
end
