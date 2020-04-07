require('NPCs/MainCreationMethods');

start_items = false -- set true makes characters with nimble fingers trait start with hairpins. Ordinarily this only occurs if the player also has profesional items on start mod
debug = false
local function initTraits()
	local nimblefingers = TraitFactory.addTrait("nimblefingers", getText("UI_trait_nimblefingers"), 0, getText("UI_trait_nimblefingersDesc"), true);
	nimblefingers:getFreeRecipes():add("Lockpicking");
	nimblefingers:getFreeRecipes():add("Create Hairpin");
	nimblefingers:getFreeRecipes():add("Break Door Locks");
	nimblefingers:getFreeRecipes():add("Break Window Locks");

	local nimblefingers2 = TraitFactory.addTrait("nimblefingers2", getText("UI_trait_nimblefingers"), 3, getText("UI_trait_nimblefingersDesc"), false, false);
	nimblefingers2:getFreeRecipes():add("Lockpicking");
	nimblefingers2:getFreeRecipes():add("Create Hairpin");
	nimblefingers2:getFreeRecipes():add("Break Door Locks");
	nimblefingers2:getFreeRecipes():add("Break Window Locks");

	TraitFactory.setMutualExclusive("nimblefingers", "nimblefingers2");
end

Events.OnGameBoot.Add(initTraits);

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
