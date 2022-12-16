# frozen_string_literal: true

require 'dry-validation'

module Foodegrient
  module Forms
    class NewQuery < Dry::Validation::Contract

      params do
        required(:ingredients).value(:array, size?: 1..3).each(:string)
      end

      rule(:ingredients) do
        value.each do |ingredient|
          unless value.select { |c| c == ingredient }.size == 1
            key.failure('ingredient must be unique')
          end
        end
      end

    end
  end
end

contract = Foodegrient::Forms::NewQuery.new

puts contract.call(ingredients:['123', '123', 'abc']).errors.to_h
