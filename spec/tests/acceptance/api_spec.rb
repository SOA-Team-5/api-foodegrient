# frozen_string_literal: true

require_relative '../../helpers/spec_helper'
# require_relative '../../helpers/vcr_helper'
# require_relative '../../helpers/database_helper'
require 'rack/test'

def app
  Foodegrient::App
end

describe 'Test API routes' do
  include Rack::Test::Methods

#   VcrHelper.setup_vcr

#   before do
#     VcrHelper.configure_vcr_for_github
#     DatabaseHelper.wipe_database
#   end

#   after do
#     VcrHelper.eject_vcr
#   end

  describe 'Root route' do
    it 'should successfully return root information' do
      get '/'
      _(last_response.status).must_equal 200

      body = JSON.parse(last_response.body)
      _(body['status']).must_equal 'ok'
      # _(body['message']).must_include 'api/v1'
    end
  end

  describe 'Top recipe' do
    it 'should successfully return the top recipe' do
      get '/api/v1/top'
      _(last_response.status).must_equal 200

      body = JSON.parse(last_response.body)
      _(body['title']) != nil
      _(body['image']).must_include '.jpg'
      _(body['likes']) != nil
    end
  end

  describe 'Search menu' do
    it 'should successfully return the top recipe' do
      get '/api/v1/menu?keywords=apple'
      _(last_response.status).must_equal 200

      body = JSON.parse(last_response.body)
      body['recipe'] do |n|
        if n.id == 673463
          _(n.title).must_equal 'Slow Cooker Apple Pork Tenderloin'
          _(n.image).must_equal 'https://spoonacular.com/recipeImages/673463-312x231.jpg'
        end
        if n.id == 660261
          _(n.title).must_equal 'Slow Cooked Applesauce'
          _(n.image).must_equal 'https://spoonacular.com/recipeImages/660261-312x231.jpg'
        end
      end
    end
  end
end