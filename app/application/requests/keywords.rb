# frozen_string_literal: true

require 'dry/monads'
require 'json'
require_relative '../../domain/menus/mappers/db_recipe_mapper'

module Foodegrient
  module Request
    # Retrieves array of all listed project entities
    class Keywords
      def initialize(ori_keywords)
        @keywords = ori_keywords.split('%20')

        @joined_table = $DB[:recipe].join_table(:inner, ($DB[:match].join_table(:inner, $DB[:menu], menu_id: :menu_id)), detail_id: :recipe_id)
        check_result = @joined_table.where(ingredients: ori_keywords)
        if check_result.count<1
          @menus = Spoonacular::MenuMapper
          .new(App.config.FOOD_API_TOKEN)
          .search(@keywords)
          $DB[:menu].insert_ignore.multi_insert([{ingredients: @keywords}])

          @recipes = @menus.recipes
          for e in @recipes
            $DB[:match].insert_ignore.multi_insert([{menu_id: $DB[:menu].where(ingredients: @keywords).get(:menu_id), detail_id: e.db_recipe_id, type: 0}])
          end
          @recipes
        else
          temp = []
          check_result.each do |row|
            @hash_row = row
            temp.push({"id"=> @hash_row[:official_id], "image"=> @hash_row[:image], "title"=> @hash_row[:title], "likes"=> @hash_row[:likes].to_i})
          end
          @db_recipe_mapper = Spoonacular::DbRecipeMapper.new(temp).load_several
          @recipes = @db_recipe_mapper
        end
      end

      attr_reader :keywords, :menus, :recipes
    end
  end
end