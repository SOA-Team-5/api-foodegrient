# frozen_string_literal: false

require 'dry-types'
require 'dry-struct'

module Foodegrient
  module Entity
    # Domain entity for menu
    class Top < Dry::Struct
      include Dry.Types

      attribute :title,          Strict::String
      attribute :image,          Strict::String
      attribute :likes,          Strict::Integer

      def to_attr_hash
        to_hash.except(:title, :image, :likes)
      end
    end
  end
end
