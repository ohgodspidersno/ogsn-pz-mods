--***********************************************************
--**                LEMMY/ROBERT JOHNSON                   **
--***********************************************************

ISInventoryPaneContextMenu = {}

-- MAIN METHOD FOR CREATING RIGHT CLICK CONTEXT MENU FOR INVENTORY ITEMS
ISInventoryPaneContextMenu.createMenu = function(player, isInPlayerInventory, items, x, y, origin)

  if ISInventoryPaneContextMenu.dontCreateMenu then return; end

  -- items is a list that could container either InventoryItem objects, OR a table with a list of InventoryItem objects in .items
  -- Also there is a duplicate entry first in the list, so ignore that.

  --print("Context menu for player "..player);
  --print("Creating context menu for inventory items");
  local context = ISContextMenu.get(player, x, y);
  -- avoid doing action while trading (you could eat half an apple and still trade it...)
  if ISTradingUI.instance and ISTradingUI.instance:isVisible() then
    context:addOption(getText("IGUI_TradingUI_CantRightClick"), nil, nil);
    return;
  end

  context.origin = origin;
  local itemsCraft = {};
  local c = 0;
  local isAllFood = true;
  local isWeapon = nil;
  local isHandWeapon = nil;
  local isAllPills = true;
  local isAllClothing = true;
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
  local twoHandsItem = false;
  local brokenObject = nil;
  local canBeRenamed = nil;
  local canBeRenamedFood = nil;
  local pourOnGround = nil
  local canBeWrite = nil;
  local force2Hands = false;
  local remoteController = nil;
  local remoteControllable = nil;
  local generator = nil;
  local alarmClock = nil;
  local inPlayerInv = nil;
  local drainable = nil;
  local map = nil;
  local carBattery = nil;
  local carBatteryCharger = nil;

  local playerObj = getSpecificPlayer(player)

  ISInventoryPaneContextMenu.removeToolTip();

  getCell():setDrag(nil, player);

  local containerList = ISInventoryPaneContextMenu.getContainers(playerObj)
  local testItem = nil;
  local editItem = nil;
  for i, v in ipairs(items) do
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
    if not testItem:isCanBandage() then
      isAllBandage = false;
    end
    if testItem:getCategory() ~= "Food" then
      isAllFood = false;
    end
    if testItem:getCategory() ~= "Clothing" then
      isAllClothing = false;
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
    if testItem:getContainer():isInCharacterInventory(playerObj) then
      inPlayerInv = testItem;
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
    if testItem:getCategory() ~= "Literature" or testItem:canBeWrite() then
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
    if instanceof(testItem, "AlarmClock") then
      alarmClock = testItem;
    end
    if instanceof(testItem, "Food") then -- Check if it's a recipe from the evolved recipe and have at least 3 ingredient, so we can name them
      for i = 0, getEvolvedRecipes():size() - 1 do
        local evoRecipeTest = getEvolvedRecipes():get(i);
        if evoRecipeTest:isResultItem(testItem) and testItem:haveExtraItems() and testItem:getExtraItems():size() >= 3 then
          canBeRenamedFood = testItem;
        end
      end
    end
    if testItem:isTwoHandWeapon() and testItem:getCondition() > 0 then
      twoHandsItem = true;
    end
    if testItem:isRequiresEquippedBothHands() and testItem:getCondition() > 0 then
      force2Hands = true;
    end
    --> Stormy
    if(ReloadUtil:isReloadable(testItem, getSpecificPlayer(player))) then
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
      isAllClothing = false;
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
    for i = 2, #itemsCraft do
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
    for i, k in pairs(items) do
      if not isInPlayerInventory then
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
  end
  if evorecipe then
    for i = 0, evorecipe:size() - 1 do
      local listOfAddedItems = {};
      local evorecipe2 = evorecipe:get(i);
      local items = evorecipe2:getItemsCanBeUse(getSpecificPlayer(player), baseItem, containerList);
      if items:size() == 0 then
        break;
      end
      local cookingLvl = getSpecificPlayer(player):getPerkLevel(Perks.Cooking);
      local subOption = nil;
      if evorecipe2:isResultItem(baseItem) then
        subOption = context:addOption(getText("ContextMenu_EvolvedRecipe_" .. evorecipe2:getUntranslatedName()), nil);
      else
        subOption = context:addOption(getText("ContextMenu_Create_From_Ingredient") .. getText("ContextMenu_EvolvedRecipe_" .. evorecipe2:getUntranslatedName()), nil);
      end
      local subMenuRecipe = context:getNew(context);
      context:addSubMenu(subOption, subMenuRecipe);
      for i = 0, items:size() - 1 do
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
    if not ISInventoryPaneContextMenu.isAllFav(items) then
      context:addOption(getText("ContextMenu_Put_in_Container"), items, ISInventoryPaneContextMenu.onPutItems, player);
    end
  end

  -- Move To
  local moveItems = ISInventoryPane.getActualItems(items)
  if #moveItems and playerObj:getJoypadBind() ~= -1 then
    local subMenu = nil
    local moveTo0 = ISInventoryPaneContextMenu.canUnpack(moveItems, player)
    local moveTo1 = ISInventoryPaneContextMenu.canMoveTo(moveItems, playerObj:getClothingItem_Back(), player)
    local moveTo2 = ISInventoryPaneContextMenu.canMoveTo(moveItems, playerObj:getPrimaryHandItem(), player)
    local moveTo3 = ISInventoryPaneContextMenu.canMoveTo(moveItems, playerObj:getSecondaryHandItem(), player)
    local moveTo4 = ISInventoryPaneContextMenu.canMoveTo(moveItems, ISInventoryPage.floorContainer[player + 1], player)
    local keyRings = {}
    local inventoryItems = playerObj:getInventory():getItems()
    for i = 1, inventoryItems:size() do
      local item = inventoryItems:get(i - 1)
      if item:getType() == "KeyRing" and ISInventoryPaneContextMenu.canMoveTo(moveItems, item, player) then
        table.insert(keyRings, item)
      end
    end
    local putIn = isInPlayerInventory and
    loot.inventory and loot.inventory:getType() ~= "floor" and
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
      for _, moveTo in ipairs(keyRings) do
        subMenu:addOption(moveTo:getName(), moveItems, ISInventoryPaneContextMenu.onMoveItemsTo, moveTo:getInventory(), player)
      end
      if putIn then
        subMenu:addOption(getText("ContextMenu_MoveToContainer"), moveItems, ISInventoryPaneContextMenu.onPutItems, player)
      end
      if moveTo4 then
        subMenu:addOption(getText("ContextMenu_Floor"), moveItems, ISInventoryPaneContextMenu.onMoveItemsTo, moveTo4, player)
      end
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

  if canBeEquippedBack and not unequip and not getSpecificPlayer(player):getClothingItem_Back() then
    context:addOption(getText("ContextMenu_Equip_on_your_Back"), items, ISInventoryPaneContextMenu.onWearItems, player);
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
    for i, k in ipairs(foodItems) do
      cmd = k:getCustomMenuOption() or getText("ContextMenu_Eat")
      foodByCmd[cmd] = true
      if k:getHungChange() < 0 then
        hungerNotZero = hungerNotZero + 1
      end
    end
    local cmdCount = 0
    for k, v in pairs(foodByCmd) do
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
  if (twoHandsItem or force2Hands) and not unequip then
    context:addOption(getText("ContextMenu_Equip_Two_Hands"), items, ISInventoryPaneContextMenu.OnTwoHandsEquip, player);
  end
  if isWeapon and not isAllFood and not unequip and not force2Hands then
    -- check if hands if not heavy damaged
    if not getSpecificPlayer(player):getBodyDamage():getBodyPart(BodyPartType.Hand_R):isDeepWounded() and (getSpecificPlayer(player):getBodyDamage():getBodyPart(BodyPartType.Hand_R):getFractureTime() == 0 or getSpecificPlayer(player):getBodyDamage():getBodyPart(BodyPartType.Hand_R):getSplintFactor() > 0) then
      context:addOption(getText("ContextMenu_Equip_Primary"), items, ISInventoryPaneContextMenu.OnPrimaryWeapon, player);
    end
    if not getSpecificPlayer(player):getBodyDamage():getBodyPart(BodyPartType.Hand_L):isDeepWounded() and (getSpecificPlayer(player):getBodyDamage():getBodyPart(BodyPartType.Hand_L):getFractureTime() == 0 or getSpecificPlayer(player):getBodyDamage():getBodyPart(BodyPartType.Hand_L):getSplintFactor() > 0) then
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
      for i = 0, weaponParts:size() - 1 do
        local part = weaponParts:get(i);
        if part:getMountOn():contains(isWeapon:getDisplayName()) and not alreadyDoneList[part:getName()] then
          if part:getPartType() == getText("Tooltip_weapon_Scope") and not isWeapon:getScope() then
            addOption = true;
          elseif part:getPartType() == getText("Tooltip_weapon_Clip") and not isWeapon:getClip() then
            addOption = true;
          elseif part:getPartType() == getText("Tooltip_weapon_Sling") and not isWeapon:getSling() then
            addOption = true;
          elseif part:getPartType() == getText("Tooltip_weapon_Stock") and not isWeapon:getStock() then
            addOption = true;
          elseif part:getPartType() == getText("Tooltip_weapon_Canon") and not isWeapon:getCanon() then
            addOption = true;
          elseif part:getPartType() == getText("Tooltip_weapon_RecoilPad") and not isWeapon:getRecoilpad() then
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
    if getSpecificPlayer(player):getInventory():getItemFromType("Screwdriver") and (isWeapon:getScope() or isWeapon:getClip() or isWeapon:getSling() or isWeapon:getStock() or isWeapon:getCanon() or isWeapon:getRecoilpad()) then
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
    for i = 0, playerObj:getInventory():getItems():size() - 1 do
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
    for i = 0, playerObj:getInventory():getItems():size() - 1 do
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
    for i = 0, getSpecificPlayer(player):getInventory():getItems():size() - 1 do
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
      for _, item in ipairs(pourInto) do
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
    context:addOption(getText("ContextMenu_Pour_on_Ground"), items, ISInventoryPaneContextMenu.onDumpContents, pourOnGround, 40.0, player);
  end

  if isAllPills then
    context:addOption(getText("ContextMenu_Take_pills"), items, ISInventoryPaneContextMenu.onPillsItems, player);
  end
  if isAllLiterature and not getSpecificPlayer(player):HasTrait("Illiterate") then
    local readOption = context:addOption(getText("ContextMenu_Read"), items, ISInventoryPaneContextMenu.onLiteratureItems, player);
    if getSpecificPlayer(player):isAsleep() then
      readOption.notAvailable = true;
      local tooltip = ISInventoryPaneContextMenu.addToolTip();
      tooltip.description = getText("ContextMenu_NoOptionSleeping");
      readOption.toolTip = tooltip;
    end
  end
  if isAllClothing and not unequip then
    context:addOption(getText("ContextMenu_Wear"), items, ISInventoryPaneContextMenu.onWearItems, player);
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
      for i, v in ipairs(bodyPartDamaged) do
        subMenuBandage:addOption(BodyPartType.getDisplayName(v:getType()), items, ISInventoryPaneContextMenu.onApplyBandage, v, player);
      end
    end
  end
  -- dry yourself with a towel
  if canBeDry then
    context:addOption(getText("ContextMenu_Dry_myself"), items, ISInventoryPaneContextMenu.onDryMyself, player);
  end
  if isInPlayerInventory and not unequip and not ISInventoryPaneContextMenu.isAllFav(items) and playerObj:getJoypadBind() == -1 then
    context:addOption(getText("ContextMenu_Drop"), items, ISInventoryPaneContextMenu.onDropItems, player);
  end
  if brokenObject then
    local fixingList = FixingManager.getFixes(brokenObject);
    if not fixingList:isEmpty() then
      local fixOption = context:addOption(getText("ContextMenu_Repair") .. getItemText(brokenObject:getName()), items, nil);
      local subMenuFix = ISContextMenu:getNew(context);
      context:addSubMenu(fixOption, subMenuFix);
      for i = 0, fixingList:size() - 1 do
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
  if canBeRenamed then
    context:addOption(getText("ContextMenu_RenameBag"), canBeRenamed, ISInventoryPaneContextMenu.onRenameBag, player);
  end
  if canBeRenamedFood then
    context:addOption(getText("ContextMenu_RenameFood") .. canBeRenamedFood:getName(), canBeRenamedFood, ISInventoryPaneContextMenu.onRenameFood, player);
  end
  if canBeWrite then
    local editable = getSpecificPlayer(player):getInventory():contains("Pencil") or getSpecificPlayer(player):getInventory():contains("Pen")
    if canBeWrite:getLockedBy() and canBeWrite:getLockedBy() ~= getSpecificPlayer(player):getUsername() then
      editable = false
    end
    if not editable then
      context:addOption(getText("ContextMenu_Read_Note", canBeWrite:getName()), canBeWrite, ISInventoryPaneContextMenu.onWriteSomething, false, player);
    else
      context:addOption(getText("ContextMenu_Write_Note", canBeWrite:getName()), canBeWrite, ISInventoryPaneContextMenu.onWriteSomething, true, player);
    end
  end
  if map then
    context:addOption(getText("ContextMenu_CheckMap"), map, ISInventoryPaneContextMenu.onCheckMap, player);
    context:addOption(getText("ContextMenu_RenameMap"), map, ISInventoryPaneContextMenu.onRenameMap, player);
  end

  if (playerObj:getSquare():haveElectricity() or (SandboxVars.ElecShutModifier > - 1 and GameTime:getInstance():getNightsSurvived() < SandboxVars.ElecShutModifier and playerObj:getSquare():getRoom())) then
    if carBattery and carBattery:getUsedDelta() < 1 and playerObj:getInventory():getItemFromType("CarBatteryCharger") then
      context:addOption(getText("ContextMenu_ChargeCarBattery") .. "(" .. math.floor(carBattery:getUsedDelta() * 100) .. "%)", carBattery, ISInventoryPaneContextMenu.onChargeCarBattery, playerObj:getInventory():getItemFromType("CarBatteryCharger"), playerObj);
    end
    if carBatteryCharger then
      local batteryList = playerObj:getInventory():getItemsFromType("CarBattery1");
      batteryList:addAll(playerObj:getInventory():getItemsFromType("CarBattery2"));
      batteryList:addAll(playerObj:getInventory():getItemsFromType("CarBattery3"));
      if not batteryList:isEmpty() then
        local chargeOption = context:addOption(getText("ContextMenu_ChargeCarBattery"));
        local subMenuCharge = context:getNew(context);
        context:addSubMenu(chargeOption, subMenuCharge);
        local done = false;
        for i = 0, batteryList:size() - 1 do
          local battery = batteryList:get(i);
          if battery:getUsedDelta() < 1 then
            subMenuCharge:addOption(battery:getName() .. " (" .. math.floor(battery:getUsedDelta() * 100) .. "%)", battery, ISInventoryPaneContextMenu.onChargeCarBattery, carBatteryCharger, playerObj);
            done = true;
          end
        end
        if not done then context:removeLastOption(); end
      end
    end
  end
  -- use the event (as you would 'OnTick' etc) to add items to context menu without mod conflicts.
  triggerEvent("OnFillInventoryObjectContextMenu", player, context, items);

  return context;
end

ISInventoryPaneContextMenu.onChargeCarBattery = function(carBattery, carBatteryCharger, playerObj)
  ISTimedActionQueue.add(ISRechargeCarBattery:new(carBattery, carBatteryCharger, playerObj));
end

ISInventoryPaneContextMenu.addItemInEvoRecipe = function(subMenuRecipe, baseItem, evoItem, extraInfo, evorecipe2, player)
  local txt = getText("ContextMenu_From_Ingredient");
  if evorecipe2:isResultItem(baseItem) then
    txt = getText("ContextMenu_Add_Ingredient");
  end
  local option = subMenuRecipe:addOption(txt .. evoItem:getName() .. extraInfo, evorecipe2, ISInventoryPaneContextMenu.onAddItemInEvoRecipe, baseItem, evoItem, player);
  if instanceof(evoItem, "Food") and evoItem:getFreezingTime() > 0 then
    option.notAvailable = true;
    local tooltip = ISInventoryPaneContextMenu.addToolTip();
    tooltip.description = getText("ContextMenu_CantAddFrozenFood");
    option.toolTip = tooltip;
  end
end

ISInventoryPaneContextMenu.doEatOption = function(context, cmd, items, player, playerObj, foodItems)
  local eatOption = context:addOption(cmd, items, ISInventoryPaneContextMenu.onEatItems, 1, player)
  if foodItems[1] and foodItems[1]:getRequireInHandOrInventory() then
    local list = foodItems[1]:getRequireInHandOrInventory();
    local found = false;
    local required = "";
    for i = 0, list:size() - 1 do
      if playerObj:getInventory():contains(list:get(i), false) then
        found = true;
        break;
      end
      required = required .. list:get(i);
      if i < list:size() - 1 then
        required = required .. "/";
      end
    end
    if not found then
      eatOption.notAvailable = true
      local tooltip = ISInventoryPaneContextMenu.addToolTip();
      tooltip.description = getText("ContextMenu_Require", required);
      eatOption.toolTip = tooltip;
    end
  end
end

ISInventoryPaneContextMenu.checkConsolidate = function(drainable, player, context, previousPourInto)
  -- Check if we could consolidate drainable
  local consolidateList = {};
  if drainable and drainable:canConsolidate() then
    local otherDrainables = getSpecificPlayer(player):getInventory():getItemsFromType(drainable:getType());
    for i = 0, otherDrainables:size() - 1 do
      local otherDrain = otherDrainables:get(i);
      if otherDrain ~= drainable and otherDrain:getUsedDelta() < 1 then
        local addIt = true;
        for i, v in ipairs(previousPourInto) do
          if v == otherDrain then
            addIt = false;
            break;
          end
        end
        if addIt then
          table.insert(consolidateList, otherDrain);
        end
      end
    end
  end

  if #consolidateList > 0 then
    local consolidateOption = context:addOption(getText("ContextMenu_Pour_into"), nil, nil)
    local subMenuConsolidate = context:getNew(context)
    context:addSubMenu(consolidateOption, subMenuConsolidate)
    for _, intoItem in pairs(consolidateList) do
      subMenuConsolidate:addOption(intoItem:getName() .. " (" .. math.floor(intoItem:getUsedDelta() * 100) .. getText("ContextMenu_FullPercent") .. ")", drainable, ISInventoryPaneContextMenu.onConsolidate, intoItem, player)
    end
  end
end

ISInventoryPaneContextMenu.onConsolidate = function(drainable, intoItem, player)
  ISTimedActionQueue.add(ISConsolidateDrainable:new(player, drainable, intoItem, 90));
end

ISInventoryPaneContextMenu.OnTriggerRemoteController = function(remoteController, player)
  local playerObj = getSpecificPlayer(player);
  if isClient() then
    local args = { id = remoteController:getRemoteControlID(), range = remoteController:getRemoteRange() }
    sendClientCommand(playerObj, 'object', 'triggerRemote', args)
  else
    IsoTrap.triggerRemote(playerObj, remoteController:getRemoteControlID(), remoteController:getRemoteRange())
  end
end

ISInventoryPaneContextMenu.OnLinkRemoteController = function(itemToLink, remoteController, player)
  local playerObj = getSpecificPlayer(player)
  if remoteController:getRemoteControlID() == -1 then
    remoteController:setRemoteControlID(ZombRand(100000));
  end
  itemToLink:setRemoteControlID(remoteController:getRemoteControlID());
  ISInventoryPage.dirtyUI();
end

ISInventoryPaneContextMenu.isAllFav = function (items)
  local fav = true;
  items = ISInventoryPane.getActualItems(items)
  for i, k in ipairs(items) do
    if not k:isFavorite() then
      fav = false;
    end
  end
  return fav;
end

ISInventoryPaneContextMenu.OnResetRemoteControlID = function(item, player)
  local playerObj = getSpecificPlayer(player)
  item:setRemoteControlID(-1)
end

ISInventoryPaneContextMenu.onDrink = function(items, waterContainer, percentage, player)
  local playerObj = getSpecificPlayer(player)
  if luautils.haveToBeTransfered(playerObj, waterContainer) then
    ISTimedActionQueue.add(ISInventoryTransferAction:new(playerObj, waterContainer, waterContainer:getContainer(), playerObj:getInventory()));
  end
  -- how much use we have in the bottle
  local useLeft = waterContainer:getUsedDelta() / waterContainer:getUseDelta();
  ISTimedActionQueue.add(ISDrinkFromBottle:new(getSpecificPlayer(player), waterContainer, useLeft * percentage));
end

ISInventoryPaneContextMenu.onAddItemInEvoRecipe = function(recipe, baseItem, usedItem, player)
  local playerObj = getSpecificPlayer(player);
  if not playerObj:getInventory():contains(usedItem) then -- take the item if it's not in our inventory
    ISTimedActionQueue.add(ISInventoryTransferAction:new(playerObj, usedItem, usedItem:getContainer(), playerObj:getInventory(), nil));
  end
  if not playerObj:getInventory():contains(baseItem) then -- take the base item if it's not in our inventory
    ISTimedActionQueue.add(ISInventoryTransferAction:new(playerObj, baseItem, baseItem:getContainer(), playerObj:getInventory(), nil));
  end
  ISTimedActionQueue.add(ISAddItemInRecipe:new(getSpecificPlayer(player), recipe, baseItem, usedItem, (70 - getSpecificPlayer(player):getPerkLevel(Perks.Cooking))));
end

ISInventoryPaneContextMenu.buildFixingMenu = function(brokenObject, player, fixing, fixOption, subMenuFix, vehiclePart)
  local tooltip = ISInventoryPaneContextMenu.addToolTip();
  tooltip.description = "";
  --    fixOption.toolTip = tooltip;
  tooltip.texture = brokenObject:getTex();
  tooltip:setName(brokenObject:getName());
  -- fetch all the fixer item to build the sub menu and tooltip
  for i = 0, fixing:getFixers():size() - 1 do
    local fixer = fixing:getFixers():get(i);
    -- if you have this item in your main inventory
    local fixerItem = fixing:haveThisFixer(getSpecificPlayer(player), fixer, brokenObject);
    -- now test the required skill if needed
    local skillDescription = " ";
    if fixer:getFixerSkills() then
      for j = 0, fixer:getFixerSkills():size() - 1 do
        skillDescription = skillDescription .. PerkFactory.getPerk(Perks.FromString(fixer:getFixerSkills():get(j):getSkillName())):getName() .. "=" .. fixer:getFixerSkills():get(j):getSkillLevel() .. ",";
      end
    end
    local subOption = ISInventoryPaneContextMenu.addFixerSubOption(brokenObject, player, fixing, fixer, subMenuFix, vehiclePart);
    local add = "";

    if fixer:getNumberOfUse() > 1 then
      add = "="..fixer:getNumberOfUse();
    end
    if fixerItem then
      tooltip.description = tooltip.description .. " <LINE> " .. fixerItem:getName() .. add .. skillDescription;
    else
      tooltip.description = tooltip.description .. " <LINE> <RGB:1,0,0> " .. fixer:getFixerName() .. add .. skillDescription;
      subOption.notAvailable = true
    end
  end
end

ISInventoryPaneContextMenu.getContainers = function(character)
  if not character then return end
  local playerNum = character and character:getPlayerNum() or - 1;
  -- get all the surrounding inventory of the player, gonna check for the item in them too
  local containerList = ArrayList.new();
  for i, v in ipairs(getPlayerInventory(playerNum).inventoryPane.inventoryPage.backpacks) do
    containerList:add(v.inventory);
  end
  for i, v in ipairs(getPlayerLoot(playerNum).inventoryPane.inventoryPage.backpacks) do
    containerList:add(v.inventory);
  end
  return containerList;
end

ISInventoryPaneContextMenu.addFixerSubOption = function(brokenObject, player, fixing, fixer, subMenuFix, vehiclePart)
  local usedItem = InventoryItemFactory.CreateItem(fixing:getModule():getName() .. "." .. fixer:getFixerName());
  local fixOption = null;
  local tooltip = ISInventoryPaneContextMenu.addToolTip();
  local itemName
  if usedItem then
    tooltip.texture = usedItem:getTex();
    itemName = getItemText(usedItem:getName())
    fixOption = subMenuFix:addOption(fixer:getNumberOfUse() .. " " .. getItemText(usedItem:getName()), brokenObject, ISInventoryPaneContextMenu.onFix, player, fixing, fixer, vehiclePart);
  else
    fixOption = subMenuFix:addOption(fixer:getNumberOfUse() .. " " .. fixer:getFixerName(), brokenObject, ISInventoryPaneContextMenu.onFix, player, fixing, fixer, vehiclePart);
    itemName = fixer:getFixerName()
  end
  tooltip:setName(itemName);
  local condPercentRepaired = FixingManager.getCondRepaired(brokenObject, getSpecificPlayer(player), fixing, fixer);
  local color1 = "<RED>";
  if condPercentRepaired > 15 and condPercentRepaired <= 25 then
    color1 = "<ORANGE>";
  elseif condPercentRepaired > 25 then
    color1 = "<GREEN>";
  end
  local chanceOfSucess = 100 - FixingManager.getChanceOfFail(brokenObject, getSpecificPlayer(player), fixing, fixer);
  local color2 = "<RED>";
  if chanceOfSucess > 15 and chanceOfSucess <= 40 then
    color2 = "<ORANGE>";
  elseif chanceOfSucess > 40 then
    color2 = "<GREEN>";
  end
  tooltip.description = " " .. color1 .. " " .. getText("Tooltip_potentialRepair") .. " " .. math.ceil(condPercentRepaired) .. "%";
  tooltip.description = tooltip.description .. " <LINE> " .. color2 .. " " .. getText("Tooltip_chanceSuccess") .. " " .. math.ceil(chanceOfSucess) .. "%";

  tooltip.description = tooltip.description .. " <LINE> <LINE> <RGB:1,1,1> " .. getText("Tooltip_craft_Needs") .. ": <LINE> "
  -- do you have the global item
  local add = "";
  if fixing:getGlobalItem() then
    local globalItem = fixing:haveGlobalItem(getSpecificPlayer(player));
    local uses = fixing:countUses(getSpecificPlayer(player), fixing:getGlobalItem(), nil)
    if globalItem then
      tooltip.description = tooltip.description .. " <LINE> " .. globalItem:getName() .. " " .. uses .. "/" .. fixing:getGlobalItem():getNumberOfUse() .. " <LINE> ";
    else
      local globalItem = InventoryItemFactory.CreateItem(fixing:getModule():getName() .. "." .. fixing:getGlobalItem():getFixerName());
      local name = fixing:getGlobalItem():getFixerName();
      if globalItem then name = globalItem:getName(); end
      tooltip.description = tooltip.description .. " <LINE> <RGB:1,0,0> " .. name .. " " .. uses .. "/" .. fixing:getGlobalItem():getNumberOfUse() .. " <LINE> ";
      fixOption.notAvailable = true
    end
  end
  local uses = fixing:countUses(getSpecificPlayer(player), fixer, brokenObject)
  if uses >= fixer:getNumberOfUse() then color1 = " <RGB:1,1,1> " else color1 = " <RED> " end
  tooltip.description = tooltip.description .. color1 .. itemName .. " " .. uses .. "/" .. fixer:getNumberOfUse()
  if fixer:getFixerSkills() then
    local skills = fixer:getFixerSkills()
    for j = 0, skills:size() - 1 do
      local skill = skills:get(j)
      local perk = Perks.FromString(skill:getSkillName())
      local perkLvl = getSpecificPlayer(player):getPerkLevel(perk)
      if perkLvl >= skill:getSkillLevel() then color1 = " <RGB:1,1,1> " else color1 = " <RED> " end
      tooltip.description = tooltip.description .. " <LINE> " .. color1 .. PerkFactory.getPerk(perk):getName() .. " " .. perkLvl .. "/" .. skill:getSkillLevel()
    end
  end

  fixOption.toolTip = tooltip;
  return fixOption
end

ISInventoryPaneContextMenu.onFix = function(brokenObject, player, fixing, fixer, vehiclePart)
  ISTimedActionQueue.add(ISFixAction:new(getSpecificPlayer(player), brokenObject, 60, fixing, fixer, vehiclePart));
end

ISInventoryPaneContextMenu.onDryMyself = function(towels, player)
  towels = ISInventoryPane.getActualItems(towels)
  for i, k in ipairs(towels) do
    ISInventoryPaneContextMenu.dryMyself(k, player)
    break
  end
end

ISInventoryPaneContextMenu.onSetBombTimer = function(trap, player)
  local text = getText("IGUI_TimerSecondsBeforeExplosion");
  if trap:getSensorRange() > 0 then
    text = getText("IGUI_TimerSecondsBeforeActivation");
  end
  local modal = ISBombTimerDialog:new(0, 0, 280, 180, text, trap:getExplosionTimer(), getSpecificPlayer(player), nil, ISInventoryPaneContextMenu.onSetBombTimerClick, getSpecificPlayer(player), trap);
  modal:initialise();
  modal:addToUIManager();
  if JoypadState.players[player + 1] then
    modal.prevFocus = JoypadState.players[player + 1].focus
    JoypadState.players[player + 1].focus = modal;
  end
end

function ISInventoryPaneContextMenu:onSetBombTimerClick(button, player, item)
  if button.internal == "OK" then
    local seconds = button.parent:getTime()
    if seconds > 0 then
      item:setExplosionTimer(seconds)
    end
  end
end

ISInventoryPaneContextMenu.onStopAlarm = function(alarm, player)
  local playerObj = getSpecificPlayer(player);
  local sq = alarm:getAlarmSquare()
  if playerObj == nil or sq == nil then
    alarm:stopRinging()
    return
  end
  if luautils.walkAdj(playerObj, sq) then
    if not alarm:getWorldItem() and (alarm:getContainer() ~= playerObj:getInventory()) then
      ISTimedActionQueue.add(ISInventoryTransferAction:new(playerObj, alarm, alarm:getContainer(), playerObj:getInventory()))
    end
    ISTimedActionQueue.add(ISStopAlarmClockAction:new(playerObj, alarm, 20));
  end
end

ISInventoryPaneContextMenu.onSetAlarm = function(alarm, player)
  local playerObj = getSpecificPlayer(player);
  if not alarm:getWorldItem() and (alarm:getContainer() ~= playerObj:getInventory()) then
    local action = ISInventoryTransferAction:new(playerObj, alarm, alarm:getContainer(), playerObj:getInventory())
    action:setOnComplete(ISInventoryPaneContextMenu.onSetAlarm, alarm, player)
    ISTimedActionQueue.add(action)
    return
  end
  local modal = ISAlarmClockDialog:new(0, 0, 230, 160, player, alarm);
  modal:initialise();
  modal:addToUIManager();
  if JoypadState.players[player + 1] then
    modal.prevFocus = getPlayerInventory(player)
    setJoypadFocus(player, modal)
  end
end

ISInventoryPaneContextMenu.onRenameMap = function(map, player)
  local modal = ISTextBox:new(0, 0, 280, 180, getText("ContextMenu_NameThisBag"), map:getName(), nil, ISInventoryPaneContextMenu.onRenameBagClick, player, getSpecificPlayer(player), map);
  modal:initialise();
  modal:addToUIManager();
  if JoypadState.players[player + 1] then
    setJoypadFocus(player, modal)
  end
end

ISInventoryPaneContextMenu.onRenameBag = function(bag, player)
  local modal = ISTextBox:new(0, 0, 280, 180, getText("ContextMenu_NameThisBag"), bag:getName(), nil, ISInventoryPaneContextMenu.onRenameBagClick, player, getSpecificPlayer(player), bag);
  modal:initialise();
  modal:addToUIManager();
  if JoypadState.players[player + 1] then
    setJoypadFocus(player, modal)
  end
end

ISInventoryPaneContextMenu.onRenameFood = function(food, player)
  local modal = ISTextBox:new(0, 0, 280, 180, getText("ContextMenu_RenameFood") .. food:getName(), food:getName(), nil, ISInventoryPaneContextMenu.onRenameFoodClick, player, getSpecificPlayer(player), food);
  modal:initialise();
  modal:addToUIManager();
  if JoypadState.players[player + 1] then
    setJoypadFocus(player, modal)
  end
end

ISInventoryPaneContextMenu.onCheckMap = function(map, player)
  local playerObj = getSpecificPlayer(player)
  if luautils.haveToBeTransfered(playerObj, map) then
    local action = ISInventoryTransferAction:new(playerObj, map, map:getContainer(), playerObj:getInventory())
    action:setOnComplete(ISInventoryPaneContextMenu.onCheckMap, map, player)
    ISTimedActionQueue.add(action)
    return
  end

  if JoypadState.players[player + 1] then
    local inv = getPlayerInventory(player)
    local loot = getPlayerLoot(player)
    inv:setVisible(false)
    loot:setVisible(false)
  end

  local mapUI = ISMap:new(0, 0, 0, 0, map, player);
  mapUI:initialise();
  --    mapUI:addToUIManager();
  local wrap = mapUI:wrapInCollapsableWindow(map:getName(), false);
  wrap:addToUIManager();
  wrap:setInfo(getText("IGUI_Map_Info"));
  mapUI.wrap = wrap;
  wrap.render = ISMap.renderWrap;
  wrap.prerender = ISMap.prerenderWrap;
  wrap.setVisible = ISMap.setWrapVisible;
  wrap.mapUI = mapUI;
  mapUI.render = ISMap.noRender;
  mapUI.prerender = ISMap.noRender;
  map:doBuildingtStash();
  if JoypadState.players[player + 1] then
    setJoypadFocus(player, mapUI)
  end
end

ISInventoryPaneContextMenu.onWriteSomething = function(notebook, editable, player)
  local fontHgt = getTextManager():getFontFromEnum(UIFont.Small):getLineHeight()
  local height = 110 + (15 * fontHgt);
  local modal = ISUIWriteJournal:new(0, 0, 280, height, nil, ISInventoryPaneContextMenu.onWriteSomethingClick, getSpecificPlayer(player), notebook, notebook:seePage(1), notebook:getName(), 15, editable, notebook:getPageToWrite());
  modal:initialise();
  modal:addToUIManager();
  if JoypadState.players[player + 1] then
    setJoypadFocus(player, modal)
  end
end

function ISInventoryPaneContextMenu:onWriteSomethingClick(button)
  if button.internal == "OK" then
    for i, v in ipairs(button.parent.newPage) do
      button.parent.notebook:addPage(i, v);
    end
    button.parent.notebook:setName(button.parent.title:getText());
    button.parent.notebook:setCustomName(true);
  end
end

function ISInventoryPaneContextMenu:onRenameFoodClick(button, player, item)
  local playerNum = player:getPlayerNum()
  if button.internal == "OK" then
    if button.parent.entry:getText() and button.parent.entry:getText() ~= "" then
      item:setName(button.parent.entry:getText());
      item:setCustomName(true);
      local pdata = getPlayerData(playerNum);
      pdata.playerInventory:refreshBackpacks();
      pdata.lootInventory:refreshBackpacks();
    end
  end
  if JoypadState.players[playerNum + 1] then
    setJoypadFocus(playerNum, getPlayerInventory(playerNum))
  end
end

function ISInventoryPaneContextMenu:onRenameBagClick(button, player, item)
  local playerNum = player:getPlayerNum()
  if button.internal == "OK" then
    if button.parent.entry:getText() and button.parent.entry:getText() ~= "" then
      item:setName(button.parent.entry:getText());
      local pdata = getPlayerData(playerNum);
      pdata.playerInventory:refreshBackpacks();
      pdata.lootInventory:refreshBackpacks();
    end
  end
  if JoypadState.players[playerNum + 1] then
    setJoypadFocus(playerNum, getPlayerInventory(playerNum))
  end
end

ISInventoryPaneContextMenu.dryMyself = function(item, player)
  -- if towel isn't in main inventory, put it there first.
  local playerObj = getSpecificPlayer(player)
  if luautils.haveToBeTransfered(playerObj, item) then
    ISTimedActionQueue.add(ISInventoryTransferAction:new(playerObj, item, item:getContainer(), playerObj:getInventory()));
  end
  -- dry yourself
  -- how many use left on the towel
  local useLeft = math.ceil(item:getUsedDelta() * 10);
  ISTimedActionQueue.add(ISDryMyself:new(playerObj, item, (useLeft * 20) + 20));
end

ISInventoryPaneContextMenu.onApplyBandage = function(bandages, bodyPart, player)
  bandages = ISInventoryPane.getActualItems(bandages)
  for i, k in ipairs(bandages) do
    ISInventoryPaneContextMenu.applyBandage(k, bodyPart, player)
    break
  end
end

-- apply a bandage on a body part, loot it first if it's not in the player's inventory
ISInventoryPaneContextMenu.applyBandage = function(item, bodyPart, player)
  -- if bandage isn't in main inventory, put it there first.
  local playerObj = getSpecificPlayer(player)
  if luautils.haveToBeTransfered(playerObj, item) then
    ISTimedActionQueue.add(ISInventoryTransferAction:new(playerObj, item, item:getContainer(), playerObj:getInventory()));
  end
  -- apply bandage
  ISTimedActionQueue.add(ISApplyBandage:new(playerObj, playerObj, item, bodyPart, true));
end

-- look for any damaged body part on the player
ISInventoryPaneContextMenu.haveDamagePart = function(playerId)
  local result = {};
  local bodyParts = getSpecificPlayer(playerId):getBodyDamage():getBodyParts();
  -- fetch all the body part
  for i = 0, BodyPartType.ToIndex(BodyPartType.MAX) - 1 do
    local bodyPart = bodyParts:get(i);
    -- if it's damaged
    if bodyPart:scratched() or bodyPart:deepWounded() or bodyPart:bitten() or bodyPart:stitched() then
      table.insert(result, bodyPart);
    end
  end
  return result;
end

ISInventoryPaneContextMenu.onLiteratureItems = function(items, player)
  items = ISInventoryPane.getActualItems(items)
  for i, k in ipairs(items) do
    ISInventoryPaneContextMenu.readItem(k, player)
    break;
  end
end

-- read a book, loot it first if it's not in the player's inventory
ISInventoryPaneContextMenu.readItem = function(item, player)
  -- if clothing isn't in main inventory, put it there first.
  local playerObj = getSpecificPlayer(player)
  if luautils.haveToBeTransfered(playerObj, item) then
    ISTimedActionQueue.add(ISInventoryTransferAction:new(playerObj, item, item:getContainer(), playerObj:getInventory()));
  end
  -- read
  ISTimedActionQueue.add(ISReadABook:new(playerObj, item, 150));
end

ISInventoryPaneContextMenu.onUnEquip = function(items, player)
  items = ISInventoryPane.getActualItems(items)
  for i, k in ipairs(items) do
    ISInventoryPaneContextMenu.unequipItem(k, player)
  end
end

ISInventoryPaneContextMenu.unequipItem = function(item, player)
  if not getSpecificPlayer(player):isEquipped(item) then return end
  ISTimedActionQueue.add(ISUnequipAction:new(getSpecificPlayer(player), item, 50));
end

ISInventoryPaneContextMenu.onWearItems = function(items, player)
  items = ISInventoryPane.getActualItems(items)
  for i, k in pairs(items) do
    ISInventoryPaneContextMenu.wearItem(k, player)
    break
  end
end

ISInventoryPaneContextMenu.onActivateItem = function(light, player)
  light:setActivated(not light:isActivated());
end

-- Wear a clothe, loot it first if it's not in the player's inventory
ISInventoryPaneContextMenu.wearItem = function(item, player)
  -- if clothing isn't in main inventory, put it there first.
  local playerObj = getSpecificPlayer(player)
  if luautils.haveToBeTransfered(playerObj, item) then
    ISTimedActionQueue.add(ISInventoryTransferAction:new(playerObj, item, item:getContainer(), playerObj:getInventory()));
  end
  -- wear the clothe
  ISTimedActionQueue.add(ISWearClothing:new(playerObj, item, 50));
end

ISInventoryPaneContextMenu.onPutItems = function(items, player)
  local playerObj = getSpecificPlayer(player)
  local playerInv = getPlayerInventory(player).inventory
  local playerLoot = getPlayerLoot(player).inventory
  items = ISInventoryPane.getActualItems(items)
  for i, k in ipairs(items) do
    if not k:isFavorite() then
      ISTimedActionQueue.add(ISInventoryTransferAction:new(playerObj, k, playerInv, playerLoot))
    end
  end
end

ISInventoryPaneContextMenu.canMoveTo = function(items, dest, player)
  local playerObj = getSpecificPlayer(player)
  if instanceof(dest, "InventoryContainer") then
    local container = dest:getInventory()
    for i, item in ipairs(items) do
      if item == dest then return nil end
      if container:contains(item) then return nil end
      if container:getOnlyAcceptCategory() and (item:getCategory() ~= container:getOnlyAcceptCategory()) then return nil end
      if item:isFavorite() and not container:isInCharacterInventory(playerObj) then return nil end
    end
    return dest
  end
  if instanceof(dest, "ItemContainer") and dest:getType() == "floor" then
    for i, item in ipairs(items) do
      if item == dest then return nil end
      if dest:getItems():contains(item) then return nil end
      if item:isFavorite() and not dest:isInCharacterInventory(playerObj) then return nil end
    end
    return dest
  end
  return nil
end

ISInventoryPaneContextMenu.canUnpack = function(items, player)
  local playerObj = getSpecificPlayer(player)
  for i, item in ipairs(items) do
    if playerObj:getInventory():contains(item) then return false end
    if not item:getContainer():isInCharacterInventory(playerObj) then return false end
    --        if item:isFavorite() then return false; end
  end
  return true
end

ISInventoryPaneContextMenu.onFavorite = function(items, item2, fav)
  for i, item in ipairs(items) do
    item:setFavorite(fav);
  end
end

ISInventoryPaneContextMenu.onMoveItemsTo = function(items, dest, player)
  if dest:getType() == "floor" then
    return ISInventoryPaneContextMenu.onDropItems(items, player)
  end
  local playerObj = getSpecificPlayer(player)
  for i, item in ipairs(items) do
    if playerObj:isEquipped(item) then
      ISTimedActionQueue.add(ISUnequipAction:new(playerObj, item, 50));
    end
    ISTimedActionQueue.add(ISInventoryTransferAction:new(playerObj, item, item:getContainer(), dest))
  end
end

ISInventoryPaneContextMenu.canAddManyItems = function(recipe, selectedItem, playerObj)
  local container = selectedItem:getContainer();
  if not recipe:isCanBeDoneFromFloor() then
    container = playerObj:getInventory()
  end
  if isClient() and not instanceof(container:getParent(), "IsoGameCharacter") and getServerOptions():getInteger("ItemNumbersLimitPerContainer") > 0 and selectedItem:getContainer() then
    local createdItem = InventoryItemFactory.CreateItem(recipe:getResult():getFullType())
    if createdItem then
      local totalCount = createdItem:getCount() * recipe:getResult():getCount()
      if totalCount + container:getItems():size() + 1 > getServerOptions():getInteger("ItemNumbersLimitPerContainer") then
        return false;
      end
    end
  end
  --        end
  return true;
end

ISInventoryPaneContextMenu.addDynamicalContextMenu = function(selectedItem, context, recipe, player, containerList)
  local playerObj = getSpecificPlayer(player)
  for i = 0, recipe:size() - 1 do
    -- check if we have multiple item like this
    local numberOfTimes = RecipeManager.getNumberOfTimesRecipeCanBeDone(recipe:get(i), playerObj, containerList, selectedItem)
    local resultItem = InventoryItemFactory.CreateItem(recipe:get(i):getResult():getFullType());
    local option = nil;
    local subMenuCraft = nil;
    if numberOfTimes ~= 1 then
      subMenuCraft = context:getNew(context);
      option = context:addOption(recipe:get(i):getName(), selectedItem, nil);
      context:addSubMenu(option, subMenuCraft);
      if playerObj:isDriving() then
        option.notAvailable = true;
      else
        subMenuCraft:addOption(getText("ContextMenu_One"), selectedItem, ISInventoryPaneContextMenu.OnCraft, recipe:get(i), player, false);
        if numberOfTimes > 1 then
          subMenuCraft:addOption(getText("ContextMenu_AllWithCount", numberOfTimes), selectedItem, ISInventoryPaneContextMenu.OnCraft, recipe:get(i), player, true);
        else
          subMenuCraft:addOption(getText("ContextMenu_All"), selectedItem, ISInventoryPaneContextMenu.OnCraft, recipe:get(i), player, true);
        end
      end
    else
      option = context:addOption(recipe:get(i):getName(), selectedItem, ISInventoryPaneContextMenu.OnCraft, recipe:get(i), player, false);
    end
    -- limit doing a recipe that add multiple items if the dest container has an item limit
    if not ISInventoryPaneContextMenu.canAddManyItems(recipe:get(i), selectedItem, playerObj) then
      option.notAvailable = true;
      if subMenuCraft then
        for i, v in ipairs(subMenuCraft.options) do
          v.notAvailable = true;
          local tooltip = ISInventoryPaneContextMenu.addToolTip();
          tooltip.description = getText("Tooltip_CantCraftDriving");
          v.toolTip = tooltip;
        end
      end
      local tooltip = ISInventoryPaneContextMenu.addToolTip();
      tooltip.description = getText("Tooltip_CantCraftDriving");
      option.toolTip = tooltip;
      return;
    end
    if playerObj:isDriving() then
      option.notAvailable = true;
      local tooltip = ISInventoryPaneContextMenu.addToolTip();
      tooltip.description = getText("Tooltip_CantCraftDriving");
      option.toolTip = tooltip;
    end
    if recipe:get(i):getNumberOfNeededItem() > 0 and not playerObj:isDriving() then
      local tooltip = ISInventoryPaneContextMenu.addToolTip();
      -- add it to our current option
      tooltip:setName(recipe:get(i):getName());
      -- we display all the needed item for the craft
      for j = 0, recipe:get(i):getSource():size() - 1 do
        local source = recipe:get(i):getSource():get(j)
        local txt = "";

        for k = 1, source:getItems():size() do
          local sourceFullType = source:getItems():get(k - 1)
          local item = nil
          if sourceFullType ~= "Water" then
            item = InventoryItemFactory.CreateItem(sourceFullType)
          end
          if txt ~= "" then txt = txt .. ", " end
          if item then
            txt = txt .. item:getDisplayName();
          elseif sourceFullType == "Water" then
            txt = txt .. getText("ContextMenu_WaterName")
          else
            txt = txt .. sourceFullType
          end
        end

        if recipe:get(i):getSource():get(j):isKeep() then
          txt = getText("ContextMenu_Keep") .. txt;
        end

        if recipe:get(i):getSource():get(j):getCount() > 1 then
          txt = txt .. " x " .. recipe:get(i):getSource():get(j):getCount();
        end

        tooltip.description = tooltip.description .. " <RGB:1,1,1> " .. txt .. " <LINE> ";

        if resultItem:getTexture() and resultItem:getTexture():getName() ~= "Question_On" then
          tooltip:setTexture(resultItem:getTexture():getName());
        end
      end
      option.toolTip = tooltip;
    end
  end
end

ISInventoryPaneContextMenu.addToolTip = function()
  local toolTip = ISToolTip:new();
  toolTip:initialise();
  toolTip:setVisible(false);
  return toolTip;
end

ISInventoryPaneContextMenu.OnCraft = function(selectedItem, recipe, player, all)
  local playerObj = getSpecificPlayer(player)
  local containers = ISInventoryPaneContextMenu.getContainers(playerObj)
  local container = selectedItem:getContainer()
  if not recipe:isCanBeDoneFromFloor() then
    container = playerObj:getInventory()
  end
  local items = RecipeManager.getAvailableItemsNeeded(recipe, playerObj, containers, selectedItem, nil)
  if not recipe:isCanBeDoneFromFloor() then
    for i = 1, items:size() do
      local item = items:get(i - 1)
      if item:getContainer() ~= playerObj:getInventory() then
        ISTimedActionQueue.add(ISInventoryTransferAction:new(playerObj, item, item:getContainer(), playerObj:getInventory(), nil))
      end
    end
  end
  local action = ISCraftAction:new(playerObj, selectedItem, recipe:getTimeToMake(), recipe, container, containers)
  if all then
    action:setOnComplete(ISInventoryPaneContextMenu.OnCraftComplete, action, recipe, playerObj, container, containers, selectedItem)
  end
  ISTimedActionQueue.add(action)
end

ISInventoryPaneContextMenu.OnCraftComplete = function(completedAction, recipe, playerObj, container, containers, selectedItem)
  if not RecipeManager.IsRecipeValid(recipe, playerObj, nil, containers) then return end
  local items = RecipeManager.getAvailableItemsNeeded(recipe, playerObj, containers, nil, nil)
  if items:isEmpty() then return end
  if not ISInventoryPaneContextMenu.canAddManyItems(recipe, items:get(0), playerObj) then
    return;
  end
  local previousAction = completedAction
  if not recipe:isCanBeDoneFromFloor() then
    for i = 1, items:size() do
      local item = items:get(i - 1)
      if item:getContainer() ~= playerObj:getInventory() then
        local action = ISInventoryTransferAction:new(playerObj, item, item:getContainer(), playerObj:getInventory(), nil)
        ISTimedActionQueue.addAfter(previousAction, action)
        previousAction = action
      end
    end
  end
  local action = ISCraftAction:new(playerObj, items:get(0), recipe:getTimeToMake(), recipe, container, containers)
  action:setOnComplete(ISInventoryPaneContextMenu.OnCraftComplete, action, recipe, playerObj, container, containers)
  ISTimedActionQueue.addAfter(previousAction, action)
end

ISInventoryPaneContextMenu.eatItem = function(item, percentage, player)
  --	if not player then
  local playerObj = getSpecificPlayer(player);
  --	end
  -- if food isn't in main inventory, put it there first.
  if luautils.haveToBeTransfered(playerObj, item) then
    ISTimedActionQueue.add(ISInventoryTransferAction:new(playerObj, item, item:getContainer(), playerObj:getInventory()));
  end
  -- Then eat it.
  ISTimedActionQueue.add(ISEatFoodAction:new(playerObj, item, percentage));
end

-- Function that unequip primary weapon and equip the selected weapon
ISInventoryPaneContextMenu.OnPrimaryWeapon = function(items, player)
  items = ISInventoryPane.getActualItems(items)
  for i, k in ipairs(items) do
    if (instanceof(k, "HandWeapon") and k:getCondition() > 0) or (instanceof(k, "InventoryItem") and not instanceof(k, "HandWeapon")) then
      ISInventoryPaneContextMenu.equipWeapon(k, true, false, player)
      break
    end
  end
end

--> Stormy
-- Function that unequip primary weapon and equip the selected weapon
ISInventoryPaneContextMenu.OnReload = function(items, player)
  -- if the item you've selected is not the header
  local weapon = items[1];
  -- if it's a header, we get our first item (the selected one)
  if not instanceof(items[1], "InventoryItem") then
    weapon = items[1].items[1];
  end
  -- do reload
  ReloadManager[player + 1]:startReloadFromUi(weapon);
end
-->> Stormy

-- Function that goes through all pills selected and take them.
ISInventoryPaneContextMenu.onPillsItems = function(items, player)
  items = ISInventoryPane.getActualItems(items)
  for i, k in ipairs(items) do
    ISInventoryPaneContextMenu.takePill(k, player)
    break
  end
end

-- Take a pill, loot it first if it's not in the player's inventory
ISInventoryPaneContextMenu.takePill = function(item, player)
  local playerObj = getSpecificPlayer(player);
  -- if pill isn't in main inventory, put it there first.
  if luautils.haveToBeTransfered(playerObj, item) then
    ISTimedActionQueue.add(ISInventoryTransferAction:new(playerObj, item, item:getContainer(), playerObj:getInventory()));
  end
  -- take the pill
  ISTimedActionQueue.add(ISTakePillAction:new(playerObj, item, 30));
end

ISInventoryPaneContextMenu.OnTwoHandsEquip = function(items, player)
  items = ISInventoryPane.getActualItems(items)
  for _, item in ipairs(items) do
    ISInventoryPaneContextMenu.equipWeapon(item, false, true, player)
    break
  end
end

-- Function that unequip second weapon and equip the selected weapon
ISInventoryPaneContextMenu.OnSecondWeapon = function(items, player)
  items = ISInventoryPane.getActualItems(items)
  for _, item in ipairs(items) do
    ISInventoryPaneContextMenu.equipWeapon(item, false, false, player)
    break
  end
end

-- Function that equip the selected weapon
ISInventoryPaneContextMenu.equipWeapon = function(weapon, primary, twoHands, player)
  -- if weapon isn't in main inventory, put it there first.
  local playerObj = getSpecificPlayer(player)
  if luautils.haveToBeTransfered(playerObj, weapon) then
    ISTimedActionQueue.add(ISInventoryTransferAction:new(playerObj, weapon, weapon:getContainer(), playerObj:getInventory()));
  end
  -- Then equip it.
  ISTimedActionQueue.add(ISEquipWeaponAction:new(playerObj, weapon, 50, primary, twoHands));
end

ISInventoryPaneContextMenu.onInformationItems = function(items)
  items = ISInventoryPane.getActualItems(items)
  for i, k in pairs(items) do
    ISInventoryPaneContextMenu.information(k)
    break
  end
end

ISInventoryPaneContextMenu.information = function(item)
  --~ 	local tooltip = ObjectTooltip.new();
  --~ 	item:DoTooltip(tooltip);
  ISInventoryPaneContextMenu.removeToolTip();
  ISInventoryPaneContextMenu.toolRender = ISToolTipInv:new(item);
  ISInventoryPaneContextMenu.toolRender:initialise();
  ISInventoryPaneContextMenu.toolRender:addToUIManager();
  ISInventoryPaneContextMenu.toolRender:setVisible(true);
end

ISInventoryPaneContextMenu.removeToolTip = function()
  if ISInventoryPaneContextMenu.toolRender then
    ISInventoryPaneContextMenu.toolRender:removeFromUIManager();
    ISInventoryPaneContextMenu.toolRender:setVisible(false);
  end
end

-- Function that goes through all items selected and eats them.
-- eat only 1 of the item list
ISInventoryPaneContextMenu.onEatItems = function(items, percentage, player)
  items = ISInventoryPane.getActualItems(items)
  for i, k in ipairs(items) do
    ISInventoryPaneContextMenu.eatItem(k, percentage, player)
    break
  end
end

ISInventoryPaneContextMenu.onPlaceTrap = function(weapon, player)
  ISTimedActionQueue.add(ISPlaceTrap:new(player, weapon, 50));
end

ISInventoryPaneContextMenu.onRemoveUpgradeWeapon = function(weapon, part, player)
  if luautils.haveToBeTransfered(player, weapon) then
    ISTimedActionQueue.add(ISInventoryTransferAction:new(player, weapon, weapon:getContainer(), player:getInventory()));
  end
  if player:getInventory():contains("Screwdriver") then
    ISInventoryPaneContextMenu.equipWeapon(player:getInventory():getItemFromType("Screwdriver"), true, false, player:getPlayerNum());
    ISTimedActionQueue.add(ISRemoveWeaponUpgrade:new(player, weapon, part, 50));
  end
end

ISInventoryPaneContextMenu.onUpgradeWeapon = function(weapon, part, player)
  if luautils.haveToBeTransfered(player, weapon) then
    ISTimedActionQueue.add(ISInventoryTransferAction:new(player, weapon, weapon:getContainer(), player:getInventory()));
  end
  if luautils.haveToBeTransfered(player, part) then
    ISTimedActionQueue.add(ISInventoryTransferAction:new(player, part, part:getContainer(), player:getInventory()));
  end
  if player:getInventory():contains("Screwdriver") then
    ISInventoryPaneContextMenu.equipWeapon(part, false, false, player:getPlayerNum());
    ISInventoryPaneContextMenu.equipWeapon(player:getInventory():getItemFromType("Screwdriver"), true, false, player:getPlayerNum());
    ISTimedActionQueue.add(ISUpgradeWeapon:new(player, weapon, part, 50));
  end
end

ISInventoryPaneContextMenu.onDropItems = function(items, player)
  local playerObj = getSpecificPlayer(player)
  items = ISInventoryPane.getActualItems(items)
  ISInventoryPaneContextMenu.transferItems(items, playerObj:getInventory(), player)
  for _, item in ipairs(items) do
    if not item:isFavorite() then
      ISInventoryPaneContextMenu.dropItem(item, player)
    end
  end
end

ISInventoryPaneContextMenu.dropItem = function(item, player)
  -- if item isn't in main inventory, put it there first.
  local playerObj = getSpecificPlayer(player)
  if luautils.haveToBeTransfered(playerObj, item) then
    ISTimedActionQueue.add(ISInventoryTransferAction:new(playerObj, item, item:getContainer(), playerObj:getInventory()));
  end
  ISTimedActionQueue.add(ISInventoryTransferAction:new(playerObj, item, playerObj:getInventory(), ISInventoryPage.floorContainer[player + 1]));
end

ISInventoryPaneContextMenu.onGrabItems = function(items, player)
  local playerInv = getPlayerInventory(player).inventory;
  ISInventoryPaneContextMenu.transferItems(items, playerInv, player)
end

ISInventoryPaneContextMenu.transferItems = function(items, playerInv, player)
  local playerObj = getSpecificPlayer(player)
  items = ISInventoryPane.getActualItems(items)
  for i, k in ipairs(items) do
    if k:getContainer() ~= playerInv and k:getContainer() ~= nil then
      ISTimedActionQueue.add(ISInventoryTransferAction:new(playerObj, k, k:getContainer(), playerInv))
    end
  end
end

ISInventoryPaneContextMenu.onGrabHalfItems = function(items, player)
  local playerObj = getSpecificPlayer(player)
  local playerInv = getPlayerInventory(player).inventory;
  for i, k in ipairs(items) do
    if not instanceof(k, "InventoryItem") then
      local count = math.floor((#k.items - 1) / 2)
      -- first in a list is a dummy duplicate, so ignore it.
      for i2 = 1, count do
        local k2 = k.items[i2 + 1]
        if k2:getContainer() ~= playerInv then
          ISTimedActionQueue.add(ISInventoryTransferAction:new(playerObj, k2, k2:getContainer(), playerInv))
        end
      end
    elseif k:getContainer() ~= playerInv then
      ISTimedActionQueue.add(ISInventoryTransferAction:new(playerObj, k, k:getContainer(), playerInv))
    end
  end
end

ISInventoryPaneContextMenu.onEditItem = function(items, player, item)
  local ui = ISItemEditorUI:new(50, 50, 600, 600, player, item);
  ui:initialise();
  ui:addToUIManager();
end

ISInventoryPaneContextMenu.onGrabOneItems = function(items, player)
  items = ISInventoryPane.getActualItems(items)
  local playerInv = getPlayerInventory(player).inventory;
  for i, k in ipairs(items) do
    if k:getContainer() ~= playerInv then
      ISTimedActionQueue.add(ISInventoryTransferAction:new(getSpecificPlayer(player), k, k:getContainer(), playerInv));
      return;
    end
  end
end

-- Crowley
-- Pours water from one container into another.
ISInventoryPaneContextMenu.onTransferWater = function(items, itemFrom, itemTo, player)
  --print("Moving water from " .. itemFrom:getName() .. " to " .. itemTo:getName());
  if not itemTo:isWaterSource() then
    local newItemType = itemTo:getReplaceOnUseOn();
    newItemType = string.sub(newItemType, 13);
    newItemType = itemTo:getModule() .. "." .. newItemType;

    local newItem = InventoryItemFactory.CreateItem(newItemType, 0);
    getSpecificPlayer(player):getInventory():AddItem(newItem);
    getSpecificPlayer(player):getInventory():Remove(itemTo);

    itemTo = newItem;
  end
  --
  local waterStorageAvailable = (1 - itemTo:getUsedDelta()) / itemTo:getUseDelta();
  local waterStorageNeeded = itemFrom:getUsedDelta() / itemFrom:getUseDelta();

  local itemFromEndingDelta = 0;
  local itemToEndingDelta = nil;
  --
  if waterStorageAvailable >= waterStorageNeeded then
    --Transfer all water to the the second container.
    local waterInA = itemTo:getUsedDelta() / itemTo:getUseDelta();
    local waterInB = itemFrom:getUsedDelta() / itemFrom:getUseDelta();
    local totalWater = waterInA + waterInB;

    itemToEndingDelta = totalWater * itemTo:getUseDelta();
    itemFromEndingDelta = 0;
  end

  if waterStorageAvailable < waterStorageNeeded then
    --Transfer what we can. Leave the rest in the container.
    local waterInB = itemFrom:getUsedDelta() / itemFrom:getUseDelta();
    local waterRemainInB = waterInB - waterStorageAvailable;

    itemFromEndingDelta = waterRemainInB * itemFrom:getUseDelta();
    itemToEndingDelta = 1;
  end

  local playerObj = getSpecificPlayer(player)
  if luautils.haveToBeTransfered(playerObj, itemFrom) then
    ISTimedActionQueue.add(ISInventoryTransferAction:new(playerObj, itemFrom, itemFrom:getContainer(), playerObj:getInventory()));
  end

  ISTimedActionQueue.add(ISTransferWaterAction:new(getSpecificPlayer(player), itemFrom, itemTo, itemFromEndingDelta, itemToEndingDelta));
end
--/Crowley

-- Crowley
-- Empties a water container
ISInventoryPaneContextMenu.onEmptyWaterContainer = function(items, waterSource, player)
  if waterSource ~= nil then
    local playerObj = getSpecificPlayer(player)
    if luautils.haveToBeTransfered(playerObj, waterSource) then
      ISTimedActionQueue.add(ISInventoryTransferAction:new(playerObj, waterSource, waterSource:getContainer(), playerObj:getInventory()));
    end
    ISTimedActionQueue.add(ISDumpWaterAction:new(playerObj, waterSource));
  end
end
--/Crowley

-- Return true if the given item's ReplaceOnUse type can hold water.
-- The check is recursive to handle RemouladeFull -> RemouladeHalf -> RemouladeEmpty.
ISInventoryPaneContextMenu.canReplaceStoreWater = function(item)
  --	print('testing ' .. item:getFullType())
  if not item:getReplaceOnUse() then return false end
  return ISInventoryPaneContextMenu.canReplaceStoreWater2(item:getModule()..'.'..item:getReplaceOnUse())
end

ISInventoryPaneContextMenu.canReplaceStoreWater2 = function(itemType)
  --	print('testing ' .. itemType)
  local item = ScriptManager.instance:FindItem(itemType)
  if item == nil then return false end
  if item:getCanStoreWater() then
    return true
  end
  if not item:getReplaceOnUse() then return false end
  return ISInventoryPaneContextMenu.canReplaceStoreWater2(item:getModuleName()..'.'..item:getReplaceOnUse())
end

ISInventoryPaneContextMenu.onDumpContents = function(items, item, time, player)
  if item ~= nil then
    local playerObj = getSpecificPlayer(player)
    if luautils.haveToBeTransfered(playerObj, item) then
      ISTimedActionQueue.add(ISInventoryTransferAction:new(playerObj, item, item:getContainer(), playerObj:getInventory()));
    end
    ISTimedActionQueue.add(ISDumpContentsAction:new(playerObj, item, time));
  end
end

ISInventoryPaneContextMenu.startWith = function(String, Start)
  return string.sub(String, 1, string.len(Start)) == Start;
end

ISInventoryPaneContextMenu.getRealEvolvedItemUse = function(evoItem, evorecipe2, cookingLvl)
  if not evoItem or not evorecipe2 or not evorecipe2:getItemRecipe(evoItem) then return; end
  local use = evorecipe2:getItemRecipe(evoItem):getUse();
  if use > math.abs(evoItem:getHungerChange() * 100) then
    use = math.floor(math.abs(evoItem:getHungerChange() * 100));
  end
  if evoItem:isRotten() then
    if cookingLvl == 7 or cookingLvl == 8 then
      use = math.abs(round(evoItem:getBaseHunger() - (evoItem:getBaseHunger() - ((5 / 100) * evoItem:getBaseHunger())), 3)) * 100;
    else
      use = math.abs(round(evoItem:getBaseHunger() - (evoItem:getBaseHunger() - ((10 / 100) * evoItem:getBaseHunger())), 3)) * 100;
    end
  end
  return use;
end
