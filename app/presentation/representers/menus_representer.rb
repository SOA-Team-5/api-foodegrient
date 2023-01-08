# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

require_relative 'menu_representer'

module Foodegrient
  module Representer
    # Represents list of projects for API output
    class MenusRepresenter < Roar::Decorator
      include Roar::JSON

      collection :recipes, extend: Representer::Menu,
                            class: Representer::Menu
      collection :drinks, extend: Representer::Drink,
                            class: Representer::Drink
    end
  end
end
