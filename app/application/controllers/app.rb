# frozen_string_literal: true

require 'roda'
require 'slim'
require 'slim/include'

module Foodegrient
  # Web App
  class App < Roda
    plugin :halt
    plugin :flash
    plugin :render, engine: 'slim', views: 'app/presentation/views_html'
    plugin :assets, css: 'style.css', path: 'app/presentation/assets'
    plugin :common_logger, $stderr
    plugin :halt

    route do |routing|
      routing.assets # load CSS
      response['Content-Type'] = 'text/html; charset=utf-8'

      # GET /
      routing.root do
        session[:watching] ||= []
        
        empty_check = session[:watching]
        
        
        if empty_check[0]==false
          session[:watching].insert(0, true).uniq!
          flash[:error] = 'Input Error: empty input or formatting error'
          routing.redirect "/"
        end
        view 'home'
      end

      routing.on 'menu' do
        routing.is do
          # POST /project/
          routing.post do
            ori_keywords = routing.params['keywords']
            if (ori_keywords.length == 0 || Forms::NewQuery.new.call(ingredients:ori_keywords.split(' ')).failure?)
              session[:watching].insert(0, false).uniq!
              response.status = 400
              routing.redirect "../"
            else
              session[:watching].insert(0, true).uniq!
              routing.redirect "menu/#{ori_keywords}"
            end
            
          end
        end

        routing.on String do |keywords|
          # GET /menu/result/keywords
          routing.get do
            result = Spoonacular::MenuMapper
                     .new(App.config.FOOD_API_TOKEN)
                     .search(keywords.split('%20'))

            results_list = Views::ResultsList.new(keywords, result)

            view('result', locals: { results_list: results_list }) # rubocop:disable Style/HashSyntax
          end
        end
      end
    end
  end
end
