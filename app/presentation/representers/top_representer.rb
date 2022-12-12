# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

module Foodegrient
  module Representer
    # Represent a Project entity as Json
    class TopRepresenter < Roar::Decorator
      include Roar::JSON
    #   include Roar::Hypermedia
    #   include Roar::Decorator::HypermediaConsumer
      property :title
      property :image
      property :likes

      private

      def title
        represented.title
      end

      def image
        represented.image
      end

      def likes
        represented.likes
      end
    end
  end
end