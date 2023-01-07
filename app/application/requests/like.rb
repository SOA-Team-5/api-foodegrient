require 'json'

module Foodegrient
    module Request
        class UpdateLikes
          def initialize(id)
            @id = id
          end

          def likeRecipe()
            res = $DB[:recipe].select(:recipe_id, :official_id, :likes).where(recipe_id: @id)
            likes_num = res.get(:likes).to_i
            res.update(likes:(likes_num +1))
          end
        end
    end
end
