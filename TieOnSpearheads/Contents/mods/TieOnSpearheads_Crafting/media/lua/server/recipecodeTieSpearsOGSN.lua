require 'math'
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
        -- spearhead's condition
        if instanceof (item, "HandWeapon") and type ~= "SpearCrafted" and type ~= "LongSpear" and type ~= "ShovelSpear" and type ~= "Shovel2Spear" and type ~= "SpearShovel" and type ~= "SpearShovel2" then
          spearheadHP = item:getCondition();
          spearheadMaxHP = item:getConditionMax();
          spearheadHPpercent = spearheadHP/spearheadMaxHP;
        elseif type == "SharpedStone" then
          spearheadHPpercent = (ZombRand(7,11)+ZombRand(7,11))/20 -- rolls twice, takes average, divides by ten to get percentage
        end
    end

    -- get stat modifiers from player's woodworking skill and binding used
    local skillLevel, rBindingBonus, handyBonus;
    skillLevel = player:getPerkLevel(Perks.Woodwork);
    if playerObj:HasTrait("Handy") then handyBonus = 1 else handyBonus = 0 end;
    if binding == "DuctTape" or binding == "Twine" then rBindingBonus = 1  else rBindingBonus = 0 end;

    -- calculate modifier deltas
    local skillModDMG, skillModHP;
    skillModHP = math.min( math.floor((skillLevel+handyBonus+1)/2), 3) -- woodworking improves condition, maxing at +3 at lvl 5
    if skillLevel > 6 then skillModDMG = math.min( math.floor((skillLevel+handyBonus-4)/2),3 ) else skillModDMG = 0  end -- after that it improves damage maxing at +3 at lvl 6

    -- get the result item's original stats
    local rMaxHP, rMinDmg, rMaxDmg, rName;
    rMaxHP = result:getConditionMax();
    rMinDmg = result:getMinDamage();
    rMaxDmg = result:getMaxDamage();
    rName = result:getDisplayName();

    -- apply the modifier deltas to get new modified stats for the result item
    local rMaxHPnew, rMaxDmgnew, rMinDmgNew;
    rMaxHPnew = rMaxHP + skillModHP + rBindingBonus
    rMaxDmgnew = rMaxDmg + skillModDMG
    rMinDmgNew = rMinDmg + rBindingBonus

    -- calculate the result item's current HP
    local rHPpercent, rHP;
    rHPpercent = (oHPpercent +spearheadHPpercent)/2;
    rHP = math.min(rMaxHP*rHPpercent,rMaxHP);

    -- define a new name based on the modified statistics (doesn't do anything yet)
    local rNameNew;
    rNameNew = rName;

    -- assign the new stats to the result item
    result:setConditionMax(rMaxHPnew);
    result:setCondition(rHP);
    result:setMinDamage(rMinDmgNew);
    result:setMaxDamage(rMaxDmgnew);
    result:setDisplayName(rNameNew);
end

UpgradeSpear_OnCreate = Recipe.OnCreate.UpgradeSpear
