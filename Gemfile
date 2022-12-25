# frozen_string_literal: true

source 'https://rubygems.org'

ruby '3.1.2'

# Configuration and Utilities
gem 'figaro', '~> 1.2'
gem 'rack-test'
gem 'rake'

group :production do
  gem 'pg'
end

# PRESENTATION LAYER
gem 'multi_json', '~> 1.15'
gem 'roar', '~> 1.1'

# Web Application
gem 'puma', '~> 6'
gem 'rack-session', '~> 0.3'
gem 'roda', '~> 3'

# Controllers and services
gem 'dry-monads', '~> 1.4'
gem 'dry-transaction', '~> 0.13'
gem 'dry-validation', '~> 1.7'

# Validation
gem 'dry-struct', '~> 1'
gem 'dry-types', '~> 1'

# Networking
gem 'http', '~> 5'

# Database
gem 'hirb', '~> 0'
gem 'hirb-unicode', '~> 0'
gem 'sequel', '~> 5.49'

# Asynchronicity
gem 'concurrent-ruby', '~> 1.1'
gem 'aws-sdk-sqs', '~> 1.48'
gem 'shoryuken', '~> 5.3'

group :development, :test do
  gem 'sqlite3', '~> 1.4'
end

# Testing
group :test do
  gem 'minitest', '~> 5'
  gem 'minitest-rg', '~> 5'
  gem 'simplecov', '~> 0'
  gem 'vcr', '~> 6'
  gem 'webmock', '~> 3'
end

group :development do
  gem 'rerun', '~> 0'
end

# Debugging
gem 'pry'

# Code Quality
group :development do
  gem 'flog'
  gem 'reek'
  gem 'rubocop'
end

# Caching
gem 'rack-cache', '~> 1.13'
gem 'redis', '~> 4.8'
gem 'redis-rack-cache', '~> 2.2'

gem 'aws-sdk-s3'
gem 'httpclient'
gem 'securerandom'