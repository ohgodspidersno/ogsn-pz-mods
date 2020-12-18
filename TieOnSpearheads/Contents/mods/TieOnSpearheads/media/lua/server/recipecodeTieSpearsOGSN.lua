Recipe = Recipe or {}
Recipe.OnCreate = Recipe.OnCreate or {}


function Recipe.OnCreate.UpgradeSpear(items, result, player, selectedItem)
    local conditionMax = 0;
    for i=0,items:size() - 1 do
        if items:get(i):getType() == "SpearCrafted" then
            conditionMax = items:get(i):getCondition()
        end
    end

    for i=0,items:size() - 1 do
        if instanceof (items:get(i), "HandWeapon") and items:get(i):getType() ~= "SpearCrafted" then
            conditionMax = conditionMax - ((items:get(i):getConditionMax() - items:get(i):getCondition())/2)
        elseif items:get(i):getType() == "SharpedStone" then
            conditionMax = conditionMax*2 + ZombRand(-1,2) -- A perfect 5 will become a perfect 10. fuzzed +/-1 by chance.
        end
    end

    if conditionMax > result:getConditionMax() then
        conditionMax = result:getConditionMax();
    end
    if conditionMax < 2 then
        conditionMax = 2;
    end

    result:setCondition(conditionMax);
end

UpgradeSpear_OnCreate = Recipe.OnCreate.UpgradeSpear
