--***********************************************************
--**                LEMMY/ROBERT JOHNSON                   **
--***********************************************************


-- MAIN METHOD FOR CREATING RIGHT CLICK CONTEXT MENU FOR INVENTORY ITEMS
ISInventoryPaneContextMenu.createMenu = function(player, isInPlayerInventory, items, x, y, origin)

    if ISInventoryPaneContextMenu.dontCreateMenu then return; end

	-- if the game is paused, we don't show the item context menu
	if UIManager.getSpeedControls():getCurrentGameSpeed() == 0 then
		return;
	end

    -- items is a list that could container either InventoryItem objects, OR a table with a list of InventoryItem objects in .items
    -- Also there is a duplicate entry first in the list, so ignore that.

    --print("Context menu for player "..player);
    --print("Creating context menu for inventory items");
    local context = ISContextMenu.get(player, x, y);
    -- avoid doing action while trading (you could eat half an apple and still trade it...)
--    if ISTradingUI.instance and ISTradingUI.instance:isVisible() then
--        context:addOption(getText("IGUI_TradingUI_CantRightClick"), nil, nil);
--        return;
--    end

    context.origin = origin;
	local itemsCraft = {};
    local c = 0;
    local isAllFood = true;
	local isWeapon = nil;
	local isHandWeapon = nil;
	local isAllPills = true;
	local clothing;
	local recipe = nil;
    local evorecipe = nil;
    local baseItem = nil;
	local isAllLiterature = true;
	local canBeActivated = false;
	local isAllBandage = true;
	local unequip = false;
    local isReloadable = false;
	local waterContainer = nil;
	local canBeDry = nil;
	local canBeEquippedBack = false;
	local twoHandsItem = nil;
    local brokenObject = nil;
    local canBeRenamed = nil;
    local canBeRenamedFood = nil;
    local pourOnGround = nil
    local canBeWrite = nil;
    local force2Hands = false;
    local remoteController = nil;
    local remoteControllable = nil;
    local generator = nil;
    local corpse = nil;
    local alarmClock = nil;
    local inPlayerInv = nil;
    local drainable = nil;
    local map = nil;
    local carBattery = nil;
    local carBatteryCharger = nil;
    local clothingRecipe = nil;
    local clothingItemExtra = nil;
    local magazine = nil;
    local bullet = nil;
	local customLiterature = nil;
	local noLiterature = nil;

    local playerObj = getSpecificPlayer(player)

	ISInventoryPaneContextMenu.removeToolTip();

	getCell():setDrag(nil, player);

    local containerList = ISInventoryPaneContextMenu.getContainers(playerObj)
    local testItem = nil;
    local editItem = nil;
    for i,v in ipairs(items) do
        testItem = v;
        if not instanceof(v, "InventoryItem") then
            --print(#v.items);
            if #v.items == 2 then
                editItem = v.items[1];
            end
            testItem = v.items[1];
        else
            editItem = v
        end
        if instanceof(testItem, "Key") or testItem:getType() == "KeyRing" then
            canBeRenamed = testItem;
        end
        if instanceof(testItem, "Clothing") and testItem:getClothingItemExtraOption() then
            clothingItemExtra = testItem;
        end
		if not testItem:isCanBandage() then
			isAllBandage = false;
		end
        if testItem:getCategory() ~= "Food" then
            isAllFood = false;
        end
		if testItem:getCategory() == "Clothing" then
            clothing = testItem;
        end
		if testItem:getType() == "DishCloth" or testItem:getType() == "BathTowel" and getSpecificPlayer(player):getBodyDamage():getWetness() > 0 then
			canBeDry = true;
        end
        if testItem:isBroken() or testItem:getCondition() < testItem:getConditionMax() then
            brokenObject = testItem;
        end
        if instanceof(testItem, "DrainableComboItem") then
            drainable = testItem;
        end
        if testItem:getContainer() and testItem:getContainer():isInCharacterInventory(playerObj) then
            inPlayerInv = testItem;
        end
        if testItem:getMaxAmmo() > 0 and not instanceof(testItem, "HandWeapon") then
            magazine = testItem;
        end
        if testItem:getDisplayCategory() == "Ammo" then
            bullet = testItem;
        end
        if getSpecificPlayer(player):isEquipped(testItem) then
			unequip = true;
        end
        if ISInventoryPaneContextMenu.startWith(testItem:getType(), "CarBattery") and testItem:getType() ~= "CarBatteryCharger" then
            carBattery = testItem;
        end
        if testItem:getType() == "CarBatteryCharger" then
            carBatteryCharger = testItem;
        end
        if testItem:getMap() then
            map = testItem;
        end
	if (instanceof(testItem, "Literature")) and testItem:getMaxCapacity() == 0 then
            noLiterature = testItem;
        end
	if (instanceof(testItem, "Literature")) and testItem:getCustomMenuOption() then --getConditionMax()
            customLiterature = testItem;
        end
	if testItem:getCategory() ~= "Literature" or testItem:canBeWrite() or testItem:getMaxCapacity() == 0 or testItem:getCustomMenuOption() then
            isAllLiterature = false;
        end
        if testItem:getCategory() == "Literature" and testItem:canBeWrite() then
            canBeWrite = testItem;
        end
		if testItem:canBeActivated() and (testItem == getSpecificPlayer(player):getSecondaryHandItem() or testItem == getSpecificPlayer(player):getPrimaryHandItem()) then
            canBeActivated = true;
        end
		-- all items can be equiped
		if (instanceof(testItem, "HandWeapon") and testItem:getCondition() > 0) or (instanceof(testItem, "InventoryItem") and not instanceof(testItem, "HandWeapon")) then
            isWeapon = testItem;
        end
        if instanceof(testItem, "HandWeapon") then
            isHandWeapon = testItem
        end
        -- remote controller
        if testItem:isRemoteController() then
            remoteController = testItem;
        end
        if isHandWeapon and isHandWeapon:canBeRemote() then
            remoteControllable = isHandWeapon;
        end
		if instanceof(testItem, "InventoryContainer") and testItem:canBeEquipped() == "Back" then
			canBeEquippedBack = true;
        end
        if instanceof(testItem, "InventoryContainer") then
            canBeRenamed = testItem;
        end
        if testItem:getType() == "Generator" then
            generator = testItem;
        end
        if testItem:getType() == "CorpseMale" or testItem:getType() == "CorpseFemale" then
            corpse = testItem;
        end
        if instanceof(testItem, "AlarmClock") then
            alarmClock = testItem;
        end
        if instanceof(testItem, "Food")  then -- Check if it's a recipe from the evolved recipe and have at least 3 ingredient, so we can name them
            for i=0,getEvolvedRecipes():size()-1 do
                local evoRecipeTest = getEvolvedRecipes():get(i);
                if evoRecipeTest:isResultItem(testItem) and testItem:haveExtraItems() and testItem:getExtraItems():size() >= 3 then
                    canBeRenamedFood = testItem;
                end
            end
        end
		if testItem:isTwoHandWeapon() and testItem:getCondition() > 0 then
			twoHandsItem = testItem;
        end
        if testItem:isRequiresEquippedBothHands() and testItem:getCondition() > 0 then
            force2Hands = true;
        end
        --> Stormy
		if(not getCore():isNewReloading() and ReloadUtil:isReloadable(testItem, getSpecificPlayer(player))) then
			isReloadable = true;
        end
		-->> Stormy
		if not ISInventoryPaneContextMenu.startWith(testItem:getType(), "Pills") then
            isAllPills = false;
        end
        if testItem:isWaterSource() then
            waterContainer = testItem;
        end
        if not instanceof(testItem, "Literature") and ISInventoryPaneContextMenu.canReplaceStoreWater(testItem) then
            pourOnGround = testItem
        end
        -- if item is not a clothing, use ClothingRecipesDefinitions
        if not playerObj:isEquippedClothing(testItem) and (ClothingRecipesDefinitions[testItem:getType()] or (testItem:getFabricType() and instanceof(testItem, "Clothing"))) then
            clothingRecipe = testItem;
        end
        evorecipe = RecipeManager.getEvolvedRecipe(testItem, getSpecificPlayer(player), containerList, true);
        if evorecipe then
            baseItem = testItem;
        end
        itemsCraft[c + 1] = testItem;

        c = c + 1;
        -- you can equip only 1 weapon
        if c > 1 then
            --~ 			isWeapon = false;
            isHandWeapon = nil
            isAllLiterature = false;
            canBeActivated = false;
            isReloadable = false;
            unequip = false;
            canBeEquippedBack = false;
            brokenObject = nil;
        end
    end

    triggerEvent("OnPreFillInventoryObjectContextMenu", player, context, items);

    context.blinkOption = ISInventoryPaneContextMenu.blinkOption;

    if editItem and c == 1 and ((isClient() and playerObj:getAccessLevel() ~= "None" and playerObj:getAccessLevel() ~= "Observer") and playerObj:getInventory():contains(editItem, true) or isDebugEnabled()) then
        context:addOption(getText("ContextMenu_EditItem"), items, ISInventoryPaneContextMenu.onEditItem, playerObj, testItem);
    end

    -- check the recipe
    if #itemsCraft > 0 then
        local sameType = true
        for i=2,#itemsCraft do
            if itemsCraft[i]:getFullType() ~= itemsCraft[1]:getFullType() then
                sameType = false
                break
            end
        end
        if sameType then
            recipe = RecipeManager.getUniqueRecipeItems(itemsCraft[1], playerObj, containerList);
        end
    end


    if c == 0 then
        return;
    end
    local loot = getPlayerLoot(player);
--~ 	context:addOption("Information", items, ISInventoryPaneContextMenu.onInformationItems);
	if not isInPlayerInventory then
		for i,k in pairs(items) do
				if not instanceof(k, "InventoryItem") then
					if #k.items > 2 then
						context:addOption(getText("ContextMenu_Grab_one"), items, ISInventoryPaneContextMenu.onGrabOneItems, player);
						context:addOption(getText("ContextMenu_Grab_half"), items, ISInventoryPaneContextMenu.onGrabHalfItems, player);
						context:addOption(getText("ContextMenu_Grab_all"), items, ISInventoryPaneContextMenu.onGrabItems, player);
						break;
					else
						context:addOption(getText("ContextMenu_Grab"), items, ISInventoryPaneContextMenu.onGrabItems, player);
						break;
					end
				else
					context:addOption(getText("ContextMenu_Grab"), items, ISInventoryPaneContextMenu.onGrabItems, player);
					break;
				end
		end
    end
    if evorecipe then
        for i=0,evorecipe:size()-1 do
            local listOfAddedItems = {};
            local evorecipe2 = evorecipe:get(i);
            local items = evorecipe2:getItemsCanBeUse(getSpecificPlayer(player), baseItem, containerList);
            if items:size() == 0 then
                break;
            end
            -- check for every item category to add a "add random category" in top of the list
            local catList = ISInventoryPaneContextMenu.getEvoItemCategories(items);
            local cookingLvl = getSpecificPlayer(player):getPerkLevel(Perks.Cooking);
            local subOption = nil;
            if evorecipe2:isResultItem(baseItem) then
                subOption = context:addOption(getText("ContextMenu_EvolvedRecipe_" .. evorecipe2:getUntranslatedName()), nil);
            else
                subOption = context:addOption(getText("ContextMenu_Create_From_Ingredient") .. getText("ContextMenu_EvolvedRecipe_" .. evorecipe2:getUntranslatedName()), nil);
            end
            local subMenuRecipe = context:getNew(context);
            context:addSubMenu(subOption, subMenuRecipe);

            for i,v in pairs(catList) do
                if getText("ContextMenu_FoodType_"..i) ~= "ContextMenu_FoodType_"..i then
                local txt = getText("ContextMenu_FromRandom", getText("ContextMenu_FoodType_"..i));
                if evorecipe2:isResultItem(baseItem) then
                    txt = getText("ContextMenu_AddRandom", getText("ContextMenu_FoodType_"..i));
                end
                subMenuRecipe:addOption(txt, evorecipe2, ISInventoryPaneContextMenu.onAddItemInEvoRecipe, baseItem, catList[i][ZombRand(1, #catList[i]+1)], player);
                end
            end
            for i=0,items:size() -1 do
                local evoItem = items:get(i);
                local extraInfo = "";
                if instanceof(evoItem, "Food") then
                    if evoItem:isSpice() then
                        extraInfo = getText("ContextMenu_EvolvedRecipe_Spice");
                    elseif evoItem:getPoisonLevelForRecipe() then
                        if evoItem:getHerbalistType() and evoItem:getHerbalistType() ~= "" and getSpecificPlayer(player):getKnownRecipes():contains("Herbalist") then
                            extraInfo = getText("ContextMenu_EvolvedRecipe_Poison");
                        end
                        local use = ISInventoryPaneContextMenu.getRealEvolvedItemUse(evoItem, evorecipe2, cookingLvl);
                        if use then
                            extraInfo = extraInfo .. " (" .. use .. ")";
                        end
                    elseif not evoItem:isPoison() then
                        local use = ISInventoryPaneContextMenu.getRealEvolvedItemUse(evoItem, evorecipe2, cookingLvl);
                        extraInfo = " (" .. use .. ")";
                        if listOfAddedItems[evoItem:getType()] and listOfAddedItems[evoItem:getType()] == use then
                            evoItem = nil;
                        else
                            listOfAddedItems[evoItem:getType()] = use;
                        end
                    end
                end
                if evoItem then
                    ISInventoryPaneContextMenu.addItemInEvoRecipe(subMenuRecipe, baseItem, evoItem, extraInfo, evorecipe2, player);
                end
            end
        end
    end

    if(isInPlayerInventory and loot.inventory ~= nil and loot.inventory:getType() ~= "floor" ) and playerObj:getJoypadBind() == -1 then
        if ISInventoryPaneContextMenu.isAnyAllowed(loot.inventory, items) and not ISInventoryPaneContextMenu.isAllFav(items) then
            context:addOption(getText("ContextMenu_Put_in_Container"), items, ISInventoryPaneContextMenu.onPutItems, player);
        end
    end

    -- Move To
    local moveItems = ISInventoryPane.getActualItems(items)
    if #moveItems > 0 and playerObj:getJoypadBind() ~= -1 then
        local subMenu = nil
        local moveTo0 = ISInventoryPaneContextMenu.canUnpack(moveItems, player)
        local moveTo1 = ISInventoryPaneContextMenu.canMoveTo(moveItems, playerObj:getClothingItem_Back(), player)
        local moveTo2 = ISInventoryPaneContextMenu.canMoveTo(moveItems, playerObj:getPrimaryHandItem(), player)
        local moveTo3 = ISInventoryPaneContextMenu.canMoveTo(moveItems, playerObj:getSecondaryHandItem(), player)
        local moveTo4 = ISInventoryPaneContextMenu.canMoveTo(moveItems, ISInventoryPage.floorContainer[player+1], player)
        local keyRings = {}
        local inventoryItems = playerObj:getInventory():getItems()
        for i=1,inventoryItems:size() do
            local item = inventoryItems:get(i-1)
            if item:getType() == "KeyRing" and ISInventoryPaneContextMenu.canMoveTo(moveItems, item, player) then
                table.insert(keyRings, item)
            end
        end
        local putIn = isInPlayerInventory and
                        loot.inventory and loot.inventory:getType() ~= "floor" and
                        ISInventoryPaneContextMenu.isAnyAllowed(loot.inventory, items) and
                        not ISInventoryPaneContextMenu.isAllFav(moveItems)
        if moveTo0 or moveTo1 or moveTo2 or moveTo3 or moveTo4 or (#keyRings > 0) or putIn then
            local option = context:addOption(getText("ContextMenu_Move_To"))
            local subMenu = context:getNew(context)
            context:addSubMenu(option, subMenu)
            if moveTo0 then
                subMenu:addOption(getText("ContextMenu_MoveToInventory"), moveItems, ISInventoryPaneContextMenu.onMoveItemsTo, playerObj:getInventory(), player)
            end
            if moveTo1 then
                subMenu:addOption(moveTo1:getName(), moveItems, ISInventoryPaneContextMenu.onMoveItemsTo, moveTo1:getInventory(), player)
            end
            if moveTo2 then
                subMenu:addOption(moveTo2:getName(), moveItems, ISInventoryPaneContextMenu.onMoveItemsTo, moveTo2:getInventory(), player)
            end
            if moveTo3 then
                subMenu:addOption(moveTo3:getName(), moveItems, ISInventoryPaneContextMenu.onMoveItemsTo, moveTo3:getInventory(), player)
            end
            for _,moveTo in ipairs(keyRings) do
                subMenu:addOption(moveTo:getName(), moveItems, ISInventoryPaneContextMenu.onMoveItemsTo, moveTo:getInventory(), player)
            end
            if putIn then
                subMenu:addOption(getText("ContextMenu_MoveToContainer"), moveItems, ISInventoryPaneContextMenu.onPutItems, player)
            end
            if moveTo4 then
                subMenu:addOption(getText("ContextMenu_Floor"), moveItems, ISInventoryPaneContextMenu.onMoveItemsTo, moveTo4, player)
            end
        end

        if isInPlayerInventory then
            context:addOption(getText("IGUI_invpage_Transfer_all"), getPlayerInventory(player), ISInventoryPage.transferAll)
        else
            context:addOption(getText("IGUI_invpage_Loot_all"), loot, ISInventoryPage.lootAll)
        end
    end

    if #moveItems and playerObj:getJoypadBind() == -1 then
        if ISInventoryPaneContextMenu.canUnpack(moveItems, player) then
            context:addOption(getText("ContextMenu_Unpack"), moveItems, ISInventoryPaneContextMenu.onMoveItemsTo, playerObj:getInventory(), player)
        end
    end

    if inPlayerInv then
       if inPlayerInv:isFavorite() then
           context:addOption(getText("ContextMenu_Unfavorite"), moveItems, ISInventoryPaneContextMenu.onFavorite, inPlayerInv, false)
       else
           context:addOption(getText("IGUI_CraftUI_Favorite"), moveItems, ISInventoryPaneContextMenu.onFavorite, inPlayerInv, true)
       end
    end

    -- equip a backpack when you have nothing equipped already
	if canBeEquippedBack and not unequip and not getSpecificPlayer(player):getClothingItem_Back() then
		context:addOption(getText("ContextMenu_Equip_on_your_Back"), items, ISInventoryPaneContextMenu.onWearItems, player);
    end
    -- replace an existing bag
    if canBeEquippedBack and not unequip and getSpecificPlayer(player):getClothingItem_Back() then
        items = ISInventoryPane.getActualItems(items)
        context:addOption(getText("ContextMenu_ReplaceClothing", getSpecificPlayer(player):getClothingItem_Back():getDisplayName(), items[1]:getDisplayName()), items, ISInventoryPaneContextMenu.onWearItems, player);
    end
    if isAllFood then
        -- Some items have a custom menu option, such as "Smoke" or "Drink" instead of "Eat".
        -- If the selected items have different menu options, don't add any eat option.
        -- If a food item has no hunger reduction (like Cigarettes) it is impossible to eat
        -- some percentage, so we shouldn't show the submenu in such cases.
        local foodItems = ISInventoryPane.getActualItems(items)
        local foodByCmd = {}
        local cmd = nil
        local hungerNotZero = 0
        for i,k in ipairs(foodItems) do
            cmd = k:getCustomMenuOption() or getText("ContextMenu_Eat")
            foodByCmd[cmd] = true
            if k:getHungChange() < 0 then
                hungerNotZero = hungerNotZero + 1
            end
        end
        local cmdCount = 0
        for k,v in pairs(foodByCmd) do
            cmdCount = cmdCount + 1
        end
        if cmdCount == 1 then
            if hungerNotZero > 0 then
                local eatOption = context:addOption(cmd, items, nil)
                if playerObj:getMoodles():getMoodleLevel(MoodleType.FoodEaten) >= 3 and playerObj:getNutrition():getCalories() >= 1000 then
                    local tooltip = ISInventoryPaneContextMenu.addToolTip();
                    eatOption.notAvailable = true;
                    tooltip.description = getText("Tooltip_CantEatMore");
                    eatOption.toolTip = tooltip;
                else
                    local subMenuEat = context:getNew(context)
                    context:addSubMenu(eatOption, subMenuEat)
                    subMenuEat:addOption(getText("ContextMenu_Eat_All"), items, ISInventoryPaneContextMenu.onEatItems, 1, player)
                    subMenuEat:addOption(getText("ContextMenu_Eat_Half"), items, ISInventoryPaneContextMenu.onEatItems, 0.5, player)
                    subMenuEat:addOption(getText("ContextMenu_Eat_Quarter"), items, ISInventoryPaneContextMenu.onEatItems, 0.25, player)
                end
            elseif cmd ~= getText("ContextMenu_Eat") then
                ISInventoryPaneContextMenu.doEatOption(context, cmd, items, player, playerObj, foodItems);
            end
        end
    end
	if generator and (playerObj:getPrimaryHandItem() == generator or playerObj:getSecondaryHandItem() == generator) then
		-- nothing
	elseif corpse and (playerObj:getPrimaryHandItem() == corpse or playerObj:getSecondaryHandItem() == corpse) then
		-- nothing
	elseif (twoHandsItem or force2Hands) and (playerObj:getPrimaryHandItem() ~= twoHandsItem or playerObj:getSecondaryHandItem() ~= twoHandsItem) then
		context:addOption(getText("ContextMenu_Equip_Two_Hands"), items, ISInventoryPaneContextMenu.OnTwoHandsEquip, player);
    end
	if isWeapon and not isAllFood and not force2Hands and not clothing then
        -- check if hands if not heavy damaged
        if (playerObj:getPrimaryHandItem() ~= isWeapon or (playerObj:getPrimaryHandItem() == isWeapon and playerObj:getSecondaryHandItem() == isWeapon)) and not getSpecificPlayer(player):getBodyDamage():getBodyPart(BodyPartType.Hand_R):isDeepWounded() and (getSpecificPlayer(player):getBodyDamage():getBodyPart(BodyPartType.Hand_R):getFractureTime() == 0 or getSpecificPlayer(player):getBodyDamage():getBodyPart(BodyPartType.Hand_R):getSplintFactor() > 0) then
            context:addOption(getText("ContextMenu_Equip_Primary"), items, ISInventoryPaneContextMenu.OnPrimaryWeapon, player);
        end
        if (playerObj:getSecondaryHandItem() ~= isWeapon or (playerObj:getPrimaryHandItem() == isWeapon and playerObj:getSecondaryHandItem() == isWeapon)) and not getSpecificPlayer(player):getBodyDamage():getBodyPart(BodyPartType.Hand_L):isDeepWounded() and (getSpecificPlayer(player):getBodyDamage():getBodyPart(BodyPartType.Hand_L):getFractureTime() == 0 or getSpecificPlayer(player):getBodyDamage():getBodyPart(BodyPartType.Hand_L):getSplintFactor() > 0) then
		    context:addOption(getText("ContextMenu_Equip_Secondary"), items, ISInventoryPaneContextMenu.OnSecondWeapon, player);
        end
    end
    -- weapon upgrades
    isWeapon = isHandWeapon -- to allow upgrading broken weapons
    if isWeapon and instanceof(isWeapon, "HandWeapon") and getSpecificPlayer(player):getInventory():getItemFromType("Screwdriver") then
        -- add parts
        local weaponParts = getSpecificPlayer(player):getInventory():getItemsFromCategory("WeaponPart");
        if weaponParts and not weaponParts:isEmpty() then
            local subMenuUp = context:getNew(context);
            local doIt = false;
            local addOption = false;
            local alreadyDoneList = {};
            for i=0, weaponParts:size() - 1 do
                local part = weaponParts:get(i);
                if part:getMountOn():contains(isWeapon:getFullType()) and not alreadyDoneList[part:getName()] then
                    if (part:getPartType() == "Scope") and not isWeapon:getScope() then
                        addOption = true;
                    elseif (part:getPartType() == "Clip") and not isWeapon:getClip() then
                        addOption = true;
                    elseif (part:getPartType() == "Sling") and not isWeapon:getSling() then
                        addOption = true;
                    elseif (part:getPartType() == "Stock") and not isWeapon:getStock() then
                        addOption = true;
                    elseif (part:getPartType() == "Canon") and not isWeapon:getCanon() then
                        addOption = true;
                    elseif (part:getPartType() == "RecoilPad") and not isWeapon:getRecoilpad() then
                        addOption = true;
                    end
                end
                if addOption then
                    doIt = true;
                    subMenuUp:addOption(weaponParts:get(i):getName(), isWeapon, ISInventoryPaneContextMenu.onUpgradeWeapon, part, getSpecificPlayer(player));
                    addOption = false;
                    alreadyDoneList[part:getName()] = true;
                end
            end
            if doIt then
                local upgradeOption = context:addOption(getText("ContextMenu_Add_Weapon_Upgrade"), items, nil);
                context:addSubMenu(upgradeOption, subMenuUp);
            end
        end
        -- remove parts
        if  getSpecificPlayer(player):getInventory():getItemFromType("Screwdriver") and (isWeapon:getScope() or isWeapon:getClip() or isWeapon:getSling() or isWeapon:getStock() or isWeapon:getCanon() or isWeapon:getRecoilpad()) then
            local removeUpgradeOption = context:addOption(getText("ContextMenu_Remove_Weapon_Upgrade"), items, nil);
            local subMenuRemove = context:getNew(context);
            context:addSubMenu(removeUpgradeOption, subMenuRemove);
            if isWeapon:getScope() then
                subMenuRemove:addOption(isWeapon:getScope():getName(), isWeapon, ISInventoryPaneContextMenu.onRemoveUpgradeWeapon, isWeapon:getScope(), getSpecificPlayer(player));
            end
            if isWeapon:getClip() then
                subMenuRemove:addOption(isWeapon:getClip():getName(), isWeapon, ISInventoryPaneContextMenu.onRemoveUpgradeWeapon, isWeapon:getClip(), getSpecificPlayer(player));
            end
            if isWeapon:getSling() then
                subMenuRemove:addOption(isWeapon:getSling():getName(), isWeapon, ISInventoryPaneContextMenu.onRemoveUpgradeWeapon, isWeapon:getSling(), getSpecificPlayer(player));
            end
            if isWeapon:getStock() then
                subMenuRemove:addOption(isWeapon:getStock():getName(), isWeapon, ISInventoryPaneContextMenu.onRemoveUpgradeWeapon, isWeapon:getStock(), getSpecificPlayer(player));
            end
            if isWeapon:getCanon() then
                subMenuRemove:addOption(isWeapon:getCanon():getName(), isWeapon, ISInventoryPaneContextMenu.onRemoveUpgradeWeapon, isWeapon:getCanon(), getSpecificPlayer(player));
            end
            if isWeapon:getRecoilpad() then
                subMenuRemove:addOption(isWeapon:getRecoilpad():getName(), isWeapon, ISInventoryPaneContextMenu.onRemoveUpgradeWeapon, isWeapon:getRecoilpad(), getSpecificPlayer(player));
            end
        end
    end

    if isHandWeapon and isHandWeapon:getExplosionTimer() > 0 then
        if isHandWeapon:getSensorRange() == 0 then
            context:addOption(getText("ContextMenu_TrapSetTimerExplosion"), isHandWeapon, ISInventoryPaneContextMenu.onSetBombTimer, player);
        else
            context:addOption(getText("ContextMenu_TrapSetTimerActivation"), isHandWeapon, ISInventoryPaneContextMenu.onSetBombTimer, player);
        end
    end
    -- place trap/bomb
    if isHandWeapon and isHandWeapon:canBePlaced() then
        context:addOption(getText("ContextMenu_TrapPlace", isHandWeapon:getName()), isHandWeapon, ISInventoryPaneContextMenu.onPlaceTrap, getSpecificPlayer(player));
    end
    -- link remote controller
    if remoteControllable then
        for i = 0, playerObj:getInventory():getItems():size() -1 do
            local item = playerObj:getInventory():getItems():get(i);
            if item:isRemoteController() and (item:getRemoteControlID() == -1 or item:getRemoteControlID() ~= remoteControllable:getRemoteControlID()) then
                context:addOption(getText("ContextMenu_TrapControllerLinkTo", item:getName()), remoteControllable, ISInventoryPaneContextMenu.OnLinkRemoteController, item, player);
            end
        end
        if remoteControllable:getRemoteControlID() ~= -1 then
            context:addOption(getText("ContextMenu_TrapControllerReset"), remoteControllable, ISInventoryPaneContextMenu.OnResetRemoteControlID, player);
        end
    end
    -- remote controller
    if remoteController then
        for i = 0, playerObj:getInventory():getItems():size() -1 do
            local item = playerObj:getInventory():getItems():get(i);
            if instanceof(item, "HandWeapon") and item:canBeRemote() and (item:getRemoteControlID() == -1 or item:getRemoteControlID() ~= remoteController:getRemoteControlID()) then
                context:addOption(getText("ContextMenu_TrapControllerLinkTo", item:getName()), item, ISInventoryPaneContextMenu.OnLinkRemoteController, remoteController, player);
            end
        end
        if remoteController:getRemoteControlID() ~= -1 then
            context:addOption(getText("ContextMenu_TrapControllerTrigger"), remoteController, ISInventoryPaneContextMenu.OnTriggerRemoteController, player);
            context:addOption(getText("ContextMenu_TrapControllerReset"), remoteController, ISInventoryPaneContextMenu.OnResetRemoteControlID, player);
        end
    end

    if isHandWeapon and instanceof(isHandWeapon, "HandWeapon") and isHandWeapon:getFireModePossibilities() and isHandWeapon:getFireModePossibilities():size() > 1 then
        ISInventoryPaneContextMenu.doChangeFireModeMenu(playerObj, isHandWeapon, context);
    end

    if isHandWeapon and instanceof(isHandWeapon, "HandWeapon") and getCore():isNewReloading() then
        ISInventoryPaneContextMenu.doReloadMenuForWeapon(playerObj, isHandWeapon, context);
        magazine = nil
        bullet = nil
    end

    if magazine and isInPlayerInventory then
        ISInventoryPaneContextMenu.doReloadMenuForMagazine(playerObj, magazine, context);
        ISInventoryPaneContextMenu.doMagazineMenu(playerObj, magazine, context);
        bullet = nil
    end
    if bullet and isInPlayerInventory then
        ISInventoryPaneContextMenu.doReloadMenuForBullets(playerObj, bullet, context);
    end

        --> Stormy
	if isInPlayerInventory and isReloadable then
		local item = items[1];
		-- if it's a header, we get our first item (the selected one)
		if not instanceof(items[1], "InventoryItem") then
			item = items[1].items[1];
		end
		context:addOption(ReloadUtil:getReloadText(item, playerObj), items, ISInventoryPaneContextMenu.OnReload, player);
	end
	-->> Stormy

    if waterContainer and getSpecificPlayer(player):getStats():getThirst() > 0.1 then
        local drinkOption = context:addOption(getText("ContextMenu_Drink"), items, nil)
        local subMenuDrink = context:getNew(context)
        context:addSubMenu(drinkOption, subMenuDrink)
        subMenuDrink:addOption(getText("ContextMenu_Eat_All"), items, ISInventoryPaneContextMenu.onDrink, waterContainer, 1, player)
        subMenuDrink:addOption(getText("ContextMenu_Eat_Half"), items, ISInventoryPaneContextMenu.onDrink, waterContainer, 0.5, player)
        subMenuDrink:addOption(getText("ContextMenu_Eat_Quarter"), items, ISInventoryPaneContextMenu.onDrink, waterContainer, 0.25, player)
    end

		-- Crowley
	local pourInto = {}
	if c == 1 and waterContainer ~= nil then
		for i = 0, getSpecificPlayer(player):getInventory():getItems():size() -1 do
			local item = getSpecificPlayer(player):getInventory():getItems():get(i);
			if item ~= waterContainer and item:canStoreWater() and not item:isWaterSource() then
				table.insert(pourInto, item)
			elseif item ~= waterContainer and item:canStoreWater() and item:isWaterSource() and instanceof(item, "DrainableComboItem") and (1 - item:getUsedDelta()) >= item:getUseDelta() then
				table.insert(pourInto, item)
			end
		end
		if #pourInto > 0 then
			local subMenuOption = context:addOption(getText("ContextMenu_Pour_into"), items, nil);
			local subMenu = context:getNew(context)
			context:addSubMenu(subMenuOption, subMenu)
			for _,item in ipairs(pourInto) do
                if instanceof(item, "DrainableComboItem") then
				    subMenu:addOption(item:getName() .. " (" .. math.floor(item:getUsedDelta() * 100) .. getText("ContextMenu_FullPercent") .. ")", items, ISInventoryPaneContextMenu.onTransferWater, waterContainer, item, player);
                else
                    subMenu:addOption(item:getName(), items, ISInventoryPaneContextMenu.onTransferWater, waterContainer, item, player);
                end
			end
		end

		context:addOption(getText("ContextMenu_Pour_on_Ground"), items, ISInventoryPaneContextMenu.onEmptyWaterContainer, waterContainer, player);
	end
	-- /Crowley

	if c == 1 then
		ISInventoryPaneContextMenu.checkConsolidate(drainable, player, context, pourInto);
	end

	if c == 1 and pourOnGround and not waterContainer then
		context:addOption(getText("ContextMenu_Pour_on_Ground"), items, ISInventoryPaneContextMenu.onDumpContents, pourOnGround, 100.0, player);
	end

	if isAllPills then
		context:addOption(getText("ContextMenu_Take_pills"), items, ISInventoryPaneContextMenu.onPillsItems, player);
    end
	if isAllLiterature and not getSpecificPlayer(player):getTraits():isIlliterate() then
		local readOption = context:addOption(getText("ContextMenu_Read"), items, ISInventoryPaneContextMenu.onLiteratureItems, player);
        if getSpecificPlayer(player):isAsleep() then
            readOption.notAvailable = true;
            local tooltip = ISInventoryPaneContextMenu.addToolTip();
            tooltip.description = getText("ContextMenu_NoOptionSleeping");
            readOption.toolTip = tooltip;
        end
    end
	if customLiterature then
		local readOption = context:addOption(customLiterature:getCustomMenuOption(), customLiterature, ISInventoryPaneContextMenu.readItem, player);
		if customLiterature:getRequireInHandOrInventory() then
	        local list = customLiterature:getRequireInHandOrInventory();
			local found = false;
			local required = "";
			for i=0,list:size()-1 do
				if playerObj:getInventory():contains(list:get(i), false) then
					found = true;
					break;
				end
				required = required .. getItemText(list:get(i));
				if i < list:size()-1 then
					required = required .. "/";
				end
			end
			if not found then
			    readOption.notAvailable = true;
				local tooltip = ISInventoryPaneContextMenu.addToolTip();
				tooltip.description = getText("ContextMenu_Require", required);
				readOption.toolTip = tooltip;
			end
		end
		if getSpecificPlayer(player):isAsleep() then
            readOption.notAvailable = true;
            local tooltip = ISInventoryPaneContextMenu.addToolTip();
            tooltip.description = getText("ContextMenu_NoOptionSleeping");
            readOption.toolTip = tooltip;
        end
	end
	if noLiterature then
		for i,v in ipairs(context.options) do
			if v.name == getText("ContextMenu_Read") then
				context:removeOption(v);
			end
		end
	end
    if clothing and clothing:getCoveredParts():size() > 0 and clothing:isInPlayerInventory() then
        context:addOption(getText("IGUI_invpanel_Inspect"), playerObj, ISInventoryPaneContextMenu.onInspectClothing, clothing);
--        ISInventoryPaneContextMenu.doClothingPatchMenu(player, clothing, context);
    end
	if clothing and not unequip then
        ISInventoryPaneContextMenu.doWearClothingMenu(player, clothing, items, context);
	end
	if unequip then
		context:addOption(getText("ContextMenu_Unequip"), items, ISInventoryPaneContextMenu.onUnEquip, player);
	end
	-- recipe dynamic context menu
	if recipe ~= nil then
		ISInventoryPaneContextMenu.addDynamicalContextMenu(itemsCraft[1], context, recipe, player, containerList);
    end
	local light = items[1];
	-- if it's a header, we get our first item (the selected one)
	if items[1] and not instanceof(items[1], "InventoryItem") then
		light = items[1].items[1];
	end
	if canBeActivated and light ~= nil and (not instanceof(light, "Drainable") or light:getUsedDelta() > 0) then
		local txt = getText("ContextMenu_Turn_On");
		if light:isActivated() then
			txt = getText("ContextMenu_Turn_Off");
		end
		context:addOption(txt, light, ISInventoryPaneContextMenu.onActivateItem, player);
	end
	if isAllBandage then
		-- we get all the damaged body part
		local bodyPartDamaged = ISInventoryPaneContextMenu.haveDamagePart(player);
		-- if any part is damaged, we gonna create a sub menu with them
		if #bodyPartDamaged > 0 then
			local bandageOption = context:addOption(getText("ContextMenu_Apply_Bandage"), bodyPartDamaged, nil);
			-- create a new contextual menu
			local subMenuBandage = context:getNew(context);
			-- we add our new menu to the option we want (here bandage)
			context:addSubMenu(bandageOption, subMenuBandage);
			for i,v in ipairs(bodyPartDamaged) do
				subMenuBandage:addOption(BodyPartType.getDisplayName(v:getType()), items, ISInventoryPaneContextMenu.onApplyBandage, v, player);
			end
		end
	end
	-- dry yourself with a towel
	if canBeDry then
		context:addOption(getText("ContextMenu_Dry_myself"), items, ISInventoryPaneContextMenu.onDryMyself, player);
	end
    if isInPlayerInventory and not unequip and playerObj:getJoypadBind() == -1 and
            not ISInventoryPaneContextMenu.isAllFav(items) and
            not ISInventoryPaneContextMenu.isAllNoDropMoveable(items) then
        context:addOption(getText("ContextMenu_Drop"), items, ISInventoryPaneContextMenu.onDropItems, player);
    end
    if brokenObject then
        local fixingList = FixingManager.getFixes(brokenObject);
        if not fixingList:isEmpty() then
            local fixOption = context:addOption(getText("ContextMenu_Repair") .. getItemNameFromFullType(brokenObject:getFullType()), items, nil);
            local subMenuFix = ISContextMenu:getNew(context);
            context:addSubMenu(fixOption, subMenuFix);
            for i=0,fixingList:size()-1 do
                ISInventoryPaneContextMenu.buildFixingMenu(brokenObject, player, fixingList:get(i), fixOption, subMenuFix)
            end
        end
    end
    if alarmClock then
        if alarmClock:isRinging() then
            context:addOption(getText("ContextMenu_StopAlarm"), alarmClock, ISInventoryPaneContextMenu.onStopAlarm, player);
        end
        context:addOption(getText("ContextMenu_SetAlarm"), alarmClock, ISInventoryPaneContextMenu.onSetAlarm, player);
    end
    if clothingItemExtra then
        local option = context:addOption(getText("ContextMenu_" .. clothingItemExtra:getClothingItemExtraOption()), clothingItemExtra, ISInventoryPaneContextMenu.onClothingItemExtra, player);
        if not getSpecificPlayer(player):isEquipped(clothingItemExtra) then
            local tooltip = ISInventoryPaneContextMenu.addToolTip();
            option.notAvailable = true;
            tooltip.description = getText("Tooltip_EquipFirst");
            option.toolTip = tooltip;
        end
    end
    if canBeRenamed then
        context:addOption(getText("ContextMenu_RenameBag"), canBeRenamed, ISInventoryPaneContextMenu.onRenameBag, player);
    end
    if canBeRenamedFood then
        context:addOption(getText("ContextMenu_RenameFood") .. canBeRenamedFood:getName(), canBeRenamedFood, ISInventoryPaneContextMenu.onRenameFood, player);
    end
    if map then
		local text = map:getCustomMenuOption() or getText("ContextMenu_CheckMap")
		local renameText = getText("ContextMenu_RenameFood") .. map:getName();
		if map:getCategory() == "Food" then
			context:addOption(getText("IGUI_invpanel_Inspect"), map, ISInventoryPaneContextMenu.onCheckImage, player);
		elseif map:getCategory() == "Literature" and map:canBeWrite() then
			context:addOption(getText("ContextMenu_Read_Note", map:getName()), map, ISInventoryPaneContextMenu.onCheckMap, player);
			context:addOption(renameText, map, ISInventoryPaneContextMenu.onRenameMap, player);
		elseif map:getCategory() == "Literature" and not map:canBeWrite() then
			context:addOption(getText("IGUI_invpanel_Inspect"), map, ISInventoryPaneContextMenu.onCheckImage, player);
		elseif map:getCustomMenuOption() then
			context:addOption(text, map, ISInventoryPaneContextMenu.onCheckImage, player);
		else
			context:addOption(text, map, ISInventoryPaneContextMenu.onCheckMap, player);
			context:addOption(getText("ContextMenu_RenameMap"), map, ISInventoryPaneContextMenu.onRenameMap, player);
		end
    end

	local carBatteryCharger = playerObj:getInventory():getItemFromType("CarBatteryCharger")
	if carBatteryCharger then
		context:addOption(getText("ContextMenu_CarBatteryCharger_Place"), playerObj, ISInventoryPaneContextMenu.onPlaceCarBatteryCharger, carBatteryCharger)
    end
    if clothingRecipe then
        ISInventoryPaneContextMenu.doClothingRecipeMenu(playerObj, clothingRecipe, items, context);
    end

    ISHotbar.doMenuFromInventory(player, testItem, context);

    -- use the event (as you would 'OnTick' etc) to add items to context menu without mod conflicts.
    triggerEvent("OnFillInventoryObjectContextMenu", player, context, items);

    return context;
end

ISInventoryPaneContextMenu.onCheckImage = function(map, player)
    local mapUI = SFReadCheckImage:new(0, 0, 0, 0, map, player);
    mapUI:initialise();
    local wrap = mapUI:wrapInCollapsableWindow(map:getName(), false);
    wrap:setInfo(getText("IGUI_Map_Info"));
    mapUI.wrap = wrap;
    wrap.render = SFReadCheckImage.renderWrap;
    wrap.prerender = SFReadCheckImage.prerenderWrap;
    wrap.setVisible = SFReadCheckImage.setWrapVisible;
    wrap.close = SFReadCheckImage.closeWrap;
	wrap.mapUI = mapUI;
    mapUI.render = SFReadCheckImage.noRender;
    mapUI.prerender = SFReadCheckImage.noRender;
    wrap:setVisible(true);
    wrap:addToUIManager();
	if JoypadState.players[player+1] then
        setJoypadFocus(player, mapUI)
    end
end

----- ----- ----- ----- -----

-- Function that goes through all pills selected and take them.
ISInventoryPaneContextMenu.onPillsItems = function(items, player)
	items = ISInventoryPane.getActualItems(items)
	for i,k in ipairs(items) do
		ISInventoryPaneContextMenu.takePill(k, player)
		break
    end
end

-- Take a pill, loot it first if it's not in the player's inventory
ISInventoryPaneContextMenu.takePill = function(item, player)
	local playerObj = getSpecificPlayer(player);
	-- if pill isn't in main inventory, put it there first.
	ISInventoryPaneContextMenu.transferIfNeeded(playerObj, item)
	-- take the pill
	ISTimedActionQueue.add(ISTakePillAction:new(playerObj, item, 165));
end
