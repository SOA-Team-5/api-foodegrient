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
        end

        def build_entity
          Entity::Recipe.new(
            id: nil,
            image: image, # rubocop:disable Style/HashSyntax
            title: title # rubocop:disable Style/HashSyntax
            # ingredients:
          )
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
      end
    end
  end
end
