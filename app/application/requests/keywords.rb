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
        # @menus = Spoonacular::MenuMapper
        #   .new(App.config.FOOD_API_TOKEN)
        #   .build_entity(@keywords)

        # @recipes = @menus.recipes
        # @drinks = @menus.drinks
        # @menus


        @joined_table = $DB[:recipe].join_table(:inner, ($DB[:match].join_table(:inner, $DB[:menu], menu_id: :menu_id)), detail_id: :recipe_id)

        @drink_joined_table = $DB[:drink].join_table(:inner, ($DB[:match].join_table(:inner, $DB[:menu], menu_id: :menu_id)), detail_id: :id)
        check_result = @joined_table.where(ingredients: ori_keywords)
        drink_check_result = @drink_joined_table.where(ingredients: ori_keywords)
        if check_result.count<1 && drink_check_result<1
          @menus = Spoonacular::MenuMapper
            .new(App.config.FOOD_API_TOKEN)
            .build_entity(@keywords)
          $DB[:menu].insert_ignore.multi_insert([{ingredients: @keywords}])

          @recipes = @menus.recipes
          @drinks = @menus.drinks
          @menu_id = $DB[:menu].where(ingredients: @keywords).get(:menu_id)
          for e in @recipes
            $DB[:match].insert_ignore.multi_insert([{menu_id: @menu_id, detail_id: e.db_recipe_id, type: 0}])
          end

          for e in @drinks
            $DB[:match].insert_ignore.multi_insert([{menu_id: @menu_id, detail_id: e.drink_id, type: 1}])
          end
          self.request_handle_img_worker(@menu_id)
          
          @menus
        else
          recipe_temp = []
          check_result.each do |row|
            @hash_row = row
            recipe_temp.push({"id"=> @hash_row[:official_id], "image"=> @hash_row[:image], "title"=> @hash_row[:title], "likes"=> @hash_row[:likes].to_i})
          end
          @db_recipe_mapper = Spoonacular::DbRecipeMapper.new(recipe_temp).load_several

          drink_temp = []
          drink_check_result.each do |row|
            @drink_hash_row = row
            drink_temp.push({"id"=> @drink_hash_row[:origin_id], "image"=> @drink_hash_row[:image], "name"=> @drink_hash_row[:name]})
          end
          @db_drink_mapper = CocktailDb::DbDrinkMapper.new(drink_temp).load_several
          @drinks = @db_drink_mapper
          @recipes = @db_recipe_mapper
        end
      end

      def request_handle_img_worker(menu_id)
        Messaging::Queue
          .new(App.config.HANDLE_IMG_QUEUE_URL, App.config)
          .send({:menu_id=>menu_id}.to_json)
      rescue StandardError => e
        print_error(e)
        Failure(Response::ApiResult.new(status: :internal_error, message: CLONE_ERR))
      end

      attr_reader :keywords, :menus, :recipes, :drinks
    end
  end
end
