Events.OnGameStart.Add( function ()

	if item_processing then

		-- Wild Food Mod adds these animals: Lizard, Pheasant, Snake
		-- Specifically it adds these items: FMJDeadLizard, FMJLizardMeat, FMJDeadPheasant, FMJPheasantMeat, FMJDeadSnake, FMJSnakeMeat
		if getActivatedMods():contains("ForkMJfoodWild") then
			if item_processing.Items.JarLizard then
			else
				item_processing.Items.JarLizard = {"Food", nil, nil, "FMJ.JarLizard", "Item_Null", nil, nil, nil};
			end

			if item_processing.Items.JarPheasant then
			else
				item_processing.Items.JarPheasant = {"Food", nil, nil, "FMJ.JarPheasant", "Item_Null", nil, nil, nil};
			end

			if item_processing.Items.JarSnake then
			else
				item_processing.Items.JarSnake = {"Food", nil, nil, "FMJ.JarSnake", "Item_Null", nil, nil, nil};
			end
		end

		-- vanilla --
		if item_processing.Items.JarChicken then
		else
			item_processing.Items.JarChicken = {"Food", nil, nil, "FMJ.JarChicken", "Item_Null", nil, nil, nil};
		end

		if item_processing.Items.JarSteak then
		else
			item_processing.Items.JarSteak = {"Food", nil, nil, "FMJ.JarSteak", "Item_Null", nil, nil, nil};
		end

		if item_processing.Items.JarFrogMeat then
		else
			item_processing.Items.JarFrogMeat = {"Food", nil, nil, "FMJ.JarFrogMeat", "Item_Null", nil, nil, nil};
		end

		if item_processing.Items.JarMeatPatty then
		else
			item_processing.Items.JarMeatPatty = {"Food", nil, nil, "FMJ.JarMeatPatty", "Item_Null", nil, nil, nil};
		end

		if item_processing.Items.JarMuttonChop then
		else
			item_processing.Items.JarMuttonChop = {"Food", nil, nil, "FMJ.JarMuttonChop", "Item_Null", nil, nil, nil};
		end

		if item_processing.Items.JarPorkChop then
		else
			item_processing.Items.JarPorkChop = {"Food", nil, nil, "FMJ.JarPorkChop", "Item_Null", nil, nil, nil};
		end

		if item_processing.Items.JarRabbitmeat then
		else
			item_processing.Items.JarRabbitmeat = {"Food", nil, nil, "FMJ.JarRabbitmeat", "Item_Null", nil, nil, nil};
		end

		if item_processing.Items.JarSmallanimalmeat then
		else
			item_processing.Items.JarSmallanimalmeat = {"Food", nil, nil, "FMJ.JarSmallanimalmeat", "Item_Null", nil, nil, nil};
		end

		if item_processing.Items.JarSmallbirdmeat then
		else
			item_processing.Items.JarSmallbirdmeat = {"Food", nil, nil, "FMJ.JarSmallbirdmeat", "Item_Null", nil, nil, nil};
		end
	end
end)

require 'Reloading/ISReloadManager'


function FMJCannedFood_OnCooked(FMJCannedFood)
	local aged = FMJCannedFood:getAge() / FMJCannedFood:getOffAgeMax();
	FMJCannedFood:setOffAgeMax(730);
	FMJCannedFood:setOffAge(365);
	FMJCannedFood:setAge(FMJCannedFood:getOffAgeMax() * aged);
end
