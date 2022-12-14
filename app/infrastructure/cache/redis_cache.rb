# frozen_string_literal: true

require 'redis'

module Foodegrient
  module Cache
    # Redis client utility
    class Client
      require_relative '../../../config/environment' # load config info
      def initialize()
        @api = Foodegrient::App
        @redis = Redis.new(url: @api.config.REDISCLOUD_URL)
      end

      def keys
        @redis.keys
      end

      def wipe
        keys.each { |key| @redis.del(key) }
      end

      def set(key, value)
        @redis.set(key, value)
      end

      def get(key)
        @redis.get(key)
      end
    end
  end
end
