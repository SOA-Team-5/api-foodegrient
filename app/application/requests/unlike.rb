require 'json'

module Foodegrient
    module Request
        class UpdateUnlikes
          def initialize(id)
            @id = id
          end

          def unlikeRecipe()
            res = $DB[:recipe].select(:recipe_id, :official_id, :unlikes).where(recipe_id: @id)
            unlikes_num = res.get(:unlikes).to_i
            res.update(unlikes:(unlikes_num +1))
          end

          def unlikeDrink()
            res = $DB[:drink].select(:id, :origin_id, :unlikes).where(id: @id)
            unlikes_num = res.get(:unlikes).to_i
            res.update(unlikes:(unlikes_num +1))
          end
        end
    end
end
