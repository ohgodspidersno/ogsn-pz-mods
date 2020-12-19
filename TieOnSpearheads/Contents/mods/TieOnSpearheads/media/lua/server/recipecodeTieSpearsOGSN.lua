Recipe = Recipe or {}
Recipe.OnCreate = Recipe.OnCreate or {}

function Recipe.OnCreate.UpgradeSpear(items, result, player, selectedItem)
    -- Get the stats of the original spear, spearhead, and binding
    local binding, oHP, oMaxHP, oHPpercent, spearheadHP, spearheadMaxHP, spearheadHPpercent;
    for i=0,items:size() - 1 do
        local item = items:get(i);
        local type = item:getType();
        -- original spear's condition (checks for spears from MorePoleWeapons, too)
        if type == "SpearCrafted" or type == "LongSpear" or type == "ShovelSpear" or type == "Shovel2Spear" or type == "SpearShovel" or type == "SpearShovel2" then
            oHP = item:getCondition();
            oMaxHP = item:getConditionMax();
            oHPpercent = oHP/oMaxHP;
        end
        -- binding used
        binding = type if type=="DuctTape" or type=="Twine" or type=="LeatherStrips" else end
        -- spearhead's stats and condition
        if instanceof (item, "HandWeapon") and type ~= "SpearCrafted" and type ~= "LongSpear" and type ~= "ShovelSpear" and type ~= "Shovel2Spear" and type ~= "SpearShovel" and type ~= "SpearShovel2" then
          spearheadHP = item:getCondition();
          spearheadMaxHP = item:getConditionMax();
          spearheadHPpercent = spearheadHP/spearheadMaxHP;
        elseif type == "SharpedStone" then
          spearheadHPpercent = (ZombRand(7,11)*2)/20
        end
    end

    -- get final quality modifiers from player stats and chance
    local skillLevel = player:getPerkLevel(Perks.Woodwork);
    local skillModHP = skillLevel/5 -- woodworking improves condition, maxing at lvl 5
    local skillModDMG = (skillLevel%5) -- woodworking lvls 6-10 improve damage, too
    local chanceDelta = ZombRand(-1,1);

    -- get the product's base stats
    local rMaxHP = result:getConditionMax();
    local rMinDmg = result:getMinDamage();
    local rMaxDmg = result:getMaxDamage();
    local rName = result:getDisplayName();

    -- define the final modified stats of the resulting spear
    local rHP, rMinDmgNew, rMaxDmgNew, rNameNew

    -----------------------------
    --- do calculations here ----
    -----------------------------

    result:setCondition(rHP)
    result:setMinDamage(rMinDmgNew)
    result:setMaxDamage(rMaxNew)
    result:setDisplayName(rNameNew)
end

UpgradeSpear_OnCreate = Recipe.OnCreate.UpgradeSpear
