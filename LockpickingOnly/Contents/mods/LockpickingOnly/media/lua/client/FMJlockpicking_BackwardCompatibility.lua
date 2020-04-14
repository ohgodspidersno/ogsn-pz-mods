-- This will give burglars in old saved games the recipes
local function GiveTraitsToExistingBurglars() = function(playerObj, playerSquare)
    local learned_recipes = playerObj:getKnownRecipes()
    if playerObj:getTraits():contains('Burglar') then
        if not learned_recipes:contains("Lockpicking") then
            learned_recipes:add("Lockpicking");
        end
        if not learned_recipes:contains("Create Hairpin") then
            learned_recipes:add("Create Hairpin");
        end
        if not learned_recipes:contains("Break Door Locks") then
            learned_recipes:add("Break Door Locks");
        end
        if not learned_recipes:contains("Break Window Locks") then
            learned_recipes:add("Break Window Locks");
        end
    end
end
Events.OnGameStart.Add( GiveTraitsToExistingBurglars );

-- REFERENCE SNIPPETS FROM ELSEWHERE
-- self.character:getKnownRecipes():add("Lockpicking");
-- self.character:getKnownRecipes():add("Create Hairpin");
-- self.character:getKnownRecipes():add("Break Door Locks");
-- self.character:getKnownRecipes():add("Break Window Locks");
-- playerObj:getInventory():AddItem(v);
-- :getTraits():contains(trait:getType()) then

-- ISSafetyUI.onNewGame = function(playerObj, playerSquare)
--     if not isClient() then return end
--     if getServerOptions():getOption("SpawnItems") and getServerOptions():getOption("SpawnItems")~= "" then
--         local items = luautils.split(getServerOptions():getOption("SpawnItems"), ",");
--         for i,v in pairs(items) do
--             playerObj:getInventory():AddItem(v);
--         end
--     end
-- end

  -- playerObj:getInventory():AddItem(v);
    -- if isServer() or isClient() then return end
    -- local main = ErosionMain.getInstance()
    -- if not main:getConfig():getDebug():getEnabled() then return end
    -- EDebug.DemoTime(main):GameStart()

-- Events.OnNewGame.Add(ISSafetyUI.onNewGame);
