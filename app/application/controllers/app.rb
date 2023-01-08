# frozen_string_literal: true

require 'roda'
require_relative '../../domain/top/mappers/top_mapper'
require 'aws-sdk-s3'
require 'securerandom'

module Foodegrient
  # Web App
  class App < Roda
    plugin :halt
    plugin :flash
    plugin :common_logger, $stderr
    plugin :halt
    plugin :default_headers,
    'Access-Control-Allow-Origin'=>'*'

    route do |routing| # rubocop:disable Metrics/BlockLength
      response['Content-Type'] = 'application/json'

      # GET /
      routing.root do
        message = "Foodegrient API v1 at /api/v1/ in #{App.environment} mode"
        result_response = Representer::HttpResponse.new(
          Response::ApiResult.new(status: :ok, message: message) # rubocop:disable Style/HashSyntax
        )

        response.status = result_response.http_status_code
        result_response.to_json
      end

      routing.on 'api/v1' do # rubocop:disable Metrics/BlockLength
        routing.on 'menu' do
          routing.is do
            # POST /project/
            routing.get do
              ori_keywords = routing.params['keywords']
              # api_result = Spoonacular::MenuMapper
              #        .new(App.config.FOOD_API_TOKEN)
              #        .search(ori_keywords.split('%20'))
              list = Foodegrient::Request::Keywords.new(ori_keywords)
              message = ''
              result_response = Representer::HttpResponse.new(
                Response::ApiResult.new(status: :ok, message: message) # rubocop:disable Style/HashSyntax
              )

              response.status = result_response.http_status_code
              result_response.to_json
              Representer::MenusRepresenter.new(
                list
              ).to_json
            end
          end
        end

        routing.on 'recipes' do
          routing.on 'unlike' do
            routing.get do
              id = routing.params['id']
              puts(id)
  
              Foodegrient::Request::UpdateUnlikes.new(id).unlikeRecipe()
  
              result_response = Representer::HttpResponse.new(
                Response::ApiResult.new(status: :ok, message: id + ' unliked') # rubocop:disable Style/HashSyntax
              )
  
              response.status = result_response.http_status_code
              result_response.to_json
            end
          end
  
          routing.on 'like' do
            routing.get do
              id = routing.params['id']
              puts(id)
  
              Foodegrient::Request::UpdateLikes.new(id).likeRecipe()
  
              result_response = Representer::HttpResponse.new(
                Response::ApiResult.new(status: :ok, message: id + ' liked') # rubocop:disable Style/HashSyntax
              )
              response.status = result_response.http_status_code
              result_response.to_json
            end
          end
        end

        routing.on 'drinks' do
          routing.on 'unlike' do
            routing.get do
              id = routing.params['id']
              puts(id)
  
              Foodegrient::Request::UpdateUnlikes.new(id).unlikeDrink()
  
              result_response = Representer::HttpResponse.new(
                Response::ApiResult.new(status: :ok, message: id + ' unliked') # rubocop:disable Style/HashSyntax
              )
  
              response.status = result_response.http_status_code
              result_response.to_json
            end
          end
  
          routing.on 'like' do
            routing.get do
              id = routing.params['id']
              puts(id)
  
              Foodegrient::Request::UpdateLikes.new(id).likeDrink()
  
              result_response = Representer::HttpResponse.new(
                Response::ApiResult.new(status: :ok, message: id + ' liked') # rubocop:disable Style/HashSyntax
              )
              response.status = result_response.http_status_code
              result_response.to_json
            end
          end
        end

        routing.on 'top' do
          # POST /project/
          routing.get do
            result = DBContent::TopMapper.new.search

            Representer::TopRepresenter.new(
              result
            ).to_json
          end
        end

        
      end
    end
  end
end
