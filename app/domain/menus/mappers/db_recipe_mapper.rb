# frozen_string_literal: false
require_relative '../entities/recipe'

module Foodegrient
  # Provides access to Food data
  module Spoonacular
    # Data Mapper: Spoonacular recipes -> Menu entity
    class DbRecipeMapper
      def initialize(data)
        @data = data
      end

      def load_several()
        @data.map do |item|
          DbRecipeMapper.build_entity(item)
        end
      end

      def self.build_entity(data)
        DbDataMapper.new(data).build_entity
      end

      # Extracts entity specific elements from data structure
      class DbDataMapper
        def initialize(data)
          @data = data
        end

        def build_entity
          Entity::Recipe.new(
            id: id,
            image: image, # rubocop:disable Style/HashSyntax
            title: title, # rubocop:disable Style/HashSyntax
            likes: likes,
            unlikes: unlikes,
            recipe_id: $DB[:recipe].where(official_id: id).get(:recipe_id),
          )
        end

        private
        def id
          @data['id'].to_i
        end

        def image
          @data['image']
        end

        def title
          @data['title']
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
