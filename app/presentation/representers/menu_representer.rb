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

      property :title
      property :image


      private

      def title
        represented.title
      end

      def image
        represented.image
      end
    end
  end
end