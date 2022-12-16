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
      _(body['message']).must_include 'api/v1'
    end
  end

#   describe 'Get projects list' do
#     it 'should successfully return project lists' do
#       CodePraise::Service::AddProject.new.call(
#         owner_name: USERNAME, project_name: PROJECT_NAME
#       )

#       list = ["#{USERNAME}/#{PROJECT_NAME}"]
#       encoded_list = CodePraise::Request::EncodedProjectList.to_encoded(list)

#       get "/api/v1/projects?list=#{encoded_list}"
#       _(last_response.status).must_equal 200

#       response = JSON.parse(last_response.body)
#       projects = response['projects']
#       _(projects.count).must_equal 1
#       project = projects.first
#       _(project['name']).must_equal PROJECT_NAME
#       _(project['owner']['username']).must_equal USERNAME
#       _(project['contributors'].count).must_equal 3
#     end

#   end
end