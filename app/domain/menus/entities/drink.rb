# frozen_string_literal: false

require 'dry-types'
require 'dry-struct'

module Foodegrient
  module Entity
    # Domain entity for recipe
    class Drink < Dry::Struct
      include Dry.Types

      attribute :id,        Integer.optional
      attribute :name,     Strict::String
      attribute :image,     Strict::String
      attribute :drink_id,  Integer.optional
      def to_attr_hash
        to_hash.except(:id)
      end
    end
  end
end
