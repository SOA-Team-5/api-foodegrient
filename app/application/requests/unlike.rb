require 'json'


module Foodegrient
    module Request
        class UpdateUnlikes
          def initialize(id)
            @id = id
          end

          def unlikeRecipe()
            res = $DB[:recipe].select(:recipe_id, :official_id, :unlikes).where(official_id: @id)
            unlikes_num = res.get(:unlikes).to_i
            res.update(unlikes:(unlikes_num +1))
          end
        end
    end
end
