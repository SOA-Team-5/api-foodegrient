# frozen_string_literal: true

require 'sequel'

module Foodegrient
  module Database
    # Object-Relational Mapper for Recipe
    class DrinkOrm < Sequel::Model(:recipe)
      many_to_one :title,
                  class: :'Foodegrient::Database::MenuOrm',
                  join_table: :menu,
                  left_key: :drink_id, right_key: :menu_id

      many_to_one :image,
                  class: :'Foodegrient::Database::MenuOrm',
                  join_table: :menu,
                  left_key: :drink_id, right_key: :menu_id

      def self.find_or_create(drink)
        first(title: drink[:title]) || create(drink)
      end
    end
  end
end
