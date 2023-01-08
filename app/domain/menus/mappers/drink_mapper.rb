# frozen_string_literal: false
require_relative '../entities/drink'

module Foodegrient
  # Provides access to Food data
  module CocktailDb
    # Data Mapper: CocktailDb  -> Drink entity
    class DrinkMapper
      def initialize(gateway_class = CocktailDb::Api)
        @gateway_class = gateway_class
        @gateway = @gateway_class.new
      end
      
      def load_several(ingredient)
        @gateway.cocktail_data(ingredient).map do |item|
          DrinkMapper.build_entity(item)
        end
      end

      def self.build_entity(data)
        DataMapper.new(data).build_entity
      end

      # Extracts entity specific elements from data structure
      class DataMapper
        def initialize(data)
          @data = data
          @recipe_db_table = $DB[:drink] # Create a dataset
          @recipe_db_table.insert_conflict.multi_insert([{origin_id: id, image: image, name: name}]) unless @recipe_db_table.where(origin_id: id).count == 1
        end

        def build_entity
          Entity::Drink.new(
            id: id,
            name: name, # rubocop:disable Style/HashSyntax
            image: image, # rubocop:disable Style/HashSyntax
          )
        end

        private
        def id
          @data['idDrink'].to_i
        end

        def image
          @data['strDrinkThumb']
        end

        def name
          @data['strDrink']
        end

      end
    end
  end
end
