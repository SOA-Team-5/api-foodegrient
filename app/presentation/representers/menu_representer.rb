# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

module Foodegrient
  module Representer
    # Represent a Project entity as Json
    class Menu < Roar::Decorator
      include Roar::JSON
    #   include Roar::Hypermedia
    #   include Roar::Decorator::HypermediaConsumer
      property :id
      property :title
      property :image
      property :likes
      property :unlikes
      property :recipe_id

      private

      def id
        represented.id
      end

      def title
        represented.title
      end

      def image
        represented.image
      end

      def likes
        represented.likes
      end

      def unlikes
        represented.unlikes
      end

      def recipe_id
        represented.recipe_id
      end
    end
  end
end
