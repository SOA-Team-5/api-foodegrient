# frozen_string_literal: true

require_relative '../require_app'
require_relative '../app/infrastructure/gateways/s3'
require_relative '../app/domain/menus/mappers/db_recipe_mapper'
require_app

require 'figaro'
require 'shoryuken'
require "aws-sdk-s3"
require 'securerandom'
require 'json'

# Shoryuken worker class to clone repos in parallel
class ImageWorker
  # Environment variables setup
  Figaro.application = Figaro::Application.new(
    environment: ENV['RACK_ENV'] || 'development',
    path: File.expand_path('config/secrets.yml')
  )
  Figaro.load
  def self.config() = Figaro.env

  Shoryuken.sqs_client = Aws::SQS::Client.new(
    access_key_id: config.AWS_ACCESS_KEY_ID,
    secret_access_key: config.AWS_SECRET_ACCESS_KEY,
    region: config.AWS_REGION,
  )

  include Shoryuken::Worker
  shoryuken_options queue: config.HANDLE_IMG_QUEUE, auto_delete: true

  def perform(_sqs_msg, request)
    puts(JSON.parse(request).to_s)
    @joined_table = $DB[:recipe].join_table(:inner, $DB[:match], detail_id: :recipe_id)
    check_result = @joined_table.where(menu_id: JSON.parse(request)['menu_id'])

    time = Time.new
    temp = []
    check_result.each do |row|
      @hash_row = row
      temp.push({"id"=> @hash_row[:official_id], "image"=> @hash_row[:image], "title"=> @hash_row[:title], "likes"=> @hash_row[:likes].to_i})
    end
    @db_recipe_mapper = Foodegrient::Spoonacular::DbRecipeMapper.new(temp).load_several
    @recipes = @db_recipe_mapper

    for e in @recipes
      uuid = SecureRandom.uuid
      img_url = "img/" + time.year.to_s + "/" + time.month.to_s + "/" + uuid + ".jpg"
      wrapper = ObjectPutWrapper.new(Aws::S3::Object.new("foodegrient", img_url ,options={client: $CFR2}))
      success = wrapper.put_object(e.image)

      $DB[:recipe].where{{:image=>e.image}}.update(:image=>("https://pub-549992979d37433da73eb7c04f3d376b.r2.dev/" + img_url))
    end

    drink_temp = []
    drink_check_result.each do |row|
      @drink_hash_row = row
      drink_temp.push({"id"=> @drink_hash_row[:origin_id], "image"=> @drink_hash_row[:image], "name"=> @drink_hash_row[:name], "likes"=> @drink_hash_row[:likes].to_i, "unlikes"=> @drink_hash_row[:unlikes].to_i})
    end
    @db_drink_mapper = Foodegrient::CocktailDb::DbDrinkMapper.new(drink_temp).load_several
    @drinks = @db_drink_mapper

    for e in @drinks
      uuid = SecureRandom.uuid
      img_url = "img/" + time.year.to_s + "/" + time.month.to_s + "/" + uuid + ".jpg"
      wrapper = ObjectPutWrapper.new(Aws::S3::Object.new("foodegrient", img_url ,options={client: $CFR2}))
      success = wrapper.put_object(e.image)
  
      $DB[:drink].where{{:image=>e.image}}.update(:image=>("https://pub-549992979d37433da73eb7c04f3d376b.r2.dev/" + img_url))
    end
  end
end
