require('NPCs/MainCreationMethods');

local function initTraits()

	local archer = TraitFactory.addTrait("archer", getText("UI_trait_archer"), 6, getText("UI_trait_archerdesc"), false, false);
		archer:addXPBoost(Perks.Aiming, 1);
		archer:addXPBoost(Perks.Reloading, 2);

	local forager = TraitFactory.addTrait("forager", getText("UI_trait_forager"), 6, getText("UI_trait_foragerdesc"), false, false);
		forager:addXPBoost(Perks.PlantScavenging, 2);
		forager:addXPBoost(Perks.Farming, 1);
end
Events.OnGameBoot.Add(initTraits);
