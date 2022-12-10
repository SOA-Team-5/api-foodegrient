# frozen_string_literal: true

require 'roda'

module Foodegrient
  # Web App
  class App < Roda
    plugin :halt
    plugin :flash
    plugin :common_logger, $stderr
    plugin :halt

    route do |routing|
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

      routing.on 'api/v1' do
        routing.on 'menu' do
          routing.is do
            # POST /project/
            routing.get do
              
              ori_keywords = routing.params['keywords']
              result = Spoonacular::MenuMapper
                     .new(App.config.FOOD_API_TOKEN)
                     .search(ori_keywords.split('%20'))

              message = result.recipes.to_s
              result_response = Representer::HttpResponse.new(
                Response::ApiResult.new(status: :ok, message: message) # rubocop:disable Style/HashSyntax
              )

              response.status = result_response.http_status_code
              result_response.to_json
              end
            end
          end
      end

    end
  end
end
