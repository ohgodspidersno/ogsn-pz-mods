require('NPCs/MainCreationMethods');

start_items = false -- set true makes characters with nimble fingers trait start with bobby pins. Ordinarily this only occurs if the player also has profesional items on start mod
debug = false
local function initTraits()
	local nimblefingers = TraitFactory.addTrait("nimblefingers", getText("UI_trait_nimblefingers"), 0, getText("UI_trait_nimblefingersdesc"), true);
	nimblefingers:getFreeRecipes():add("Lockpicking");
	nimblefingers:getFreeRecipes():add("Create Bobby Pin");
	nimblefingers:getFreeRecipes():add("Break Door locks");
	nimblefingers:getFreeRecipes():add("Break Window locks");

	local nimblefingers2 = TraitFactory.addTrait("nimblefingers2", getText("UI_trait_nimblefingers"), 3, getText("UI_trait_nimblefingersdesc"), false, false);
	nimblefingers2:getFreeRecipes():add("Lockpicking");
	nimblefingers2:getFreeRecipes():add("Create Bobby Pin");
	nimblefingers2:getFreeRecipes():add("Break Door locks");
	nimblefingers2:getFreeRecipes():add("Break Window locks");

	TraitFactory.setMutualExclusive("nimblefingers", "nimblefingers2");
end

Events.OnGameBoot.Add(initTraits);

if debug then
	Events.OnNewGame.Add(
		function(player, square)
			player:getInventory():AddItem("FMJ.LockPickingMag")
			player:getInventory():AddItem("FMJ.LockPickingMag2")
			player:getInventory():AddItem("Base.Crowbar")
			player:getInventory():AddItem("Base.Screwdriver")
			player:getInventory():AddItem("FMJ.BobbyPin")
			player:getInventory():AddItem("FMJ.BobbyPin")
			player:getInventory():AddItem("FMJ.BobbyPin")
			player:getInventory():AddItem("FMJ.BobbyPin")
			player:getInventory():AddItem("FMJ.BobbyPin")
		end
	)
end

if getActivatedMods():contains("oka_oiosb41") or start_items then -- checks if Profesional Items on Spawn mod is installed
	Events.OnNewGame.Add(
		function(player, square)
			if player:HasTrait("nimblefingers") then
	    	player:getInventory():AddItem("FMJ.BobbyPin");
	    	player:getInventory():AddItem("FMJ.BobbyPin")
	    end
			if player:HasTrait("nimblefingers2") then
	    	player:getInventory():AddItem("FMJ.BobbyPin");
	    	player:getInventory():AddItem("FMJ.BobbyPin")
			end
		end
	)
end
