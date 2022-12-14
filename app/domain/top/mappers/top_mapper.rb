# frozen_string_literal: false

module Foodegrient
  # Provides access to Food data
  module DBContent
    # Data Mapper: Spoonacular recipes -> Menu entity
    class TopMapper
      def initialize()
        @top_redis = Foodegrient::Cache::Client.new().get("top")
      end

      def search()
        if @top_redis != nil
          puts(@top_redis.to_s)
          redis_data = JSON.parse(@top_redis)
          data = {:title => redis_data["title"], :image=>redis_data["image"], :likes=>redis_data["likes"]}
        else
          data = $DB[:recipe].order(:likes).offset(0).last
        end
        puts(data)
        build_entity(data.to_hash)
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
