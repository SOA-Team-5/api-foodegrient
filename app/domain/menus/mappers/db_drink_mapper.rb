# frozen_string_literal: false
require_relative '../entities/drink'

module Foodegrient
  # Provides access to Food data
  module CocktailDb
    # Data Mapper: CocktailDb  -> Drink entity
    class DbDrinkMapper
      def initialize(data)
        @data = data
      end
      
      def load_several()
        @data.map do |item|
          DbDrinkMapper.build_entity(item)
        end
      end

      def self.build_entity(data)
        DataMapper.new(data).build_entity
      end

      # Extracts entity specific elements from data structure
      class DataMapper
        def initialize(data)
          @data = data
          # @recipe_db_table = $DB[:drink] # Create a dataset
          # @recipe_db_table.insert_conflict.multi_insert([{origin_id: id, image: image, name: name}]) unless @recipe_db_table.where(origin_id: id).count == 1
        end

        def build_entity
          Entity::Drink.new(
            id: id,
            name: name, # rubocop:disable Style/HashSyntax
            image: image, # rubocop:disable Style/HashSyntax
            drink_id: $DB[:drink].where(origin_id: id).get(:id),
            likes: likes,
            unlikes: unlikes,
          )
        end

        private
        def id
          @data['id'].to_i
        end

        def image
          @data['image']
        end

        def name
          @data['name']
        end
        
        def likes
            @data['likes'].to_i
        end
  
        def unlikes
          @data['unlikes'].to_i
        end
      end
    end
  end
end
