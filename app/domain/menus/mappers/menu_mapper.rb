# frozen_string_literal: false

require_relative 'recipe_mapper'

module Foodegrient
  # Provides access to Food data
  module Spoonacular
    # Data Mapper: Spoonacular recipes -> Menu entity
    class MenuMapper
      def initialize(food_token, gateway_class = Spoonacular::Api)
        @token = food_token
        @gateway_class = gateway_class
        @gateway = @gateway_class.new(@token)
      end

      def search(ingredients)
        data = @gateway.menu_data(ingredients)
        build_entity(ingredients, data)
      end

      def build_entity(ingredients, data)
        DataMapper.new(ingredients, data).build_entity
      end

      # Extracts entity specific elements from data structure
      class DataMapper
        def initialize(ingredients, data)
          @ingredients = ingredients
          @data = data
          @recipe_mapper = RecipeMapper.new(@data)
        end

        def build_entity
          Foodegrient::Entity::Menu.new(
            id: 0,
            ingredients: @ingredients,
            recipes: recipes # rubocop:disable Style/HashSyntax
          )
        end

        def recipes
          @recipe_mapper.load_several
        end
      end
    end
  end
end
