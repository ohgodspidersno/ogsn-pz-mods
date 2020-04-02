require('NPCs/MainCreationMethods');

local function initTraits()
	local archer = TraitFactory.addTrait("archer", getText("UI_trait_archer"), 6, getText("UI_trait_archerdesc"), false, false);
	archer:addXPBoost(Perks.Aiming, 1);
	archer:addXPBoost(Perks.Reloading, 2);
	
	local forager = TraitFactory.addTrait("forager", getText("UI_trait_forager"), 6, getText("UI_trait_foragerdesc"), false, false);
	forager:addXPBoost(Perks.PlantScavenging, 2);
	forager:addXPBoost(Perks.Farming, 1);
	
	local nimblefingers = TraitFactory.addTrait("nimblefingers", getText("UI_trait_nimblefingers"), 0, getText("UI_trait_nimblefingersdesc"), true);
	local nimblefingers = TraitFactory.addTrait("nimblefingers2", getText("UI_trait_nimblefingers"), 3, getText("UI_trait_nimblefingersdesc"), false, false);
		TraitFactory.setMutualExclusive("nimblefingers", "nimblefingers2");
		
	local bookworm = TraitFactory.addTrait("Bookworm", getText("UI_trait_bookworm"), 5, getText("UI_trait_bookwormdesc"), false, false);
		TraitFactory.setMutualExclusive("Bookworm", "FastReader");
		TraitFactory.setMutualExclusive("Bookworm", "SlowReader");
		TraitFactory.setMutualExclusive("Bookworm", "Illiterate");
	
	local cook = TraitFactory.addTrait("Cook", getText("UI_trait_Cook"), 6, getText("UI_trait_CookDesc"), false);
    cook:addXPBoost(Perks.Cooking, 2)
    cook:getFreeRecipes():add("Make Cake Batter");
    cook:getFreeRecipes():add("Make Pie Dough");
    cook:getFreeRecipes():add("Make Bread Dough");
	cook:getFreeRecipes():add("Make Butter");
	cook:getFreeRecipes():add("Prepare Cheese");
	cook:getFreeRecipes():add("Make Cheese");
	cook:getFreeRecipes():add("Prepare Yogurt");
	cook:getFreeRecipes():add("Make Yogurt");
	
    local cook2 = TraitFactory.addTrait("Cook2", getText("UI_trait_Cook"), 0, getText("UI_trait_Cook2Desc"), true);
	cook2:getFreeRecipes():add("Make Butter");
	cook2:getFreeRecipes():add("Prepare Cheese");
	cook2:getFreeRecipes():add("Make Cheese");
	cook2:getFreeRecipes():add("Prepare Yogurt");
	cook:getFreeRecipes():add("Make Yogurt");
	end
Events.OnGameBoot.Add(initTraits);

Events.OnNewGame.Add(function(player, square)
	if player:HasTrait("NimbleFingers") then
    	player:getInventory():AddItem("FMJ.BobbyPin");
    	player:getInventory():AddItem("FMJ.BobbyPin")
    end
	if player:HasTrait("NimbleFingers2") then
    	player:getInventory():AddItem("FMJ.BobbyPin");
    	player:getInventory():AddItem("FMJ.BobbyPin")
	end
end)