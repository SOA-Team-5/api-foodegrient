# frozen_string_literal: true

require 'http'
# require_relative '../../models/entities/menu'

module Foodegrient
  module CocktailDb
    # Library for CocktailDb API utilities
    class Api
      def initialize
      end

      def cocktail_data(ingredient)
        Request.new.cocktail(ingredient).parse["drinks"]
      end

      class Utils
        def build_query(ingredient)
          "?i=#{ingredient}"
        end
      end

      # Sends out HTTP requests to Spoonacular API
      class Request
        def initialize
        end

        API_ROOT = 'https://www.thecocktaildb.com/api/json/v1/1/filter.php'

        def call_cocktail_url(url)
          result = HTTP.get(url)
          Response.new(result).tap do |response|
            raise(response.error) unless response.successful?
          end
        end

        def cocktail(ingredient)
          query = Utils.new.build_query(ingredient)
          drink_url = API_ROOT + query
          call_cocktail_url(drink_url)
        end
      end

      # Decorates HTTP responses from Spoonacular API
      class Response < SimpleDelegator
        Unauthorized = Class.new(StandardError)
        NotFound = Class.new(StandardError)

        HTTP_ERROR = {
          #401 => Unauthorized,
          #404 => NotFound
        }.freeze

        def successful?
          HTTP_ERROR.keys.none?(code)
        end

        def error
          HTTP_ERROR[code]
        end
      end
    end
  end
end
