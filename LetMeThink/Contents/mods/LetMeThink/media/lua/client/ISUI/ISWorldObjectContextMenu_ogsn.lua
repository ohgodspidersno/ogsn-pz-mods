
-- MAIN METHOD FOR CREATING RIGHT CLICK CONTEXT MENU FOR WORLD ITEMS
ISWorldObjectContextMenu.createMenu = function(player, worldobjects, x, y, test)
  if getCore():getGameMode() == "Tutorial" then
    local context = Tutorial1.createWorldContextMenu(player, worldobjects, x, y);
    return context;
  end
  -- if the game is paused, we don't show the world context menu
  if UIManager.getSpeedControls|():getCurrentGameSpeed() == 0 then
    return;
  end

  local playerObj = getSpecificPlayer(player)
  local playerInv = playerObj:getInventory()
  if playerObj:isAsleep() then return end

  --    x = x + getPlayerData(player).x1left;
  --    y = y + getPlayerData(player).y1top;

  local context = ISContextMenu.get(player, x, y);

  -- avoid doing action while trading (you could eat half an apple and still trade it...)
  if ISTradingUI.instance and ISTradingUI.instance:isVisible() then
    context:addOption(getText("IGUI_TradingUI_CantRightClick"), nil, nil);
    return;
  end

  context.blinkOption = ISWorldObjectContextMenu.blinkOption;

  if test then context:setVisible(false) end
  ISWorldObjectContextMenu.Test = false

  getCell():setDrag(nil, player);

  ISWorldObjectContextMenu.clearFetch()
  for i, v in ipairs(worldobjects) do
    ISWorldObjectContextMenu.fetch(v, player, true);
  end

  triggerEvent("OnPreFillWorldObjectContextMenu", player, context, worldobjects, test);

  if c == 0 then
    return;
  end

  for _, tooltip in ipairs(ISWorldObjectContextMenu.tooltipsUsed) do
    table.insert(ISWorldObjectContextMenu.tooltipPool, tooltip);
  end
  --    print('reused ',#ISWorldObjectContextMenu.tooltipsUsed,' world tooltips')
  table.wipe(ISWorldObjectContextMenu.tooltipsUsed);

  local heavyItem = playerObj:getPrimaryHandItem()
  if isForceDropHeavyItem(heavyItem) then
    context:addOption(getText("ContextMenu_DropNamedItem", heavyItem:getDisplayName()), {heavyItem}, ISInventoryPaneContextMenu.onUnEquip, player)
  end

  -- Grab a world item
  if worldItem and getCore():getGameMode() ~= "LastStand" then
    if test == true then return true; end
    local itemList = {}
    local doneSquare = {}
    for i, v in ipairs(worldobjects) do
      if v:getSquare() and not doneSquare[v:getSquare()] then
        doneSquare[v:getSquare()] = true
        for n = 0, v:getSquare():getWorldObjects():size() - 1 do
          local item = v:getSquare():getWorldObjects():get(n)
          local itemName = item:getName() or (item:getItem():getName() or "???")
          if not itemList[itemName] then itemList[itemName] = {} end
          table.insert(itemList[itemName], item)
        end
      end
    end
    local grabOption = context:addOption(getText("ContextMenu_Grab"), worldobjects, nil)
    local subMenuGrab = ISContextMenu:getNew(context)
    context:addSubMenu(grabOption, subMenuGrab)
    for name, items in pairs(itemList) do
      if #items > 1 then
        name = name..' ('..#items..')'
      end
      if #items > 2 then
        local itemOption = subMenuGrab:addOption(name, worldobjects, nil)
        local subMenuItem = ISContextMenu:getNew(subMenuGrab)
        subMenuGrab:addSubMenu(itemOption, subMenuItem)
        subMenuItem:addOption(getText("ContextMenu_Grab_one"), worldobjects, ISWorldObjectContextMenu.onGrabWItem, items[1], player);
        subMenuItem:addOption(getText("ContextMenu_Grab_half"), worldobjects, ISWorldObjectContextMenu.onGrabHalfWItems, items, player);
        subMenuItem:addOption(getText("ContextMenu_Grab_all"), worldobjects, ISWorldObjectContextMenu.onGrabAllWItems, items, player);
      elseif #items > 1 and items[1]:getItem():getActualWeight() >= 3 then
        local itemOption = subMenuGrab:addOption(name, worldobjects, nil)
        local subMenuItem = ISContextMenu:getNew(subMenuGrab)
        subMenuGrab:addSubMenu(itemOption, subMenuItem)
        subMenuItem:addOption(getText("ContextMenu_Grab_one"), worldobjects, ISWorldObjectContextMenu.onGrabWItem, items[1], player);
        subMenuItem:addOption(getText("ContextMenu_Grab_all"), worldobjects, ISWorldObjectContextMenu.onGrabAllWItems, items, player);
      else
        subMenuGrab:addOption(name, worldobjects, ISWorldObjectContextMenu.onGrabAllWItems, items, player)
      end
    end
  end

  if ashes then
    if test == true then return true; end
    context:addOption(getText("ContextMenu_Clear_Ashes"), worldobjects, ISWorldObjectContextMenu.onClearAshes, player, ashes);
  end

  if (JoypadState.players[player + 1] or ISEmptyGraves.canDigHere(worldobjects)) and not playerObj:getVehicle() and shovel then
    if test == true then return true; end
    context:addOption(getText("ContextMenu_DigGraves"), worldobjects, ISWorldObjectContextMenu.onDigGraves, player, shovel);
  end
  if graves and not ISEmptyGraves.isGraveFullOfCorpses(graves) and (playerInv:contains("CorpseMale") or playerInv:contains("CorpseFemale")) then
    if test == true then return true; end
    context:addOption(getText("ContextMenu_BuryCorpse", graves:getModData()["corpses"]), graves, ISWorldObjectContextMenu.onBuryCorpse, player, shovel);
  end
  if graves and shovel then
    if test == true then return true; end
    context:addOption(getText("ContextMenu_FillGrave", graves:getModData()["corpses"]), graves, ISWorldObjectContextMenu.onFillGrave, player, shovel)
  end

  if trap and trap:getItem() then
    if test == true then return true end
    local doneSquare = {}
    for i, v in ipairs(worldobjects) do
      if v:getSquare() and not doneSquare[v:getSquare()] then
        doneSquare[v:getSquare()] = true
        for n = 1, v:getSquare():getObjects():size() do
          local trap = v:getSquare():getObjects():get(n - 1)
          if instanceof(trap, "IsoTrap") and trap:getItem() then
            context:addOption(getText("ContextMenu_TrapTake", trap:getItem():getName()), worldobjects, ISWorldObjectContextMenu.onTakeTrap, trap, player)
          end
        end
      end
    end
  end

  body = IsoObjectPicker.Instance:PickCorpse(x, y) or body
  if body then
    if playerInv:getItemCount("Base.CorpseMale") == 0 then
      if test == true then return true; end
      context:addOption(getText("ContextMenu_Grab_Corpse"), worldobjects, ISWorldObjectContextMenu.onGrabCorpseItem, body, player);
    end
    if playerInv:containsTypeEvalRecurse("PetrolCan", predicateNotEmpty) and (playerInv:containsTypeRecurse("Lighter") or playerInv:containsTypeRecurse("Matches")) then
      if test == true then return true; end
      context:addOption(getText("ContextMenu_Burn_Corpse"), worldobjects, ISWorldObjectContextMenu.onBurnCorpse, player, body);
    end
  end

  if door and not door:IsOpen() and doorKeyId then
    if playerInv:haveThisKeyId(doorKeyId) or not playerObj:getCurrentSquare():Is(IsoFlagType.exterior) then
      if test == true then return true; end
      if not door:isLockedByKey() then
        context:addOption(getText("ContextMenu_LockDoor"), worldobjects, ISWorldObjectContextMenu.onLockDoor, player, door);
      else
        context:addOption(getText("ContextMenu_UnlockDoor"), worldobjects, ISWorldObjectContextMenu.onUnLockDoor, player, door, doorKeyId);
      end
    end
  end

  -- if the player have a padlock with a key on it
  if padlockThump then
    local padlock = playerInv:FindAndReturn("Padlock");
    if padlock and padlock:getNumberOfKey() > 0 then
      if test == true then return true; end
      context:addOption(getText("ContextMenu_PutPadlock"), worldobjects, ISWorldObjectContextMenu.onPutPadlock, player, padlockThump, padlock);
    end
    local digitalPadlock = playerInv:FindAndReturn("CombinationPadlock");
    if digitalPadlock then
      if test == true then return true; end
      context:addOption(getText("ContextMenu_PutCombinationPadlock"), worldobjects, ISWorldObjectContextMenu.onPutDigitalPadlock, player, padlockThump, digitalPadlock);
    end
  end

  if padlockedThump and playerInv:haveThisKeyId(padlockedThump:getKeyId()) then
    if test == true then return true; end
    context:addOption(getText("ContextMenu_RemovePadlock"), worldobjects, ISWorldObjectContextMenu.onRemovePadlock, player, padlockedThump);
  end

  if digitalPadlockedThump then
    if test == true then return true; end
    context:addOption(getText("ContextMenu_RemoveCombinationPadlock"), worldobjects, ISWorldObjectContextMenu.onRemoveDigitalPadlock, player, digitalPadlockedThump);
  end

  if canBeWaterPiped then
    if test == true then return true; end
    local props = canBeWaterPiped:getSprite():getProperties();
    local name = (props:Is("CustomName") and props:Val("CustomName")) or (props:Is("GroupName") and props:Val("GroupName")) or "";
    local option = context:addOption(getText("ContextMenu_PlumbItem", name), worldobjects, ISWorldObjectContextMenu.onPlumbItem, player, canBeWaterPiped);
    if not playerInv:containsTypeEvalRecurse("Wrench", predicateNotBroken) then
      option.notAvailable = true;
      local tooltip = ISWorldObjectContextMenu.addToolTip()
      tooltip:setName(getText("ContextMenu_PlumbItem", name));
      local usedItem = InventoryItemFactory.CreateItem("Base.Wrench");
      tooltip.description = getText("Tooltip_NeedWrench", usedItem:getName());
      option.toolTip = tooltip;
    end
  end


  -- get back the key on the lock
  --    if door and doorKeyId and door:haveKey() and not playerObj:getSquare():Is(IsoFlagType.exterior) then
  --        context:addOption("Get the key", worldobjects, ISWorldObjectContextMenu.onGetDoorKey, player, door, doorKeyId);
  --    end

  --~ 	context:addOption("Sit", worldobjects, ISWorldObjectContextMenu.onSit, item, player);

  -- For fishing with the joypad, look around the player to find some water.
  local fishObject = worldobjects[1]
  if JoypadState.players[player + 1] then
    local px = playerObj:getX()
    local py = playerObj:getY()
    local pz = playerObj:getZ()
    local rod = ISWorldObjectContextMenu.getFishingRode(playerObj)
    local lure = ISWorldObjectContextMenu.getFishingLure(playerObj, rod)
    local net = playerInv:getFirstTypeRecurse("FishingNet")
    if (rod and lure) or net then
      for dy = -5, 5 do
        for dx = -5, 5 do
          local square = getCell():getGridSquare(px + dx, py + dy, pz)
          -- FIXME: is there a wall in between?
          -- TODO: pick a square in the direction the player is facing.
          if square and square:Is(IsoFlagType.water) and square:getObjects():size() > 0 then
            if rod and lure then canFish = true end
            if net then canTrapFish = true end
            fishObject = square:getObjects():get(0)
            break
          end
        end
        if canFish or canTrapFish then break end
      end
    end
    for dy = -5, 5 do
      for dx = -5, 5 do
        local square = getCell():getGridSquare(px + dx, py + dy, pz)
        -- FIXME: is there a wall in between?
        -- TODO: pick a square in the direction the player is facing.
        if square and square:Is(IsoFlagType.water) and square:getObjects():size() > 0 then
          for i = 0, square:getObjects():size() - 1 do
            local v = square:getObjects():get(i)
            if instanceof(v, "IsoObject") and v:getName() == "FishingNet" then
              trapFish = v
              break
            end
          end
          if trapFish then break end
        end
      end
    end
  end

  -- Fishing
  if canFish then
    if test == true then return true; end
    context:addOption(getText("ContextMenu_Fishing"), { fishObject }, ISWorldObjectContextMenu.onFishing, playerObj)
  end
  if canTrapFish then
    if test == true then return true; end
    suboption = context:addOption(getText("ContextMenu_Place_Fishing_Net"), worldobjects, ISWorldObjectContextMenu.onFishingNet, playerObj)
    if storeWater:getSquare():DistToProper(getSpecificPlayer(player):getCurrentSquare()) >= 5 then
      suboption.notAvailable = true;
    end
  end
  if trapFish then
    if test == true then return true; end
    local hourElapsed = math.floor(((getGameTime():getCalender():getTimeInMillis() - trapFish:getSquare():getModData()["fishingNetTS"]) / 60000) / 60);
    if hourElapsed > 0 then
      suboption = context:addOption(getText("ContextMenu_Check_Trap"), worldobjects, ISWorldObjectContextMenu.onCheckFishingNet, playerObj, trapFish, hourElapsed);
      if trapFish:getSquare():DistToProper(playerObj:getSquare()) >= 5 then
        suboption.notAvailable = true;
      end
    end

    suboption = context:addOption(getText("ContextMenu_Remove_Trap"), worldobjects, ISWorldObjectContextMenu.onRemoveFishingNet, playerObj, trapFish);
    if trapFish:getSquare():DistToProper(playerObj:getSquare()) >= 5 then
      suboption.notAvailable = true;
    end
  end

  -- climb a sheet rope
  if sheetRopeSquare and playerObj:canClimbSheetRope(sheetRopeSquare) and playerObj:getPerkLevel(Perks.Strength) >= 0 then
    if test == true then return true; end
    context:addOption(getText("ContextMenu_Climb_Sheet_Rope"), worldobjects, ISWorldObjectContextMenu.onClimbSheetRope, sheetRopeSquare, false, player)
  end

  -- iso thumpable light source interaction
  if thumpableLightSource then
    if (thumpableLightSource:getLightSourceFuel() and thumpableLightSource:haveFuel()) or not thumpableLightSource:getLightSourceFuel() then
      if thumpableLightSource:isLightSourceOn() then
        if test == true then return true; end
        context:addOption(getText("ContextMenu_Turn_Off"), thumpableLightSource, ISWorldObjectContextMenu.onToggleThumpableLight, player);
      elseif thumpableLightSource:getLifeLeft() > 0 then
        if test == true then return true; end
        context:addOption(getText("ContextMenu_Turn_On"), thumpableLightSource, ISWorldObjectContextMenu.onToggleThumpableLight, player);
      end
    end
    if thumpableLightSource:getLightSourceFuel() and playerInv:containsWithModule(thumpableLightSource:getLightSourceFuel(), true) then
      if test == true then return true; end
      local fuelOption = context:addOption(getText("ContextMenu_Insert_Fuel"), worldobjects, nil)
      local subMenuFuel = ISContextMenu:getNew(context)
      context:addSubMenu(fuelOption, subMenuFuel)
      local fuelList = playerInv:FindAll(thumpableLightSource:getLightSourceFuel())
      for n = 0, fuelList:size() - 1 do
        local fuel = fuelList:get(n)
        if instanceof(fuel, 'DrainableComboItem') and fuel:getUsedDelta() > 0 then
          local fuelOption2 = subMenuFuel:addOption(fuel:getName(), thumpableLightSource, ISWorldObjectContextMenu.onInsertFuel, fuel, playerObj)
          local tooltip = ISWorldObjectContextMenu.addToolTip()
          tooltip:setName(fuel:getName())
          tooltip.description = getText("IGUI_RemainingPercent", luautils.round(math.ceil(fuel:getUsedDelta() * 100), 0))
          fuelOption2.toolTip = tooltip
        end
      end
    end
    if thumpableLightSource:getLightSourceFuel() and thumpableLightSource:haveFuel() then
      if test == true then return true; end
      local removeOption = context:addOption(getText("ContextMenu_Remove_Battery"), thumpableLightSource, ISWorldObjectContextMenu.onRemoveFuel, player);
      if playerObj:DistToSquared(thumpableLightSource:getX() + 0.5, thumpableLightSource:getY() + 0.5) < 2 * 2 then
        local item = ScriptManager.instance:getItem(thumpableLightSource:getLightSourceFuel())
        local tooltip = ISWorldObjectContextMenu.addToolTip()
        tooltip:setName(item and item:getDisplayName() or "???")
        tooltip.description = getText("IGUI_RemainingPercent", luautils.round(math.ceil(thumpableLightSource:getLifeLeft() * 100), 0))
        removeOption.toolTip = tooltip
      end
    end
  end

  -- sleep into a bed
  if bed and not ISWorldObjectContextMenu.isSomethingTo(bed, player) then
    if not isClient() or getServerOptions():getBoolean("SleepAllowed") then
      if test == true then return true; end
      ISWorldObjectContextMenu.doSleepOption(context, bed, player, playerObj);
    end
    if playerObj:getStats():getEndurance() < 1 then
      if test == true then return true; end
      context:addOption(getText("ContextMenu_Rest"), bed, ISWorldObjectContextMenu.onRest, player);
    end
  end

  if rainCollectorBarrel and playerObj:DistToSquared(rainCollectorBarrel:getX() + 0.5, rainCollectorBarrel:getY() + 0.5) < 2 * 2 then
    if test == true then return true; end
    local option = context:addOption(getText("ContextMenu_Rain_Collector_Barrel"), worldobjects, nil)
    local tooltip = ISWorldObjectContextMenu.addToolTip()
    tooltip:setName(getText("ContextMenu_Rain_Collector_Barrel"))
    tooltip.description = getText("IGUI_RemainingPercent", round((rainCollectorBarrel:getWaterAmount() / rainCollectorBarrel:getModData()["waterMax"]) * 100))
    if rainCollectorBarrel:isTaintedWater() then
      tooltip.description = tooltip.description .. " <BR> <RGB:1,0.5,0.5> " .. getText("Tooltip_item_TaintedWater")
    end
    tooltip.maxLineWidth = 512
    option.toolTip = tooltip
  end
  -- Tooltip for remaining water inside a water dispenser
  if waterDispenser and playerObj:DistToSquared(waterDispenser:getX() + 0.5, waterDispenser:getY() + 0.5) < 2 * 2 then
    if test == true then return true; end
    local option = context:addOption(getText("ContextMenu_Water_Dispenser"), worldobjects, nil)
    local tooltip = ISWorldObjectContextMenu.addToolTip()
    tooltip:setName(getText("ContextMenu_Water_Dispenser"))
    local waterMax = waterDispenser:getModData()["waterMax"]
    if waterMax == nil then
      tooltip.description = getText("IGUI_RemainingPercent", 100)
    else
      tooltip.description = getText("IGUI_RemainingPercent", round((waterDispenser:getWaterAmount() / waterMax) * 100))
    end
    tooltip.maxLineWidth = 512
    option.toolTip = tooltip
  end
  -- wash clothing/yourself
  if storeWater then
    if not clothingDryer and not clothingWasher then --Stops being able to wash clothes in washing machines and dryers
      ISWorldObjectContextMenu.doWashClothingMenu(storeWater, player, context);
    end
  end

  -- take water
  if storeWater and getCore():getGameMode() ~= "LastStand" then
    if test == true then return true; end
    ISWorldObjectContextMenu.doFillWaterMenu(storeWater, player, context);
  end


  -- This is a separate function because of the limit of 200 local variables per Lua function.
  if ISWorldObjectContextMenu.addWaterFromItem(test, context, worldobjects, playerObj, playerInv) then
    return true
  end

  if storeWater and getCore():getGameMode() ~= "LastStand" then
    if test == true then return true; end
    if not clothingDryer and not clothingWasher then
      context:addOption(getText("ContextMenu_Drink"), worldobjects, ISWorldObjectContextMenu.onDrink, storeWater, player);
    end
  end

  if ISWorldObjectContextMenu.toggleClothingDryer(context, worldobjects, player, clothingDryer) then
    return true
  end

  if ISWorldObjectContextMenu.toggleClothingWasher(context, worldobjects, player, clothingWasher) then
    return true
  end

  -- activate stove
  if stove ~= nil and not ISWorldObjectContextMenu.isSomethingTo(stove, player) and getCore():getGameMode() ~= "LastStand" then
    -- check sandbox for electricity shutoff
    if stove:getContainer() and stove:getContainer():isPowered() then
      if test == true then return true; end
      if stove:Activated() then
        context:addOption(getText("ContextMenu_Turn_Off"), worldobjects, ISWorldObjectContextMenu.onToggleStove, stove, player);
      else
        context:addOption(getText("ContextMenu_Turn_On"), worldobjects, ISWorldObjectContextMenu.onToggleStove, stove, player);
      end
      if stove:getContainer() and stove:getContainer():getType() == "microwave" then
        context:addOption(getText("ContextMenu_StoveSetting"), worldobjects, ISWorldObjectContextMenu.onMicrowaveSetting, stove, player);
      elseif stove:getContainer() and stove:getContainer():getType() == "stove" then
        context:addOption(getText("ContextMenu_StoveSetting"), worldobjects, ISWorldObjectContextMenu.onStoveSetting, stove, player);
      end
    end
  end

  if lightSwitch ~= nil and not ISWorldObjectContextMenu.isSomethingTo(lightSwitch, player) then
    local canSwitch = lightSwitch:canSwitchLight();
    if canSwitch then --(SandboxVars.ElecShutModifier > -1 and GameTime:getInstance():getNightsSurvived() < SandboxVars.ElecShutModifier) or lightSwitch:getSquare():haveElectricity() then
      if test == true then return true; end
      if lightSwitch:isActivated() then
        context:addOption(getText("ContextMenu_Turn_Off"), worldobjects, ISWorldObjectContextMenu.onToggleLight, lightSwitch, player);
      else
        context:addOption(getText("ContextMenu_Turn_On"), worldobjects, ISWorldObjectContextMenu.onToggleLight, lightSwitch, player);
      end
    end

    if lightSwitch:getCanBeModified() then
      if test == true then return true; end

      -- if not modified yet, give option to modify this lamp so it uses battery instead of power
      if not lightSwitch:getUseBattery() then
        if playerObj:getPerkLevel(Perks.Electricity) >= ISLightActions.perkLevel then
          if playerInv:containsTypeEvalRecurse("Screwdriver", predicateNotBroken) and playerInv:containsTypeRecurse("ElectronicsScrap") then
            context:addOption(getText("ContextMenu_CraftBatConnector"), worldobjects, ISWorldObjectContextMenu.onLightModify, lightSwitch, player);
          end
        end
      end

      -- if its modified add the battery options
      if lightSwitch:getUseBattery() then
        if lightSwitch:getHasBattery() then
          local removeOption = context:addOption(getText("ContextMenu_Remove_Battery"), worldobjects, ISWorldObjectContextMenu.onLightBattery, lightSwitch, player, true);
          if playerObj:DistToSquared(lightSwitch:getX() + 0.5, lightSwitch:getY() + 0.5) < 2 * 2 then
            local item = ScriptManager.instance:getItem("Base.Battery")
            local tooltip = ISWorldObjectContextMenu.addToolTip()
            tooltip:setName(item and item:getDisplayName() or "???")
            tooltip.description = getText("IGUI_RemainingPercent", luautils.round(math.ceil(lightSwitch:getPower() * 100), 0))
            removeOption.toolTip = tooltip
          end
        elseif playerInv:containsTypeRecurse("Battery") then
          local batteryOption = context:addOption(getText("ContextMenu_AddBattery"), worldobjects, nil);
          local subMenuBattery = ISContextMenu:getNew(context);
          context:addSubMenu(batteryOption, subMenuBattery);

          local batteries = playerInv:getAllTypeEvalRecurse("Battery", predicateNotEmpty)
          for n = 0, batteries:size() - 1 do
            local battery = batteries:get(n)
            if instanceof(battery, 'DrainableComboItem') and battery:getUsedDelta() > 0 then
              local insertOption = subMenuBattery:addOption(battery:getName(), worldobjects, ISWorldObjectContextMenu.onLightBattery, lightSwitch, player, false, battery);
              local tooltip = ISWorldObjectContextMenu.addToolTip()
              tooltip:setName(battery:getName())
              tooltip.description = getText("IGUI_RemainingPercent", luautils.round(math.ceil(battery:getUsedDelta() * 100), 0))
              insertOption.toolTip = tooltip
            end
          end

        end
      end

      -- lightbulbs can be changed regardless, as long as the lamp can be modified (which are all isolightswitches that are movable, see IsoLightSwitch constructor)
      if lightSwitch:hasLightBulb() then
        context:addOption(getText("ContextMenu_RemoveLightbulb"), worldobjects, ISWorldObjectContextMenu.onLightBulb, lightSwitch, player, true);
      else
        local items = playerInv:getAllEvalRecurse(function(item) return luautils.stringStarts(item:getType(), "LightBulb") end)

        local cache = {};
        local found = false;
        for i = 0, items:size() - 1 do
          local testitem = items:get(i);
          if cache[testitem:getType()] == nil then
            cache[testitem:getType()] = testitem;
            found = true;
          end
        end

        if found then
          local bulbOption = context:addOption(getText("ContextMenu_AddLightbulb"), worldobjects, nil);
          local subMenuBulb = ISContextMenu:getNew(context);
          context:addSubMenu(bulbOption, subMenuBulb);

          for _, bulb in pairs(cache) do
            subMenuBulb:addOption(bulb:getName(), worldobjects, ISWorldObjectContextMenu.onLightBulb, lightSwitch, player, false, bulb);
          end
        end
      end

    end
    if false then
      print("can switch = ", canSwitch);
      print("has bulb = ", lightSwitch:hasLightBulb());
      print("used battery = ", lightSwitch:getUseBattery());
      print("is modable = ", lightSwitch:getCanBeModified());
    end
  end

  if thumpableWindow then
    local addCurtains = thumpableWindow:HasCurtains();
    local movedWindow = thumpableWindow:getSquare():getWindow(thumpableWindow:getNorth())
    -- barricade, addsheet, etc...
    -- you can do action only inside a house
    -- add sheet (curtains) to window (sheet on 1st hand)
    if not addCurtains and not movedWindow and playerInv:containsTypeRecurse("Sheet") then
      if test == true then return true; end
      context:addOption(getText("ContextMenu_Add_sheet"), worldobjects, ISWorldObjectContextMenu.onAddSheet, thumpableWindow, player);
    end
    if not movedWindow and thumpableWindow:canClimbThrough(playerObj) then
      if test == true then return true; end
      local climboption = context:addOption(getText("ContextMenu_Climb_through"), worldobjects, ISWorldObjectContextMenu.onClimbThroughWindow, thumpableWindow, player);
      if not JoypadState.players[player + 1] then
        local tooltip = ISWorldObjectContextMenu.addToolTip()
        tooltip:setName(getText("ContextMenu_Info"))
        tooltip.description = getText("Tooltip_TapKey", getKeyName(getCore():getKey("Interact")));
        climboption.toolTip = tooltip;
      end
    end
  elseif thump and thump:isHoppable() and thump:canClimbOver(playerObj) then
    if test == true then return true; end
    local climboption = context:addOption(getText("ContextMenu_Climb_over"), worldobjects, ISWorldObjectContextMenu.onClimbOverFence, thump, player);
    if not JoypadState.players[player + 1] then
      local tooltip = ISWorldObjectContextMenu.addToolTip()
      tooltip:setName(getText("ContextMenu_Info"))
      tooltip.description = getText("Tooltip_Climb", getKeyName(getCore():getKey("Interact")));
      climboption.toolTip = tooltip;
    end
  end

  local hasHammer = playerInv:containsTypeEvalRecurse("Hammer", predicateNotBroken) or playerInv:containsTypeEvalRecurse("HammerStone", predicateNotBroken)

  -- created thumpable item interaction
  if thump ~= nil and not invincibleWindow then
    if thump:canAddSheetRope() and playerObj:getCurrentSquare():getZ() > 0 and not thump:isBarricaded() and
    playerInv:containsTypeRecurse("Nails") then
      if (playerInv:getItemCountRecurse("SheetRope") >= thump:countAddSheetRope()) then
        if test == true then return true; end
        context:addOption(getText("ContextMenu_Add_escape_rope_sheet"), worldobjects, ISWorldObjectContextMenu.onAddSheetRope, thump, player);
      elseif (playerInv:getItemCountRecurse("Rope") >= thump:countAddSheetRope()) then
        if test == true then return true; end
        context:addOption(getText("ContextMenu_Add_escape_rope"), worldobjects, ISWorldObjectContextMenu.onAddSheetRope, thump, player);
      end
    end
    if thump:haveSheetRope() then
      if test == true then return true; end
      context:addOption(getText("ContextMenu_Remove_escape_rope"), worldobjects, ISWorldObjectContextMenu.onRemoveSheetRope, thump, player);
    end

    if thump:getCanBarricade() then
      local ignoreObject = false;
      for k, v in ipairs(worldobjects) do
        if instanceof(v, "IsoWindow") and thump ~= v then
          ignoreObject = true;
        end
      end
      if not ignoreObject then
        -- unbarricade (hammer on 1st hand and window barricaded)
        -- barricade (hammer on 1st hand, plank on 2nd hand) and need nails
        local barricade = thump:getBarricadeForCharacter(playerObj)
        if not thump:haveSheetRope() and (not barricade or barricade:canAddPlank()) and hasHammer and
        playerInv:containsTypeRecurse("Plank") and playerInv:getItemCountRecurse("Base.Nails") >= 2 then
          if test == true then return true; end
          context:addOption(getText("ContextMenu_Barricade"), worldobjects, ISWorldObjectContextMenu.onBarricade, thump, player);
        end
        if (barricade and barricade:getNumPlanks() > 0) and hasHammer then
          if test == true then return true; end
          context:addOption(getText("ContextMenu_Unbarricade"), worldobjects, ISWorldObjectContextMenu.onUnbarricade, thump, player);
        end
        if not thump:haveSheetRope() and not barricade and ISWorldObjectContextMenu.checkBlowTorchForBarricade(playerObj) and playerInv:containsTypeRecurse("SheetMetal") then
          if test == true then return true; end
          context:addOption(getText("ContextMenu_MetalBarricade"), worldobjects, ISWorldObjectContextMenu.onMetalBarricade, thump, player);
        end
        if not thump:haveSheetRope() and not barricade and ISWorldObjectContextMenu.checkBlowTorchForBarricade(playerObj) and playerInv:getItemCountRecurse("Base.MetalBar") >= 3 then
          if test == true then return true; end
          context:addOption(getText("ContextMenu_MetalBarBarricade"), worldobjects, ISWorldObjectContextMenu.onMetalBarBarricade, thump, player);
        end
        if (barricade and barricade:isMetal()) and ISWorldObjectContextMenu.checkBlowTorchForBarricade(playerObj) then
          if test == true then return true; end
          context:addOption(getText("ContextMenu_Unbarricade"), worldobjects, ISWorldObjectContextMenu.onUnbarricadeMetal, thump, player);
        end
        if (barricade and barricade:isMetalBar()) and ISWorldObjectContextMenu.checkBlowTorchForBarricade(playerObj) then
          if test == true then return true; end
          context:addOption(getText("ContextMenu_Unbarricade"), worldobjects, ISWorldObjectContextMenu.onUnbarricadeMetalBar, thump, player);
        end
      end
    end
  end

  -- window interaction
  if window ~= nil and not invincibleWindow then
    if window:canAddSheetRope() and playerObj:getCurrentSquare():getZ() > 0 and not window:isBarricaded() and
    playerInv:containsTypeRecurse("Nails") then
      if (playerInv:getItemCountRecurse("SheetRope") >= window:countAddSheetRope()) then
        if test == true then return true; end
        context:addOption(getText("ContextMenu_Add_escape_rope_sheet"), worldobjects, ISWorldObjectContextMenu.onAddSheetRope, window, player);
      elseif (playerInv:getItemCountRecurse("Rope") >= window:countAddSheetRope()) then
        if test == true then return true; end
        context:addOption(getText("ContextMenu_Add_escape_rope"), worldobjects, ISWorldObjectContextMenu.onAddSheetRope, window, player);
      end
    end
    if window:haveSheetRope() then
      if test == true then return true; end
      context:addOption(getText("ContextMenu_Remove_escape_rope"), worldobjects, ISWorldObjectContextMenu.onRemoveSheetRope, window, player);
    end

    curtain = window:HasCurtains();
    -- barricade, addsheet, etc...
    -- you can do action only inside a house
    -- add sheet (curtains) to window (sheet on 1st hand)
    if not curtain and playerInv:containsTypeRecurse("Sheet") then
      if test == true then return true; end
      context:addOption(getText("ContextMenu_Add_sheet"), worldobjects, ISWorldObjectContextMenu.onAddSheet, window, player);
    end
    -- barricade (hammer on 1st hand, plank on 2nd hand) and need nails
    local barricade = window:getBarricadeForCharacter(playerObj)
    if not window:haveSheetRope() and (not barricade or barricade:canAddPlank()) and hasHammer and
    playerInv:containsTypeRecurse("Plank") and playerInv:getItemCountRecurse("Base.Nails") >= 2 then
      if test == true then return true; end
      context:addOption(getText("ContextMenu_Barricade"), worldobjects, ISWorldObjectContextMenu.onBarricade, window, player);
    end
    -- unbarricade (hammer on 1st hand and window barricaded)
    if (barricade and barricade:getNumPlanks() > 0) and hasHammer then
      if test == true then return true; end
      context:addOption(getText("ContextMenu_Unbarricade"), worldobjects, ISWorldObjectContextMenu.onUnbarricade, window, player);
    end
    if not window:haveSheetRope() and not barricade and ISWorldObjectContextMenu.checkBlowTorchForBarricade(playerObj) and playerInv:containsTypeRecurse("SheetMetal") then
      if test == true then return true; end
      context:addOption(getText("ContextMenu_MetalBarricade"), worldobjects, ISWorldObjectContextMenu.onMetalBarricade, window, player);
    end
    if not window:haveSheetRope() and not barricade and ISWorldObjectContextMenu.checkBlowTorchForBarricade(playerObj) and playerInv:getItemCountRecurse("Base.MetalBar") >= 3 then
      if test == true then return true; end
      context:addOption(getText("ContextMenu_MetalBarBarricade"), worldobjects, ISWorldObjectContextMenu.onMetalBarBarricade, window, player);
    end
    if (barricade and barricade:isMetal()) and ISWorldObjectContextMenu.checkBlowTorchForBarricade(playerObj) then
      if test == true then return true; end
      context:addOption(getText("ContextMenu_Unbarricade"), worldobjects, ISWorldObjectContextMenu.onUnbarricadeMetal, window, player);
    end
    if (barricade and barricade:isMetalBar()) and ISWorldObjectContextMenu.checkBlowTorchForBarricade(playerObj) then
      if test == true then return true; end
      context:addOption(getText("ContextMenu_Unbarricade"), worldobjects, ISWorldObjectContextMenu.onUnbarricadeMetalBar, window, player);
    end

    -- open window if no barricade on the player's side
    if window:IsOpen() and not window:isSmashed() and not barricade then
      if test == true then return true; end
      local opencloseoption = context:addOption(getText("ContextMenu_Close_window"), worldobjects, ISWorldObjectContextMenu.onOpenCloseWindow, window, player);
      if not JoypadState.players[player + 1] then
        local tooltip = ISWorldObjectContextMenu.addToolTip()
        tooltip:setName(getText("ContextMenu_Info"))
        tooltip.description = getText("Tooltip_OpenClose", getKeyName(getCore():getKey("Interact")));
        opencloseoption.toolTip = tooltip;
      end
    end
    -- close & smash window if no barricade on the player's side
    if not window:IsOpen() and not window:isSmashed() and not barricade then
      if test == true then return true; end
      if not window:getSprite() or not window:getSprite():getProperties():Is("WindowLocked") then
        local opencloseoption = context:addOption(getText("ContextMenu_Open_window"), worldobjects, ISWorldObjectContextMenu.onOpenCloseWindow, window, player);
        if not JoypadState.players[player + 1] then
          local tooltip = ISWorldObjectContextMenu.addToolTip()
          tooltip:setName(getText("ContextMenu_Info"))
          tooltip.description = getText("Tooltip_OpenClose", getKeyName(getCore():getKey("Interact")));
          opencloseoption.toolTip = tooltip;
        end
      end
      context:addOption(getText("ContextMenu_Smash_window"), worldobjects, ISWorldObjectContextMenu.onSmashWindow, window, player);
    end
    if window:canClimbThrough(playerObj) then
      if test == true then return true; end
      local climboption = context:addOption(getText("ContextMenu_Climb_through"), worldobjects, ISWorldObjectContextMenu.onClimbThroughWindow, window, player);
      if not JoypadState.players[player + 1] then
        local tooltip = ISWorldObjectContextMenu.addToolTip()
        tooltip:setName(getText("ContextMenu_Info"))
        if window:isGlassRemoved() then
          tooltip.description = getText("Tooltip_TapKey", getKeyName(getCore():getKey("Interact")));
        else
          tooltip.description = getText("Tooltip_Climb", getKeyName(getCore():getKey("Interact")));
        end
        climboption.toolTip = tooltip;
      end
    end
    -- remove glass if no barricade on player's side
    if window:isSmashed() and not window:isGlassRemoved() and playerObj:getPrimaryHandItem() and not barricade then
      if test == true then return true; end
      context:addOption(getText("ContextMenu_RemoveBrokenGlass"), worldobjects, ISWorldObjectContextMenu.onRemoveBrokenGlass, window, player);
    end
  end

  -- curtain interaction
  if curtain ~= nil and not invincibleWindow then
    local text = getText("ContextMenu_Open_curtains");
    if curtain:IsOpen() then
      text = getText("ContextMenu_Close_curtains");
    end
    --Check if we are in same room as curtain.
    if test == true then return true; end
    --Players unable to open/remove curtains? These lines are probably why.
    if not curtain:getSquare():getProperties():Is(IsoFlagType.exterior) then
      if not playerObj:getCurrentSquare():Is(IsoFlagType.exterior) then
        local option = context:addOption(text, worldobjects, ISWorldObjectContextMenu.onOpenCloseCurtain, curtain, player);
        if not JoypadState.players[player + 1] then
          local tooltip = ISWorldObjectContextMenu.addToolTip()
          tooltip:setName(getText("ContextMenu_Info"))
          tooltip.description = getText("Tooltip_OpenCloseCurtains", getKeyName(getCore():getKey("Interact")));
          option.toolTip = tooltip;
        end
        context:addOption(getText("ContextMenu_Remove_curtains"), worldobjects, ISWorldObjectContextMenu.onRemoveCurtain, curtain, player);

      end
    else
      context:addOption(text, worldobjects, ISWorldObjectContextMenu.onOpenCloseCurtain, curtain, player);
      context:addOption(getText("ContextMenu_Remove_curtains"), worldobjects, ISWorldObjectContextMenu.onRemoveCurtain, curtain, player);
    end
  end

  -- window frame without window
  if windowFrame and not window and not thumpableWindow then
    local numSheetRope = IsoWindowFrame.countAddSheetRope(windowFrame)
    if IsoWindowFrame.canAddSheetRope(windowFrame) and playerObj:getCurrentSquare():getZ() > 0 and
    playerInv:containsTypeRecurse("Nails") then
      if (playerInv:getItemCountRecurse("SheetRope") >= IsoWindowFrame.countAddSheetRope(windowFrame)) then
        if test == true then return true; end
        context:addOption(getText("ContextMenu_Add_escape_rope_sheet"), worldobjects, ISWorldObjectContextMenu.onAddSheetRope, windowFrame, player);
      elseif (playerInv:getItemCountRecurse("Rope") >= IsoWindowFrame.countAddSheetRope(windowFrame)) then
        if test == true then return true; end
        context:addOption(getText("ContextMenu_Add_escape_rope"), worldobjects, ISWorldObjectContextMenu.onAddSheetRope, windowFrame, player);
      end
    end
    if IsoWindowFrame.haveSheetRope(windowFrame) then
      if test == true then return true; end
      context:addOption(getText("ContextMenu_Remove_escape_rope"), worldobjects, ISWorldObjectContextMenu.onRemoveSheetRope, windowFrame, player);
    end
    if test == true then return true end
    if IsoWindowFrame.canClimbThrough(windowFrame, playerObj) then
      local climboption = context:addOption(getText("ContextMenu_Climb_through"), worldobjects, ISWorldObjectContextMenu.onClimbThroughWindow, windowFrame, player)
      if not JoypadState.players[player + 1] then
        local tooltip = ISWorldObjectContextMenu.addToolTip()
        tooltip:setName(getText("ContextMenu_Info"))
        tooltip.description = getText("Tooltip_TapKey", getKeyName(getCore():getKey("Interact")))
        climboption.toolTip = tooltip
      end
    end
  end

  -- broken glass interaction
  --    if brokenGlass and playerObj:getClothingItem_Hands() then
  if brokenGlass then
    --        local itemName = playerObj:getClothingItem_Hands():getName()
    --        if itemName ~= "Fingerless Gloves" then
    context:addOption(getText("ContextMenu_PickupBrokenGlass"), worldObjects, ISWorldObjectContextMenu.onPickupBrokenGlass, brokenGlass, player)
    --        end
  end

  -- door interaction
  if door ~= nil then
    local text = getText("ContextMenu_Open_door");
    if door:IsOpen() then
      text = getText("ContextMenu_Close_door");
    end
    -- a door can be opened/close only if it not barricaded
    if not door:isBarricaded() then
      if test == true then return true; end
      local opendooroption = context:addOption(text, worldobjects, ISWorldObjectContextMenu.onOpenCloseDoor, door, player);
      if not JoypadState.players[player + 1] then
        local tooltip = ISWorldObjectContextMenu.addToolTip()
        tooltip:setName(getText("ContextMenu_Info"))
        tooltip.description = getText("Tooltip_OpenClose", getKeyName(getCore():getKey("Interact")));
        opendooroption.toolTip = tooltip;
      end
    end
    -- Double-doors cannot be barricaded
    local canBarricade = door:getSprite() and
    not door:getSprite():getProperties():Is("DoubleDoor") and
    not door:getSprite():getProperties():Is("GarageDoor")
    local barricade = door:getBarricadeForCharacter(playerObj)
    -- barricade (hammer on 1st hand, plank on 2nd hand)
    if canBarricade and (not barricade or barricade:canAddPlank()) and hasHammer and
    playerInv:containsTypeRecurse("Plank") and playerInv:getItemCountRecurse("Base.Nails") >= 2 then
      if test == true then return true; end
      context:addOption(getText("ContextMenu_Barricade"), worldobjects, ISWorldObjectContextMenu.onBarricade, door, player);
    end
    if (barricade and barricade:getNumPlanks() > 0) and hasHammer then
      if test == true then return true; end
      context:addOption(getText("ContextMenu_Unbarricade"), worldobjects, ISWorldObjectContextMenu.onUnbarricade, door, player);
    end
    if canBarricade and not barricade and ISWorldObjectContextMenu.checkBlowTorchForBarricade(playerObj) and playerInv:containsTypeRecurse("SheetMetal") then
      if test == true then return true; end
      context:addOption(getText("ContextMenu_MetalBarricade"), worldobjects, ISWorldObjectContextMenu.onMetalBarricade, door, player);
    end
    if canBarricade and not barricade and ISWorldObjectContextMenu.checkBlowTorchForBarricade(playerObj) and playerInv:getItemCountRecurse("Base.MetalBar") >= 3 then
      if test == true then return true; end
      context:addOption(getText("ContextMenu_MetalBarBarricade"), worldobjects, ISWorldObjectContextMenu.onMetalBarBarricade, door, player);
    end
    if (barricade and barricade:isMetal()) and ISWorldObjectContextMenu.checkBlowTorchForBarricade(playerObj) then
      if test == true then return true; end
      context:addOption(getText("ContextMenu_Unbarricade"), worldobjects, ISWorldObjectContextMenu.onUnbarricadeMetal, door, player);
    end
    if (barricade and barricade:isMetalBar()) and ISWorldObjectContextMenu.checkBlowTorchForBarricade(playerObj) then
      if test == true then return true; end
      context:addOption(getText("ContextMenu_Unbarricade"), worldobjects, ISWorldObjectContextMenu.onUnbarricadeMetalBar, door, player);
    end
    if instanceof(door, "IsoDoor") and door:HasCurtains() then
      if test == true then return true; end
      local text = getText(door:isCurtainOpen() and "ContextMenu_Close_curtains" or "ContextMenu_Open_curtains")
      context:addOption(text, worldobjects, ISWorldObjectContextMenu.onOpenCloseCurtain, door, player);
      context:addOption(getText("ContextMenu_Remove_curtains"), worldobjects, ISWorldObjectContextMenu.onRemoveCurtain, door, player);
    elseif instanceof(door, "IsoDoor") and door:getProperties() and door:getProperties():Is("doorTrans") and not door:getProperties():Is("GarageDoor") then
      if playerInv:containsTypeRecurse("Sheet") then
        if test == true then return true; end
        context:addOption(getText("ContextMenu_Add_sheet"), worldobjects, ISWorldObjectContextMenu.onAddSheet, door, player);
      end
    end
    if door:isHoppable() and door:canClimbOver(playerObj) then
      local option = context:addOption(getText("ContextMenu_Climb_over"), worldobjects, ISWorldObjectContextMenu.onClimbOverFence, door, player);
      if not JoypadState.players[player + 1] then
        local tooltip = ISWorldObjectContextMenu.addToolTip()
        tooltip:setName(getText("ContextMenu_Info"))
        tooltip.description = getText("Tooltip_Climb", getKeyName(getCore():getKey("Interact")));
        option.toolTip = tooltip;
      end
    end
  end

  -- survivor interaction
  if survivor ~= nil then
    if test == true then return true; end
    -- if the player is teamed up with the survivor
    if(playerObj:getDescriptor():InGroupWith(survivor)) then
      local orderOption = context:addOption(getText("ContextMenu_Orders"), worldobjects, nil);
      -- create our future subMenu
      local subMenu = context:getNew(context);
      -- create the option in our subMenu
      subMenu:addOption(getText("ContextMenu_Follow_me"), items, ISWorldObjectContextMenu.onFollow, survivor);
      subMenu:addOption(getText("ContextMenu_Guard"), items, ISWorldObjectContextMenu.onGuard, survivor);
      subMenu:addOption(getText("ContextMenu_Stay"), items, ISWorldObjectContextMenu.onStay, survivor);
      -- we add the subMenu to our current option (Orders)
      context:addSubMenu(orderOption, context.subOptionNums);
    else
      context:addOption(getText("ContextMenu_Team_up"), worldobjects, ISWorldObjectContextMenu.onTeamUp, survivor);
    end
    -- TODO : TalkTo
    --context:addOption("Talk to", worldobjects, ISWorldObjectContextMenu.onTalkTo, survivor);
  end
  if tree then
    local axe = playerInv:getFirstEvalRecurse(predicateNotBrokenAxe)
    if axe and axe:getCondition() > 0 then
      if test == true then return true; end
      context:addOption(getText("ContextMenu_Chop_Tree"), worldobjects, ISWorldObjectContextMenu.onChopTree, playerObj, tree)
    end
  end
  --    local building = nil;
  --	if (item ~= nil) then
  --		local square = item:getSquare();
  --		if square ~= nil and square:getRoom() ~= nil then
  --~ 			building = item:getRoom():getBuilding();

  --~ 			if building ~= nil then
  --~ 				context:addOption("Choose safehouse", worldobjects, ISWorldObjectContextMenu.onChooseSafehouse, building);
  --~ 			end
  --		end
  --    end


  -- scavenge
  if scavengeZone and clickedSquare:getProperties():Is(IsoFlagType.exterior) then
    if test == true then return true; end
    ISWorldObjectContextMenu.doScavengeOptions(context, player, scavengeZone, clickedSquare);
  end

  -- take fuel
  if haveFuel and ((SandboxVars.AllowExteriorGenerator and haveFuel:getSquare():haveElectricity()) or (SandboxVars.ElecShutModifier > - 1 and GameTime:getInstance():getNightsSurvived() < SandboxVars.ElecShutModifier)) then
    if test == true then return true; end
    context:addOption(getText("ContextMenu_TakeGasFromPump"), worldobjects, ISWorldObjectContextMenu.onTakeFuel, playerObj, haveFuel:getSquare());
  end

  -- clicked on a player, medical check
  if clickedPlayer and clickedPlayer ~= playerObj and not playerObj:HasTrait("Hemophobic") then
    if test == true then return true; end
    context:addOption(getText("ContextMenu_Medical_Check"), worldobjects, ISWorldObjectContextMenu.onMedicalCheck, playerObj, clickedPlayer)
  end

  --    if clickedPlayer and playerObj:canSeePlayerStats() then
  --    context:addOption("Check Stats2", worldobjects, ISWorldObjectContextMenu.onCheckStats, playerObj, playerObj)
  if clickedPlayer and clickedPlayer ~= playerObj and isClient() and canSeePlayerStats() then
    if test == true then return true; end
    context:addOption("Check Stats", worldobjects, ISWorldObjectContextMenu.onCheckStats, playerObj, clickedPlayer)
  end

  if clickedPlayer and clickedPlayer ~= playerObj and not clickedPlayer:isAsleep() and isClient() and getServerOptions():getBoolean("AllowTradeUI") then
    if (not ISTradingUI.instance or not ISTradingUI.instance:isVisible()) then
      local option = context:addOption(getText("ContextMenu_Trade", clickedPlayer:getDisplayName()), worldobjects, ISWorldObjectContextMenu.onTrade, playerObj, clickedPlayer)
      if math.abs(playerObj:getX() - clickedPlayer:getX()) > 2 or math.abs(playerObj:getY() - clickedPlayer:getY()) > 2 then
        local tooltip = ISWorldObjectContextMenu.addToolTip();
        option.notAvailable = true;
        tooltip.description = getText("ContextMenu_GetCloserToTrade", clickedPlayer:getDisplayName());
        option.toolTip = tooltip;
      end
    end
  end

  -- cleaning blood
  if haveBlood then
    if test == true then return true; end
    context:addOption(getText("ContextMenu_CleanBlood"), worldobjects, ISWorldObjectContextMenu.onCleanBlood, haveBlood, player);
  end

  -- cut little trees
  if canBeCut then
    if test == true then return true; end
    context:addOption(getText("ContextMenu_RemoveBush"), worldobjects, ISWorldObjectContextMenu.onRemoveTree, canBeCut, false, player);
  end
  -- remove grass
  if canBeRemoved then
    if test == true then return true; end
    context:addOption(getText("ContextMenu_RemoveGrass"), worldobjects, ISWorldObjectContextMenu.onRemoveGrass, canBeRemoved, player);
  end
  -- remove wall vine
  if wallVine then
    if test == true then return true; end
    context:addOption(getText("ContextMenu_RemoveWallVine"), worldobjects, ISWorldObjectContextMenu.onRemoveTree, wallVine, true, player);
  end

  if carBatteryCharger and ISWorldObjectContextMenu.handleCarBatteryCharger(test, context, worldobjects, playerObj, playerInv) then
    return true
  end

  -- generator interaction
  if generator then
    if test == true then return true; end
    local option = context:addOption(getText("ContextMenu_GeneratorInfo"), worldobjects, ISWorldObjectContextMenu.onInfoGenerator, generator, player);
    if playerObj:DistToSquared(generator:getX() + 0.5, generator:getY() + 0.5) < 2 * 2 then
      local tooltip = ISWorldObjectContextMenu.addToolTip()
      tooltip:setName(getText("IGUI_Generator_TypeGas"))
      tooltip.description = ISGeneratorInfoWindow.getRichText(generator, true)
      option.toolTip = tooltip
    end
    if generator:isConnected() then
      if generator:isActivated() then
        context:addOption(getText("ContextMenu_Turn_Off"), worldobjects, ISWorldObjectContextMenu.onActivateGenerator, false, generator, player);
      else
        local option = context:addOption(getText("ContextMenu_GeneratorUnplug"), worldobjects, ISWorldObjectContextMenu.onPlugGenerator, generator, player, false);
        if generator:getFuel() > 0 then
          option = context:addOption(getText("ContextMenu_Turn_On"), worldobjects, ISWorldObjectContextMenu.onActivateGenerator, true, generator, player);
          local doStats = playerObj:DistToSquared(generator:getX() + 0.5, generator:getY() + 0.5) < 2 * 2
          local description = ISGeneratorInfoWindow.getRichText(generator, doStats)
          if description ~= "" then
            local tooltip = ISWorldObjectContextMenu.addToolTip()
            tooltip:setName(getText("IGUI_Generator_TypeGas"))
            tooltip.description = description
            option.toolTip = tooltip
          end
        end
      end
    else
      local option = context:addOption(getText("ContextMenu_GeneratorPlug"), worldobjects, ISWorldObjectContextMenu.onPlugGenerator, generator, player, true);
      if not playerObj:getKnownRecipes():contains("Generator") then
        local tooltip = ISWorldObjectContextMenu.addToolTip();
        option.notAvailable = true;
        tooltip.description = getText("ContextMenu_GeneratorPlugTT");
        option.toolTip = tooltip;
      end
    end
    if not generator:isActivated() and generator:getFuel() < 100 and playerInv:containsTypeEvalRecurse("PetrolCan", predicateNotEmpty) then
      local petrolCan = playerInv:getFirstTypeEvalRecurse("PetrolCan", predicateNotEmpty);
      context:addOption(getText("ContextMenu_GeneratorAddFuel"), worldobjects, ISWorldObjectContextMenu.onAddFuel, petrolCan, generator, player);
    end
    if not generator:isActivated() and generator:getCondition() < 100 then
      local option = context:addOption(getText("ContextMenu_GeneratorFix"), worldobjects, ISWorldObjectContextMenu.onFixGenerator, generator, player);
      if not playerObj:getKnownRecipes():contains("Generator") then
        local tooltip = ISWorldObjectContextMenu.addToolTip();
        option.notAvailable = true;
        tooltip.description = getText("ContextMenu_GeneratorPlugTT");
        option.toolTip = tooltip;
      end
      if not playerInv:containsTypeRecurse("ElectronicsScrap") then
        local tooltip = ISWorldObjectContextMenu.addToolTip();
        option.notAvailable = true;
        tooltip.description = getText("ContextMenu_GeneratorFixTT");
        option.toolTip = tooltip;
      end
    end
    if not generator:isConnected() then
      context:addOption(getText("ContextMenu_GeneratorTake"), worldobjects, ISWorldObjectContextMenu.onTakeGenerator, generator, player);
    end
  end

  -- safehouse
  if safehouse and safehouse:playerAllowed(playerObj) then
    if test == true then return true; end
    context:addOption(getText("ContextMenu_ViewSafehouse"), worldobjects, ISWorldObjectContextMenu.onViewSafeHouse, safehouse, playerObj);
  end
  if not safehouse and clickedSquare:getBuilding() and clickedSquare:getBuilding():getDef() then
    local reason = SafeHouse.canBeSafehouse(clickedSquare, playerObj);
    if reason then
      if test == true then return true; end
      local option = context:addOption(getText("ContextMenu_SafehouseClaim"), worldobjects, ISWorldObjectContextMenu.onTakeSafeHouse, clickedSquare, player);
      if reason ~= "" then
        local toolTip = ISWorldObjectContextMenu.addToolTip();
        toolTip:setVisible(false);
        toolTip.description = reason;
        option.notAvailable = true;
        option.toolTip = toolTip;
      end
    end
  end
  --    elseif safehouse and safehouse:isOwner(playerObj) then
  --        -- add players to the safehouse, check the other players around the chef
  --        local playersList = {};
  --        for x=playerObj:getX()-7,playerObj:getX()+7 do
  --            for y=playerObj:getY()-7,playerObj:getY()+7 do
  --                local square = getCell():getGridSquare(x,y,playerObj:getZ());
  --                if square then
  --                    for i=0,square:getMovingObjects():size()-1 do
  --                        local moving = square:getMovingObjects():get(i);
  --                        if instanceof(moving, "IsoPlayer") and moving ~= playerObj and not safehouse:getPlayers():contains(moving:getUsername()) then
  --                            table.insert(playersList, moving);
  --                        end
  --                    end
  --                end
  --            end
  --        end
  --
  --        if #playersList > 0 then
  --            local addPlayerOption = context:addOption(getText("ContextMenu_SafehouseAddPlayer"), worldobjects, nil)
  --            local subMenu = ISContextMenu:getNew(context)
  --            context:addSubMenu(addPlayerOption, subMenu)
  --            for i,v in ipairs(playersList) do
  --                subMenu:addOption(v:getUsername(), worldobjects, ISWorldObjectContextMenu.onAddPlayerToSafehouse, safehouse, v);
  --            end
  --        end
  --
  --        if safehouse:getPlayers():size() > 1 then
  --            local removePlayerOption = context:addOption(getText("ContextMenu_SafehouseRemovePlayer"), worldobjects, nil)
  --            local subMenu2 = ISContextMenu:getNew(context)
  --            context:addSubMenu(removePlayerOption, subMenu2)
  --            for i=0,safehouse:getPlayers():size()-1 do
  --                local playerName = safehouse:getPlayers():get(i)
  --                if safehouse:getPlayers():get(i) ~= safehouse:getOwner() then
  --                    subMenu2:addOption(playerName, worldobjects, ISWorldObjectContextMenu.onRemovePlayerFromSafehouse, safehouse, playerName, player);
  --                end
  --            end
  --        end


  --        context:addOption(getText("ContextMenu_SafehouseRelease"), worldobjects, ISWorldObjectContextMenu.onReleaseSafeHouse, safehouse, player);
  --    end

  if firetile and extinguisher then
    if test == true then return true; end
    context:addOption(getText("ContextMenu_ExtinguishFire"), worldobjects, ISWorldObjectContextMenu.onRemoveFire, firetile, extinguisher, playerObj);
  end

  if compost and ISWorldObjectContextMenu.handleCompost(test, context, worldobjects, playerObj, playerInv) then
    return true
  end

  -- walk to
  if JoypadState.players[player + 1] == nil and not playerObj:getVehicle() then
    if test == true then return true; end
    context:addOption(getText("ContextMenu_Walk_to"), worldobjects, ISWorldObjectContextMenu.onWalkTo, item, player);
  end

  if not playerObj:getVehicle() and not playerObj:isSitOnGround() then
    if test == true then return true; end
    context:addOption(getText("ContextMenu_SitGround"), player, ISWorldObjectContextMenu.onSitOnGround);
  end

  -- use the event (as you would 'OnTick' etc) to add items to context menu without mod conflicts.
  triggerEvent("OnFillWorldObjectContextMenu", player, context, worldobjects, test);

  if test then return ISWorldObjectContextMenu.Test end

  if context.numOptions == 1 then
    context:setVisible(false);
  end

  return context;
end

function ISWorldObjectContextMenu.onSleepWalkToComplete(player, bed)
  local playerObj = getSpecificPlayer(player)
  ISTimedActionQueue.clear(playerObj)
  local bedType = "badBed";
  if bed then
    bedType = bed:getProperties():Val("BedType") or "averageBed";
  end
  if isClient() and getServerOptions():getBoolean("SleepAllowed") then
    playerObj:setAsleepTime(0.0)
    playerObj:setAsleep(true)
    UIManager.setFadeBeforeUI(player, true)
    UIManager.FadeOut(player, 1)
    return
  end

  playerObj:setBed(bed);
  playerObj:setBedType(bedType);
  local modal = nil;
  local sleepFor = ZombRand(playerObj:getStats():getFatigue() * 10, playerObj:getStats():getFatigue() * 13) + 1;
  if bedType == "goodBed" then
    sleepFor = sleepFor - 1;
  end
  if bedType == "badBed" then
    sleepFor = sleepFor + 1;
  end
  if playerObj:HasTrait("Insomniac") then
    sleepFor = sleepFor * 0.5;
  end
  if sleepFor > 16 then sleepFor = 16; end
  if sleepFor < 3 then sleepFor = 3; end
  --    print("GONNA SLEEP " .. sleepHours .. " HOURS" .. " AND ITS " .. GameTime.getInstance():getTimeOfDay())
  local sleepHours = sleepFor + GameTime.getInstance():getTimeOfDay()
  if sleepHours >= 24 then
    sleepHours = sleepHours - 24
  end
  playerObj:setForceWakeUpTime(tonumber(sleepHours))
  playerObj:setAsleepTime(0.0)
  playerObj:setAsleep(true)
  getSleepingEvent():setPlayerFallAsleep(playerObj, sleepFor);

  UIManager.setFadeBeforeUI(playerObj:getPlayerNum(), true)
  UIManager.FadeOut(playerObj:getPlayerNum(), 1)

  if IsoPlayer.allPlayersAsleep() then
    UIManager.getSpeedControls|():SetCurrentGameSpeed(3)
    save(true)
  end
end
