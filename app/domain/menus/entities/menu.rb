# frozen_string_literal: false

require 'dry-types'
require 'dry-struct'

require_relative 'recipe'
require_relative 'drink'

module Foodegrient
  module Entity
    # Domain entity for menu
    class Menu < Dry::Struct
      include Dry.Types

      attribute :id,          Integer.optional
      attribute :ingredients, Strict::Array.of(String)
      attribute :recipes,     Strict::Array.of(Recipe)
      attribute :drinks,      Strict::Array.of(Drink)

      def to_attr_hash
        to_hash.except(:id, :ingredients, :recipes, :drinks)
      end
    end
  end
end
