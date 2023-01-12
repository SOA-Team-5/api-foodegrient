# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

module Foodegrient
  module Representer
    # Represent a Project entity as Json
    class Drink < Roar::Decorator
      include Roar::JSON
    #   include Roar::Hypermedia
    #   include Roar::Decorator::HypermediaConsumer
      property :id
      property :name
      property :image
      property :likes
      property :unlikes
      property :drink_id

      private

      def id
        represented.id
      end

      def name
        represented.name
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

      def drink_id
        represented.drink_id
      end
    end
  end
end
