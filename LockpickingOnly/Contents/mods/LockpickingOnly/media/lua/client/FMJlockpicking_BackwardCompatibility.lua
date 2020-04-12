require('luautils');
-- This will give burglars in old saved games the recipes
Events.OnGameStart.Add(
  function(player, square)
    local playerObj = getSpecificPlayer(0)
    if playerObj:HasTrait("Burglar") then
        if not playerObj:getKnownRecipes():contains("Lockpicking") then
            playerObj:getKnownRecipes():add("Lockpicking");
        end
        if not playerObj:getKnownRecipes():contains("Create Hairpin") then
            playerObj:getKnownRecipes():add("Create Hairpin");
        end
        if not playerObj:getKnownRecipes():contains("Break Door Locks") then
            playerObj:getKnownRecipes():add("Break Door Locks");
        end
        if not playerObj:getKnownRecipes():contains("Break Window Locks") then
            playerObj:getKnownRecipes():add("Break Window Locks");
        end
    end
  end
)
