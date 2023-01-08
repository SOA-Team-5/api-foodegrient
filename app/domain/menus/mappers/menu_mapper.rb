# frozen_string_literal: false

require_relative 'recipe_mapper'
require_relative 'drink_mapper'

module Foodegrient
  # Provides access to Food data
  module Spoonacular
    # Data Mapper: Spoonacular recipes -> Menu entity
    class MenuMapper
      def initialize(food_token)
        @food_token = food_token
      end

      def build_entity(ingredients)
        DataMapper.new(ingredients, @food_token).build_entity
      end

      # Extracts entity specific elements from data structure
      class DataMapper
        def initialize(ingredients, food_token)
          @ingredients = ingredients
          @food_token = food_token
          @recipe_mapper = RecipeMapper.new(@food_token)
          @drink_mapper = CocktailDb::DrinkMapper.new
        end

        def build_entity
          Foodegrient::Entity::Menu.new(
            id: 0,
            ingredients: @ingredients,
            recipes: recipes, # rubocop:disable Style/HashSyntax
            drinks: drinks # rubocop:disable Style/HashSyntax
          )
        end

        def recipes
          @recipe_mapper.load_several(@ingredients)
        end

        def drinks
          drinks_list = Array.new
          @ingredients.map do |ingredient|
            drinks_list.push(@drink_mapper.load_several(ingredient))
          end
          drinks_list.reduce([], :concat)
        end
      end
    end
  end
end
