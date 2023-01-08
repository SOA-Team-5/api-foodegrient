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

    end
  end
end
