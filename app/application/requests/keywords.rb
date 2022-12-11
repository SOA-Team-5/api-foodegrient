# frozen_string_literal: true

require 'dry/monads'
require 'json'

module Foodegrient
  module Request
    # Retrieves array of all listed project entities
    class Keywords
      def initialize(keywords)
        @keywords = keywords.split('%20')
        @menus = Spoonacular::MenuMapper
        .new(App.config.FOOD_API_TOKEN)
        .search(@keywords)
        @recipes = @menus.recipes
      end

      attr_reader :keywords, :menus, :recipes
    end
  end
end
