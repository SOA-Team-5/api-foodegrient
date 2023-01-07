# frozen_string_literal: true

require 'figaro'
require 'roda'
require 'sequel'
require 'yaml'
require 'rack/session'
require 'rack/cache'
require 'redis-rack-cache'
require 'aws-sdk-s3'

module Foodegrient
  # Configuration for the App
  class App < Roda
    plugin :environments

    # CONFIG = YAML.safe_load(File.read('config/secrets.yml'))
    # FOOD_API_TOKEN = CONFIG['FOOD_API_TOKEN']
    # rubocop:disable Lint/ConstantDefinitionInBlock
    configure do
      # Environment variables setup
      Figaro.application = Figaro::Application.new(
        environment:environment,
        path: File.expand_path('config/secrets.yml')
      )
      Figaro.load;
      def self.config
        Figaro.env
      end

      # Setup Cacheing mechanism
      configure :development do
        use Rack::Cache,
          verbose: true,
          metastore: 'file:_cache/rack/meta',
          entitystore: 'file:_cache/rack/body'
      end

      configure :production do
        use Rack::Cache,
          verbose: true,
          metastore: "#{config.REDISCLOUD_URL}/0/metastore",
          entitystore: "#{config.REDISCLOUD_URL}/0/entitystore"
      end

      use Rack::Session::Cookie, secret: config.SESSION_SECRET

      configure :development, :test do
        ENV['DATABASE_URL'] = "#{config.DB_URL}"
      end

      # Database Setup
      DB = Sequel.connect(ENV.fetch('DATABASE_URL'))
      $DB = Sequel.connect((ENV.fetch'DATABASE_URL'))
      def self.DB
        DB # rubocop:disable Naming/MethodName
      end


      $CFR2 = Aws::S3::Client.new(
        access_key_id: "#{config.R2_ACCESS_KEY_ID}",
        secret_access_key: "#{config.R2_SECRET_ACCESS_KEY}",
        endpoint: "https://#{config.CLOUDFLARE_R2_ID}.r2.cloudflarestorage.com",
        region: "auto",
        )

    end
    # rubocop:enable Lint/ConstantDefinitionInBlock
  end
end