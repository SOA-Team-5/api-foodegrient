# frozen_string_literal: false

module Foodegrient
  # Provides access to Food data
  module DBContent
    # Data Mapper: Spoonacular recipes -> Menu entity
    class TopMapper
      def initialize()
      end

      def search()
        data = $DB[:recipe].order(:likes).offset(0).last
        puts(data.to_hash)
        build_entity(data)
      end

      def build_entity(data)
        DataMapper.new(data[:title], data[:image], data[:likes]).build_entity
      end

      # Extracts entity specific elements from data structure
      class DataMapper
        def initialize(title, image, likes)
          @title = title
          @image = image
          @likes = likes
        end

        def build_entity
          Foodegrient::Entity::Top.new(
            title: @title,
            image: @image,
            likes: @likes
          )
        end
      end
    end
  end
end
