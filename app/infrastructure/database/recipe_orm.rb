# frozen_string_literal: true

require 'sequel'

module Foodegrient
  module Database
    # Object-Relational Mapper for Recipe
    class RecipeOrm < Sequel::Model(:recipe)
      many_to_one :title,
                  class: :'Foodegrient::Database::MenuOrm',
                  join_table: :menu,
                  left_key: :recipe_id, right_key: :menu_id

      many_to_one :image,
                  class: :'Foodegrient::Database::MenuOrm',
                  join_table: :menu,
                  left_key: :recipe_id, right_key: :menu_id

      def self.find_or_create(recipe)
        first(title: recipe[:title]) || create(recipe)
      end
    end
  end
end
