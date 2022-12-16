# frozen_string_literal: true

ENV['RACK_ENV']='test'

# require 'simplecov'
# SimpleCov.start

require 'yaml'

require 'minitest/autorun'
require 'minitest/rg'
# require 'vcr'
# require 'webmock'

CONFIG = YAML.safe_load(File.read(require_relative '../../config/secrets.yml'))
API_TOKEN = CONFIG['FOOD_API_TOKEN']
CORRECT = YAML.safe_load(File.read('spec/recipes_results.yml'))
# CASSETTES_FOLDER = 'spec/cassettes'
CASSETTES_FILE = 'food_api'
