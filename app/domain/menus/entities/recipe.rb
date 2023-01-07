# frozen_string_literal: false

require 'dry-types'
require 'dry-struct'

module Foodegrient
  module Entity
    # Domain entity for recipe
    class Recipe < Dry::Struct
      include Dry.Types

      attribute :id,        Integer.optional
      attribute :image,     Strict::String
      attribute :title,     Strict::String
      attribute :likes,     Strict::Integer
      attribute :unlikes,   Strict::Integer
      attribute :db_recipe_id, Integer.optional

      def to_attr_hash
        to_hash.except(:id)
      end
    end
  end
end
