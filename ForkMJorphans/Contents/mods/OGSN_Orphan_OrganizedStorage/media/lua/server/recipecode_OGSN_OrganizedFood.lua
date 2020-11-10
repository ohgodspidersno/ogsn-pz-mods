require "recipecode"

function Recipe.OnCreate.PackCoffeeOGSN(items, result, player)
    -- local addType = "Base.Pot"
    -- for i=0,items:size() - 1 do
    --     local item = items:get(i)
    --     if item:getType() == "PotOfSoup" or item:getType() == "PotOfSoupRecipe" or item:getType() == "RicePan" or item:getType() == "PastaPan" or item:getType() == "PastaPot"or item:getType() == "RicePot" or item:getType() == "WaterPotRice" then
    --         result:setBaseHunger(item:getBaseHunger() / 2);
    --         result:setHungChange(item:getBaseHunger() / 2);
    --         result:setThirstChange(item:getThirstChange() / 2);
    --         result:setBoredomChange(item:getBoredomChange() / 2);
    --         result:setUnhappyChange(item:getUnhappyChange() / 2);
    --         result:setCarbohydrates(item:getCarbohydrates() / 2);
    --         result:setLipids(item:getLipids() / 2);
    --         result:setProteins(item:getProteins() / 2);
    --         result:setCalories(item:getCalories() / 2);
    --         result:setTaintedWater(item:isTaintedWater())
    --         if string.contains(item:getType(), "Pan") then
    --             addType = "Base.Saucepan"
    --         end
    --     end
    -- end
    -- player:getInventory():AddItem(addType);
end

function Recipe.OnCreate.UnpackCoffeeOGSN(items, result, player)
    -- local addType = "Base.Pot"
    -- for i=0,items:size() - 1 do
    --     local item = items:get(i)
    --     if item:getType() == "PotOfSoup" or item:getType() == "PotOfSoupRecipe" or item:getType() == "RicePan" or item:getType() == "PastaPan" or item:getType() == "PastaPot"or item:getType() == "RicePot" or item:getType() == "WaterPotRice" then
    --         result:setBaseHunger(item:getBaseHunger() / 2);
    --         result:setHungChange(item:getBaseHunger() / 2);
    --         result:setThirstChange(item:getThirstChange() / 2);
    --         result:setBoredomChange(item:getBoredomChange() / 2);
    --         result:setUnhappyChange(item:getUnhappyChange() / 2);
    --         result:setCarbohydrates(item:getCarbohydrates() / 2);
    --         result:setLipids(item:getLipids() / 2);
    --         result:setProteins(item:getProteins() / 2);
    --         result:setCalories(item:getCalories() / 2);
    --         result:setTaintedWater(item:isTaintedWater())
    --         if string.contains(item:getType(), "Pan") then
    --             addType = "Base.Saucepan"
    --         end
    --     end
    -- end
    -- player:getInventory():AddItem(addType);
end
