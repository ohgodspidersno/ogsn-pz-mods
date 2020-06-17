
function MakeBowlOfStirFry2_OnCreate(items, result, player)
    for i=0,items:size() - 1 do
        if items:get(i):getType() == "PanFriedVegetables" then
            result:setBaseHunger(items:get(i):getBaseHunger() / 2);
            result:setHungChange(items:get(i):getBaseHunger() / 2);
            result:setThirstChange(items:get(i):getThirstChange() / 2);
            result:setBoredomChange(items:get(i):getBoredomChange() / 2);
            result:setUnhappyChange(items:get(i):getUnhappyChange() / 2);
            result:setCarbohydrates(items:get(i):getCarbohydrates() / 2);
            result:setLipids(items:get(i):getLipids() / 2);
            result:setProteins(items:get(i):getProteins() / 2);
            result:setCalories(items:get(i):getCalories() / 2);
            result:setTaintedWater(items:get(i):isTaintedWater())
        end
    end
    player:getInventory():AddItem("Base.Pan");
end

function MakeBowlOfStirFry4_OnCreate(items, result, player)
    for i=0,items:size() - 1 do
        if items:get(i):getType() == "PanFriedVegetables" then
            result:setBaseHunger(items:get(i):getBaseHunger() / 4);
            result:setHungChange(items:get(i):getBaseHunger() / 4);
            result:setThirstChange(items:get(i):getThirstChange() / 4);
            result:setBoredomChange(items:get(i):getBoredomChange() / 4);
            result:setUnhappyChange(items:get(i):getUnhappyChange() / 4);
            result:setCarbohydrates(items:get(i):getCarbohydrates() / 4);
            result:setLipids(items:get(i):getLipids() / 4);
            result:setProteins(items:get(i):getProteins() / 4);
            result:setCalories(items:get(i):getCalories() / 4);
            result:setTaintedWater(items:get(i):isTaintedWater())
        end
    end
    player:getInventory():AddItem("Base.Pan");
end


function MakeBowlOfStirFryGridle2_OnCreate(items, result, player)
    for i=0,items:size() - 1 do
        if items:get(i):getType() == "GriddlePanFriedVegetables" then
            result:setBaseHunger(items:get(i):getBaseHunger() / 2);
            result:setHungChange(items:get(i):getBaseHunger() / 2);
            result:setThirstChange(items:get(i):getThirstChange() / 2);
            result:setBoredomChange(items:get(i):getBoredomChange() / 2);
            result:setUnhappyChange(items:get(i):getUnhappyChange() / 2);
            result:setCarbohydrates(items:get(i):getCarbohydrates() / 2);
            result:setLipids(items:get(i):getLipids() / 2);
            result:setProteins(items:get(i):getProteins() / 2);
            result:setCalories(items:get(i):getCalories() / 2);
            result:setTaintedWater(items:get(i):isTaintedWater())
        end
    end
    player:getInventory():AddItem("Base.GridlePan");
end

function MakeBowlOfStirFryGridle4_OnCreate(items, result, player)
    for i=0,items:size() - 1 do
        if items:get(i):getType() == "GriddlePanFriedVegetables" then
            result:setBaseHunger(items:get(i):getBaseHunger() / 4);
            result:setHungChange(items:get(i):getBaseHunger() / 4);
            result:setThirstChange(items:get(i):getThirstChange() / 4);
            result:setBoredomChange(items:get(i):getBoredomChange() / 4);
            result:setUnhappyChange(items:get(i):getUnhappyChange() / 4);
            result:setCarbohydrates(items:get(i):getCarbohydrates() / 4);
            result:setLipids(items:get(i):getLipids() / 4);
            result:setProteins(items:get(i):getProteins() / 4);
            result:setCalories(items:get(i):getCalories() / 4);
            result:setTaintedWater(items:get(i):isTaintedWater())
        end
    end
    player:getInventory():AddItem("Base.GridlePan");
end

function MakeBowlOfRoastedVegetables2_OnCreate(items, result, player)
    for i=0,items:size() - 1 do
        if items:get(i):getType() == "PanFriedVegetables2" then
            result:setBaseHunger(items:get(i):getBaseHunger() / 2);
            result:setHungChange(items:get(i):getBaseHunger() / 2);
            result:setThirstChange(items:get(i):getThirstChange() / 2);
            result:setBoredomChange(items:get(i):getBoredomChange() / 2);
            result:setUnhappyChange(items:get(i):getUnhappyChange() / 2);
            result:setCarbohydrates(items:get(i):getCarbohydrates() / 2);
            result:setLipids(items:get(i):getLipids() / 2);
            result:setProteins(items:get(i):getProteins() / 2);
            result:setCalories(items:get(i):getCalories() / 2);
            result:setTaintedWater(items:get(i):isTaintedWater())
        end
    end
    player:getInventory():AddItem("Base.RoastingPan");
end

function MakeBowlOfRoastedVegetables4_OnCreate(items, result, player)
    for i=0,items:size() - 1 do
        if items:get(i):getType() == "PanFriedVegetables2" then
            result:setBaseHunger(items:get(i):getBaseHunger() / 4);
            result:setHungChange(items:get(i):getBaseHunger() / 4);
            result:setThirstChange(items:get(i):getThirstChange() / 4);
            result:setBoredomChange(items:get(i):getBoredomChange() / 4);
            result:setUnhappyChange(items:get(i):getUnhappyChange() / 4);
            result:setCarbohydrates(items:get(i):getCarbohydrates() / 4);
            result:setLipids(items:get(i):getLipids() / 4);
            result:setProteins(items:get(i):getProteins() / 4);
            result:setCalories(items:get(i):getCalories() / 4);
            result:setTaintedWater(items:get(i):isTaintedWater())
        end
    end
    player:getInventory():AddItem("Base.RoastingPan");
end
