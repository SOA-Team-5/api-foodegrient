# frozen_string_literal: false
require_relative '../entities/recipe'

module Foodegrient
  # Provides access to Food data
  module Spoonacular
    # Data Mapper: Spoonacular recipes -> Menu entity
    class RecipeMapper
      def initialize(data)
        @data = data
      end

      def load_several()
        @data.map do |item|
          RecipeMapper.build_entity(item)
        end
      end

      def self.build_entity(data)
        DataMapper.new(data).build_entity
      end

      # Extracts entity specific elements from data structure
      class DataMapper
        def initialize(data)
          @data = data
          @recipe_db_table = $DB[:recipe] # Create a dataset
          @recipe_db_table.insert_ignore.multi_insert([{official_id: id, image: image, title: title, likes: likes}])
        end

        def build_entity
          Entity::Recipe.new(
            id: id,
            image: image, # rubocop:disable Style/HashSyntax
            title: title, # rubocop:disable Style/HashSyntax
            likes: likes
            # ingredients:
          )
          # Populate the table
          # @DB.run `INSERT INTO recipe(official_id, image, title, likes) VALUES(`+id+`, `+image+`, `+title+`, `+ likes+`)`
        end

        private

        def id
          @data['id']
        end

        def image
          @data['image']
        end

        def title
          @data['title']
        end

        def likes
          @data['likes']
        end
      end
    end
  end
end
