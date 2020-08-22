ISWorldObjectContextMenu = {}
ISWorldObjectContextMenu.fetchSquares = {}

ISWorldObjectContextMenu.clearFetch = function()
  c = 0;
  window = nil;
  windowFrame = nil;
  door = nil;
  curtain = nil;
  body = nil;
  item = nil;
  survivor = nil;
  thump = nil;
  thumpableWindow = nil
  stove = nil;
  storeWater = nil;
  bed = nil;
  worldItem = nil;
  canClimbThrough = false;
  item = nil;
  sheetRopeSquare = nil;
  destroy = nil;
  invincibleWindow = false;
  thumpableLightSource = nil;
  rainCollectorBarrel = nil
  lightSwitch = nil
  tree = nil
  canFish = false;
  canTrapFish = false;
  trapFish = nil;
  scavengeZone = nil;
  clickedSquare = nil;
  clickedPlayer = nil;
  canBeCut = nil;
  canBeRemoved = nil;
  wallVine = nil;
  doorKeyId = nil;
  padlockThump = nil;
  padlockedThump = nil;
  digitalPadlockedThump = nil;
  haveBlood = nil;
  generator = nil;
  haveFuel = nil;
  safehouse = nil;
  firetile = nil;
  extinguisher = nil;
  trap = nil;
  ashes = nil;
  compost = nil;
  graves = nil;
  ISWorldObjectContextMenu.fetchSquares = {}
end

ISWorldObjectContextMenu.fetch = function(v, player, doSquare)

  local playerObj = getSpecificPlayer(player)
  local playerInv = playerObj:getInventory()

  if v:getSquare() then
    local worldItems = v:getSquare():getWorldObjects();
    if worldItems and not worldItems:isEmpty() then
      worldItem = worldItems:get(0);
    end
  end
  if v:hasWater() then
    storeWater = v;
  end
  c = c + 1;
  if instanceof(v, "IsoWindow") then
    window = v;
  elseif instanceof(v, "IsoCurtain") then
    curtain = v;
  end
  if instanceof(v, "IsoDoor") or (instanceof(v, "IsoThumpable") and v:isDoor()) then
    door = v;
    if instanceof(v, "IsoDoor") then
      doorKeyId = v:checkKeyId()
      if doorKeyId == -1 then doorKeyId = nil end
    end
    if instanceof(v, "IsoThumpable") then
      if v:getKeyId() ~= -1 then
        doorKeyId = v:getKeyId();
      end
    end
  end
  if instanceof(v, "IsoObject") then
    item = v;
  end
  if instanceof(v, "IsoSurvivor") then
    survivor = v;
  end
  if instanceof(v, "IsoCompost") then
    compost = v;
  end
  if instanceof(v, "IsoThumpable") and not v:isDoor() then
    thump = v;
    if v:canBeLockByPadlock() and not v:isLockedByPadlock() and v:getLockedByCode() == 0 then
      padlockThump = v;
    end
    if v:isLockedByPadlock() then
      padlockedThump = v;
    end
    if v:getLockedByCode() > 0 then
      digitalPadlockedThump = v;
    end
    if v:getLightSource() then
      thumpableLightSource = v;
    end
    if v:isWindow() then
      thumpableWindow = v
    end
    if RainCollectorBarrel.isRainCollectorBarrelObject(v) then
      rainCollectorBarrel = v
    end
  end
  if instanceof(v, "IsoTree") then
    tree = v
  end
  if instanceof(v, "IsoStove") and v:getContainer() then
    -- A burnt-out stove has no container.  FIXME: It would be better to remove the burnt stove object
    stove = v;
  end
  if instanceof(v, "IsoDeadBody") then
    body = v;
  end
  if instanceof(v, "IsoGenerator") then
    generator = v;
  end
  if not body and v:getSquare() and v:getSquare():getDeadBody() then
    body = v:getSquare():getDeadBody();
  end
  if instanceof(v, "IsoObject") and v:getSprite() and v:getSprite():getProperties() and v:getSprite():getProperties():Is(IsoFlagType.bed) then
    bed = v;
  end
  if instanceof(v, "IsoObject") and v:getSprite() and v:getSprite():getProperties() and v:getSprite():getProperties():Is(IsoFlagType.makeWindowInvincible) then
    invincibleWindow = true;
  end
  if IsoWindowFrame.isWindowFrame(v) then
    windowFrame = v
  end
  if instanceof(v, "IsoTrap") then
    trap = v;
  end
  if v:getName() == "EmptyGraves" and v:getModData()["corpses"] < 5 then
    graves = v;
  end
  if instanceof(v, "IsoLightSwitch") and v:getSquare() and (v:getSquare():getRoom() or v:getCanBeModified()) then
    lightSwitch = v
  end
  if v:getSquare() and (v:getSquare():getProperties():Is(IsoFlagType.HoppableW) or v:getSquare():getProperties():Is(IsoFlagType.HoppableN)) then
    canClimbThrough = true;
  end
  local rod = ISWorldObjectContextMenu.getFishingRode(getSpecificPlayer(player))
  if instanceof(v, "IsoObject") and v:getSprite() and v:getSprite():getProperties() and v:getSprite():getProperties():Is(IsoFlagType.water) and rod and ISWorldObjectContextMenu.getFishingLure(getSpecificPlayer(player), rod) and v:getSquare():DistToProper(playerObj:getSquare()) < 10 then
    canFish = true;
  end
  local hasCuttingTool = playerInv:contains("KitchenKnife") or playerInv:contains("HuntingKnife") or playerInv:contains("Axe") or playerInv:contains("AxeStone")
  if v:getSprite() and v:getSprite():getProperties() and v:getSprite():getProperties():Is(IsoFlagType.canBeCut) and hasCuttingTool then
    canBeCut = v:getSquare();
  end
  if v:getSprite() and v:getSprite():getProperties() and v:getSprite():getProperties():Is(IsoFlagType.canBeRemoved) then
    canBeRemoved = v:getSquare();
  end
  local attached = v:getAttachedAnimSprite()
  if hasCuttingTool and attached then
    for n = 1, attached:size() do
      local sprite = attached:get(n - 1)
      --            if sprite and sprite:getParentSprite() and sprite:getParentSprite():getProperties():Is(IsoFlagType.canBeCut) then
      if sprite and sprite:getParentSprite() and sprite:getParentSprite():getName() and luautils.stringStarts(sprite:getParentSprite():getName(), "f_wallvines_") then
        wallVine = v:getSquare()
        break
      end
    end
  end
  if instanceof(v, "IsoObject") and v:getSprite() and v:getSprite():getProperties() and v:getSprite():getProperties():Is(IsoFlagType.water) and getSpecificPlayer(player):getInventory():getItemFromType("FishingNet") then
    canTrapFish = true;
  end
  if instanceof(v, "IsoObject") and v:getName() == "FishingNet" and v:getSquare() and v:getSquare():DistToProper(playerObj:getSquare()) < 5 then
    trapFish = v;
  end
  if v:getSquare() and (v:getSquare():getProperties():Is(IsoFlagType.climbSheetN) or v:getSquare():getProperties():Is(IsoFlagType.climbSheetW) or
  v:getSquare():getProperties():Is(IsoFlagType.climbSheetS) or v:getSquare():getProperties():Is(IsoFlagType.climbSheetE)) then
    sheetRopeSquare = v:getSquare()
  end
  if FireFighting.getSquareToExtinguish(v:getSquare()) then
    extinguisher = FireFighting.getExtinguisher(getSpecificPlayer(player));
    firetile = v:getSquare();
  end
  -- check for scavenging
  if v:getSquare() and v:getSquare():getZ() == 0 then
    local zone = ISWorldObjectContextMenu.getZone(v:getSquare():getX(), v:getSquare():getY(), v:getSquare():getZ());
    if zone and (zone:getType() == "Forest" or zone:getType() == "DeepForest") then
      scavengeZone = zone;
    end
  end
  clickedSquare = v:getSquare();
  if doSquare and getSpecificPlayer(player):getInventory():getItemsFromFullType("farming.Shovel", true):size() > 0 and instanceof(v, "IsoObject") and v:getSprite() then
    if v:getSpriteName() == 'floors_burnt_01_1' or v:getSpriteName() == 'floors_burnt_01_2' then
      if not ashes or (ashes:getTargetAlpha() <= v:getTargetAlpha()) then
        ashes = v
      end
    end
  end
  if doSquare and getSpecificPlayer(player):getInventory():getItemFromType("Sledgehammer") and getSpecificPlayer(player):getInventory():getItemFromType("Sledgehammer"):getCondition() > 0 and instanceof(v, "IsoObject") and v:getSprite() and v:getSprite():getProperties() and
  (v:getSprite():getProperties():Is(IsoFlagType.solidtrans) or v:getSprite():getProperties():Is(IsoFlagType.collideW) or
    v:getSprite():getProperties():Is(IsoFlagType.collideN) or v:getSprite():getProperties():Is(IsoFlagType.bed) or
    instanceof(v, "IsoThumpable") or v:getSprite():getProperties():Is(IsoFlagType.windowN) or v:getSprite():getProperties():Is(IsoFlagType.windowW)
    or v:getType() == IsoObjectType.stairsBN or v:getType() == IsoObjectType.stairsMN or v:getType() == IsoObjectType.stairsTN
    or v:getType() == IsoObjectType.stairsBW or v:getType() == IsoObjectType.stairsMW or v:getType() == IsoObjectType.stairsTW
  or ((v:getProperties():Is("DoorWallN") or v:getProperties():Is("DoorWallW")) and not v:getSquare():haveDoor()) or v:getSprite():getProperties():Is(IsoFlagType.waterPiped)) then
    if not (v:getSprite():getName() and luautils.stringStarts(v:getSprite():getName(), 'blends_natural_02') and luautils.stringStarts(v:getSprite():getName(), 'floors_burnt_01_')) then -- don't destroy water tiles and ashes
      if not destroy or (destroy:getTargetAlpha() <= v:getTargetAlpha()) then
        destroy = v
      end
    end
  end
  if v:getSquare() and v:getSquare():haveBlood() and getSpecificPlayer(player):getInventory():contains("Bleach") and (getSpecificPlayer(player):getInventory():contains("BathTowel") or getSpecificPlayer(player):getInventory():contains("DishCloth") or getSpecificPlayer(player):getInventory():contains("Mop")) then
    haveBlood = v:getSquare();
  end
  if instanceof(v, "IsoPlayer") then
    clickedPlayer = v;
  end
  if v:getSquare():getProperties():Is("fuelAmount") and tonumber(v:getSquare():getProperties():Val("fuelAmount")) > 0 then
    local petrolCan = getSpecificPlayer(player):getInventory():FindAndReturn("EmptyPetrolCan");
    if not petrolCan then
      local cans = getSpecificPlayer(player):getInventory():getItemsFromType("PetrolCan");
      for i = 0, cans:size() - 1 do
        petrolCan = cans:get(i);
        if petrolCan:getUsedDelta() < 1 then
          haveFuel = v;
          break;
        end
      end
    else
      haveFuel = v;
    end

  end
  -- safehouse
  safehouse = SafeHouse.getSafeHouse(v:getSquare());

  item = v;
  if v:getSquare() and doSquare and not ISWorldObjectContextMenu.fetchSquares[v:getSquare()] then
    for i = 0, v:getSquare():getObjects():size() - 1 do
      ISWorldObjectContextMenu.fetch(v:getSquare():getObjects():get(i), player, false);
    end
    for i = 0, v:getSquare():getStaticMovingObjects():size() - 1 do
      ISWorldObjectContextMenu.fetch(v:getSquare():getStaticMovingObjects():get(i), player, false);
    end
    for i = 0, v:getSquare():getMovingObjects():size() - 1 do
      local o = v:getSquare():getMovingObjects():get(i)
      -- Medical check
      if JoypadState.players[player + 1] and instanceof(o, "IsoPlayer") then
        ISWorldObjectContextMenu.fetch(o, player, false)
      end
    end
  end
  ISWorldObjectContextMenu.fetchSquares[v:getSquare()] = true
end

ISWorldObjectContextMenu.isSomethingTo = function(item, player)
  if not item or not item:getSquare() then
    return false
  end
  local playerObj = getSpecificPlayer(player)
  local playerSq = playerObj:getCurrentSquare()
  if not AdjacentFreeTileFinder.isTileOrAdjacent(playerSq, item:getSquare()) then
    playerSq = AdjacentFreeTileFinder.Find(item:getSquare(), playerObj)
  end
  if playerSq and item:getSquare():isSomethingTo(playerSq) then
    return true
  end
  return false
end

-- This is for controller users.  Functions bound to OnFillWorldObjectContextMenu should
-- call this if they have any commands to add to the context menu, but only when the 'test'
-- argument to those functions is true.
function ISWorldObjectContextMenu.setTest()
  ISWorldObjectContextMenu.Test = true
  return true
end

-- MAIN METHOD FOR CREATING RIGHT CLICK CONTEXT MENU FOR WORLD ITEMS
ISWorldObjectContextMenu.createMenu = function(player, worldobjects, x, y, test)

  local playerObj = getSpecificPlayer(player)
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
  if getSpecificPlayer(player):getInventory():contains("Shovel") then
    if test == true then return true; end
    context:addOption(getText("ContextMenu_DigGraves"), worldobjects, ISWorldObjectContextMenu.onDigGraves, player);
  end
  if graves and getSpecificPlayer(player):getInventory():contains("Shovel") and (getSpecificPlayer(player):getInventory():contains("CorpseMale") or getSpecificPlayer(player):getInventory():contains("CorpseFemale")) then
    if test == true then return true; end
    context:addOption(getText("ContextMenu_BuryCorpse", graves:getModData()["corpses"]), graves, ISWorldObjectContextMenu.onBuryCorpse, player);
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
    if getSpecificPlayer(player):getInventory():getItemCount("Base.CorpseMale") == 0 then
      if test == true then return true; end
      context:addOption(getText("ContextMenu_Grab_Corpse"), worldobjects, ISWorldObjectContextMenu.onGrabCorpseItem, body, player);
    end
    if getSpecificPlayer(player):getInventory():contains("PetrolCan") and (getSpecificPlayer(player):getInventory():contains("Lighter") or getSpecificPlayer(player):getInventory():contains("Matches")) then
      if test == true then return true; end
      context:addOption(getText("ContextMenu_Burn_Corpse"), worldobjects, ISWorldObjectContextMenu.onBurnCorpse, player, body);
    end
  end


  if door and not door:IsOpen() and doorKeyId and getSpecificPlayer(player):getInventory():haveThisKeyId(doorKeyId) then
    if test == true then return true; end
    if not door:isLockedByKey() then
      context:addOption(getText("ContextMenu_LockDoor"), worldobjects, ISWorldObjectContextMenu.onLockDoor, player, door);
    else
      context:addOption(getText("ContextMenu_UnlockDoor"), worldobjects, ISWorldObjectContextMenu.onUnLockDoor, player, door, doorKeyId);
    end
  end

  -- if the player have a padlock with a key on it
  if padlockThump then
    local padlock = getSpecificPlayer(player):getInventory():FindAndReturn("Padlock");
    if padlock and padlock:getNumberOfKey() > 0 then
      if test == true then return true; end
      context:addOption(getText("ContextMenu_PutPadlock"), worldobjects, ISWorldObjectContextMenu.onPutPadlock, player, padlockThump, padlock);
    end
    local digitalPadlock = getSpecificPlayer(player):getInventory():FindAndReturn("CombinationPadlock");
    if digitalPadlock then
      if test == true then return true; end
      context:addOption(getText("ContextMenu_PutCombinationPadlock"), worldobjects, ISWorldObjectContextMenu.onPutDigitalPadlock, player, padlockThump, digitalPadlock);
    end
  end

  if padlockedThump and getSpecificPlayer(player):getInventory():haveThisKeyId(padlockedThump:getKeyId()) then
    if test == true then return true; end
    context:addOption(getText("ContextMenu_RemovePadlock"), worldobjects, ISWorldObjectContextMenu.onRemovePadlock, player, padlockedThump);
  end

  if digitalPadlockedThump then
    if test == true then return true; end
    context:addOption(getText("ContextMenu_RemoveCombinationPadlock"), worldobjects, ISWorldObjectContextMenu.onRemoveDigitalPadlock, player, digitalPadlockedThump);
  end

  -- get back the key on the lock
  --    if door and doorKeyId and door:haveKey() and not getSpecificPlayer(player):getSquare():Is(IsoFlagType.exterior) then
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
    local net = playerObj:getInventory():getItemFromType("FishingNet")
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
    context:addOption(getText("ContextMenu_Fishing"), { fishObject }, ISWorldObjectContextMenu.onFishing, getSpecificPlayer(player))
  end
  if canTrapFish then
    if test == true then return true; end
    context:addOption(getText("ContextMenu_Place_Fishing_Net"), worldobjects, ISWorldObjectContextMenu.onFishingNet, getSpecificPlayer(player))
  end
  if trapFish then
    if test == true then return true; end
    local hourElapsed = math.floor(((getGameTime():getCalender():getTimeInMillis() - trapFish:getSquare():getModData()["fishingNetTS"]) / 60000) / 60);
    if hourElapsed > 0 then
      context:addOption(getText("ContextMenu_Check_Trap"), worldobjects, ISWorldObjectContextMenu.onCheckFishingNet, getSpecificPlayer(player), trapFish, hourElapsed);
    end

    context:addOption(getText("ContextMenu_Remove_Trap"), worldobjects, ISWorldObjectContextMenu.onRemoveFishingNet, getSpecificPlayer(player), trapFish);
  end

  -- climb a sheet rope
  if sheetRopeSquare and getSpecificPlayer(player):canClimbSheetRope(sheetRopeSquare) and getSpecificPlayer(player):getPerkLevel(Perks.Strength) >= 0 then
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
    if thumpableLightSource:getLightSourceFuel() and getSpecificPlayer(player):getInventory():containsWithModule(thumpableLightSource:getLightSourceFuel(), true) then
      if test == true then return true; end
      local fuelOption = context:addOption(getText("ContextMenu_Insert_Fuel"), worldobjects, nil)
      local subMenuFuel = ISContextMenu:getNew(context)
      context:addSubMenu(fuelOption, subMenuFuel)
      local player = getSpecificPlayer(player)
      local fuelList = player:getInventory():FindAll(thumpableLightSource:getLightSourceFuel())
      for n = 0, fuelList:size() - 1 do
        local fuel = fuelList:get(n)
        if instanceof(fuel, 'DrainableComboItem') and fuel:getUsedDelta() > 0 then
          local fuelOption2 = subMenuFuel:addOption(fuel:getName(), thumpableLightSource, ISWorldObjectContextMenu.onInsertFuel, fuel, player)
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
    if getSpecificPlayer(player):getStats():getEndurance() < 1 then
      if test == true then return true; end
      context:addOption(getText("ContextMenu_Rest"), bed, ISWorldObjectContextMenu.onRest, player);
    end
  end

  if rainCollectorBarrel and playerObj:DistToSquared(rainCollectorBarrel:getX() + 0.5, rainCollectorBarrel:getY() + 0.5) < 2 * 2 then
    local option = context:addOption(getText("ContextMenu_Rain_Collector_Barrel"), worldobjects, nil)
    local tooltip = ISWorldObjectContextMenu.addToolTip()
    tooltip:setName(getText("ContextMenu_Rain_Collector_Barrel"))
    tooltip.description = getText("IGUI_RemainingPercent", round((rainCollectorBarrel:getWaterAmount() / rainCollectorBarrel:getModData()["waterMax"]) * 100))
    option.toolTip = tooltip
  end

  -- take water
  if storeWater and not ISWorldObjectContextMenu.isSomethingTo(storeWater, player) and getCore():getGameMode() ~= "LastStand" then
    if test == true then return true; end
    local pourInto = {}
    for i = 0, getSpecificPlayer(player):getInventory():getItems():size() - 1 do
      local item = getSpecificPlayer(player):getInventory():getItems():get(i);

      -- our item can store water, but doesn't have water right now
      if item:canStoreWater() and not item:isWaterSource() then
        table.insert(pourInto, item)
      end

      -- or our item can store water and is not full
      if item:canStoreWater() and item:isWaterSource() and instanceof(item, "DrainableComboItem") and item:getUsedDelta() < 1 then
        table.insert(pourInto, item)
      end
    end
    if #pourInto > 0 then
      local subMenuOption = context:addOption(getText("ContextMenu_Fill"), worldobjects, nil);
      local subMenu = context:getNew(context)
      context:addSubMenu(subMenuOption, subMenu)
      for _, item in ipairs(pourInto) do
        subMenu:addOption(item:getName(), worldobjects, ISWorldObjectContextMenu.onTakeWater, storeWater, item, player);
      end
    end

    context:addOption(getText("ContextMenu_Drink"), worldobjects, ISWorldObjectContextMenu.onDrink, storeWater, player);
  end
  -- activate stove
  if stove ~= nil and not ISWorldObjectContextMenu.isSomethingTo(stove, player) and getCore():getGameMode() ~= "LastStand" then
    -- check sandbox for electricity shutoff
    if (SandboxVars.ElecShutModifier > - 1 and GameTime:getInstance():getNightsSurvived() < SandboxVars.ElecShutModifier) or stove:getSquare():haveElectricity() then
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
    --[[
        local isPreElecShut = GameTime:getInstance():getNightsSurvived() < SandboxVars.ElecShutModifier;
        local electricityAround = false;
        local square = lightSwitch:getSquare();
        if square then
            electricityAround = isPreElecShut and square:getRoom()~=nil or square:haveElectricity();
            if not electricityAround and getCell() then
                for x = -1, 1 do
                    for y = -1, 1 do
                        if not (x==0 and y==0) then
                            local gs = getCell():getGridSquare(square:getX()+x, square:getY()+y,square:getZ());
                            if gs and ((isPreElecShut and gs:getRoom()~=nil) or gs:haveElectricity()) then
                                electricityAround = true;
                                break;
                            end
                        end
                    end
                    if electricityAround then
                        break;
                    end
                end
            end
        end

        local canSwitch = lightSwitch:getSquare():getRoom() and ((SandboxVars.ElecShutModifier > -1 and GameTime:getInstance():getNightsSurvived() < SandboxVars.ElecShutModifier) or lightSwitch:getSquare():haveElectricity()) or false;
        if lightSwitch:getCanBeModified() and lightSwitch:getUseBattery() then
            canSwitch = false;
            if lightSwitch:getHasBattery() and lightSwitch:hasLightBulb() and lightSwitch:getPower()>0 then
                canSwitch = true;
            end
        end

        if lightSwitch:hasLightBulb()==false then canSwitch = false; end
        --]]
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
        if getSpecificPlayer(player):getPerkLevel(Perks.Electricity) >= ISLightActions.perkLevel then
          if getSpecificPlayer(player):getInventory():contains("Screwdriver") and getSpecificPlayer(player):getInventory():contains("ElectronicsScrap") then
            context:addOption(getText("ContextMenu_CraftBatConnector"), worldobjects, ISWorldObjectContextMenu.onLightModify, lightSwitch, player, getSpecificPlayer(player):getInventory():FindAndReturn("ElectronicsScrap"));
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
        elseif getSpecificPlayer(player):getInventory():contains("Battery") then
          local batteryOption = context:addOption(getText("ContextMenu_AddBattery"), worldobjects, nil);
          local subMenuBattery = ISContextMenu:getNew(context);
          context:addSubMenu(batteryOption, subMenuBattery);

          local batteries = getSpecificPlayer(player):getInventory():FindAll("Battery")
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
        local items = getSpecificPlayer(player):getInventory():getItems();

        local cache = {};
        local found = false;
        for i = 0, items:size() - 1 do
          local testitem = items:get(i);
          if cache[testitem:getType()] == nil and luautils.stringStarts(testitem:getType(), "LightBulb") then
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
    if not addCurtains and not movedWindow and getSpecificPlayer(player):getInventory():contains("Sheet") then
      if test == true then return true; end
      context:addOption(getText("ContextMenu_Add_sheet"), worldobjects, ISWorldObjectContextMenu.onAddSheet, thumpableWindow, player);
    end
    if not movedWindow and not thumpableWindow:isBarricaded() then
      if test == true then return true; end
      local climboption = context:addOption(getText("ContextMenu_Climb_through"), worldobjects, ISWorldObjectContextMenu.onClimbThroughWindow, thumpableWindow, player);
      if not JoypadState[player + 1] then
        local tooltip = ISWorldObjectContextMenu.addToolTip()
        tooltip:setName(getText("ContextMenu_Info"))
        tooltip.description = getText("Tooltip_Climb", Keyboard.getKeyName(getCore():getKey("Interact")));
        climboption.toolTip = tooltip;
      end
    end
  elseif thump and thump:isHoppable() then
    if test == true then return true; end
    local climboption = context:addOption(getText("ContextMenu_Climb_over"), worldobjects, ISWorldObjectContextMenu.onClimbThroughWindow, thump, player);
    if not JoypadState[player + 1] then
      local tooltip = ISWorldObjectContextMenu.addToolTip()
      tooltip:setName(getText("ContextMenu_Info"))
      tooltip.description = getText("Tooltip_Climb", Keyboard.getKeyName(getCore():getKey("Interact")));
      climboption.toolTip = tooltip;
    end
  end

  -- created thumpable item interaction
  if thump ~= nil and not invincibleWindow then
    if thump:canAddSheetRope() and getSpecificPlayer(player):getCurrentSquare():getZ() > 0 and not thump:isBarricaded() and (getSpecificPlayer(player):getInventory():getNumberOfItem("SheetRope") >= thump:countAddSheetRope() or getSpecificPlayer(player):getInventory():getNumberOfItem("Rope") >= thump:countAddSheetRope())and getSpecificPlayer(player):getInventory():contains("Nails") then
      if test == true then return true; end
      context:addOption(getText("ContextMenu_Add_sheet_rope"), worldobjects, ISWorldObjectContextMenu.onAddSheetRope, thump, player);
    end
    if thump:haveSheetRope() then
      if test == true then return true; end
      context:addOption(getText("ContextMenu_Remove_sheet_rope"), worldobjects, ISWorldObjectContextMenu.onRemoveSheetRope, thump, player);
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
        if (not barricade or barricade:canAddPlank()) and (playerObj:getInventory():contains("Hammer", true) or playerObj:getInventory():contains("HammerStone", true)) and
        playerObj:getInventory():contains("Plank", true) and playerObj:getInventory():contains("Nails", true) then
          if test == true then return true; end
          context:addOption(getText("ContextMenu_Barricade"), worldobjects, ISWorldObjectContextMenu.onBarricade, thump, player);
        end
        if (barricade and barricade:getNumPlanks() > 0) and (playerObj:getInventory():contains("Hammer", true) or playerObj:getInventory():contains("HammerStone", true)) then
          if test == true then return true; end
          context:addOption(getText("ContextMenu_Unbarricade"), worldobjects, ISWorldObjectContextMenu.onUnbarricade, thump, player);
        end
        if not barricade and ISWorldObjectContextMenu.checkBlowTorchForBarricade(playerObj) and playerObj:getInventory():contains("SheetMetal", true) then
          if test == true then return true; end
          context:addOption(getText("ContextMenu_MetalBarricade"), worldobjects, ISWorldObjectContextMenu.onMetalBarricade, thump, player);
        end
        if not barricade and ISWorldObjectContextMenu.checkBlowTorchForBarricade(playerObj) and playerObj:getInventory():getItemCount("Base.MetalBar", true) >= 3 then
          if test == true then return true; end
          context:addOption(getText("ContextMenu_MetalBarBarricade"), worldobjects, ISWorldObjectContextMenu.onMetalBarBarricade, thump, player);
        end
        if (barricade and barricade:isMetal()) and ISWorldObjectContextMenu.checkBlowTorchForBarricade(playerObj) then
          if test == true then return true; end
          context:addOption(getText("ContextMenu_Unbarricade"), worldobjects, ISWorldObjectContextMenu.onUnbarricadeMetal, thump, player);
        end
      end
    end
  end

  -- window interaction
  if window ~= nil and not invincibleWindow then
    if window:canAddSheetRope() and playerObj:getCurrentSquare():getZ() > 0 and not window:isBarricaded() and (playerObj:getInventory():getNumberOfItem("SheetRope") >= window:countAddSheetRope() or playerObj:getInventory():getNumberOfItem("Rope") >= window:countAddSheetRope()) and playerObj:getInventory():contains("Nails") then
      if test == true then return true; end
      context:addOption(getText("ContextMenu_Add_sheet_rope"), worldobjects, ISWorldObjectContextMenu.onAddSheetRope, window, player);
    end
    if window:haveSheetRope() then
      if test == true then return true; end
      context:addOption(getText("ContextMenu_Remove_sheet_rope"), worldobjects, ISWorldObjectContextMenu.onRemoveSheetRope, window, player);
    end

    curtain = window:HasCurtains();
    -- barricade, addsheet, etc...
    -- you can do action only inside a house
    -- add sheet (curtains) to window (sheet on 1st hand)
    if not curtain and getSpecificPlayer(player):getInventory():contains("Sheet") then
      if test == true then return true; end
      context:addOption(getText("ContextMenu_Add_sheet"), worldobjects, ISWorldObjectContextMenu.onAddSheet, window, player);
    end
    -- barricade (hammer on 1st hand, plank on 2nd hand) and need nails
    local barricade = window:getBarricadeForCharacter(playerObj)
    if (not barricade or barricade:canAddPlank()) and (playerObj:getInventory():contains("Hammer", true) or playerObj:getInventory():contains("HammerStone", true)) and
    playerObj:getInventory():contains("Plank", true) and playerObj:getInventory():contains("Nails", true) then
      if test == true then return true; end
      context:addOption(getText("ContextMenu_Barricade"), worldobjects, ISWorldObjectContextMenu.onBarricade, window, player);
    end
    -- unbarricade (hammer on 1st hand and window barricaded)
    if (barricade and barricade:getNumPlanks() > 0) and (playerObj:getInventory():contains("Hammer", true) or playerObj:getInventory():contains("HammerStone", true)) then
      if test == true then return true; end
      context:addOption(getText("ContextMenu_Unbarricade"), worldobjects, ISWorldObjectContextMenu.onUnbarricade, window, player);
    end
    if not barricade and ISWorldObjectContextMenu.checkBlowTorchForBarricade(playerObj) and playerObj:getInventory():contains("SheetMetal", true) then
      if test == true then return true; end
      context:addOption(getText("ContextMenu_MetalBarricade"), worldobjects, ISWorldObjectContextMenu.onMetalBarricade, window, player);
    end
    if not barricade and ISWorldObjectContextMenu.checkBlowTorchForBarricade(playerObj) and playerObj:getInventory():getItemCount("Base.MetalBar", true) >= 3 then
      if test == true then return true; end
      context:addOption(getText("ContextMenu_MetalBarBarricade"), worldobjects, ISWorldObjectContextMenu.onMetalBarBarricade, window, player);
    end
    if (barricade and barricade:isMetal()) and ISWorldObjectContextMenu.checkBlowTorchForBarricade(playerObj) then
      if test == true then return true; end
      context:addOption(getText("ContextMenu_Unbarricade"), worldobjects, ISWorldObjectContextMenu.onUnbarricadeMetal, window, player);
    end

    -- open window if no barricade on the player's side
    if window:IsOpen() and not window:isSmashed() and not barricade then
      if test == true then return true; end
      local opencloseoption = context:addOption(getText("ContextMenu_Close_window"), worldobjects, ISWorldObjectContextMenu.onOpenCloseWindow, window, player);
      if not JoypadState[player + 1] then
        local tooltip = ISWorldObjectContextMenu.addToolTip()
        tooltip:setName(getText("ContextMenu_Info"))
        tooltip.description = getText("Tooltip_OpenClose", Keyboard.getKeyName(getCore():getKey("Interact")));
        opencloseoption.toolTip = tooltip;
      end
    end
    -- close & smash window if no barricade on the player's side
    if not window:IsOpen() and not window:isSmashed() and not barricade then
      if test == true then return true; end
      if not window:getSprite() or not window:getSprite():getProperties():Is("WindowLocked") then
        local opencloseoption = context:addOption(getText("ContextMenu_Open_window"), worldobjects, ISWorldObjectContextMenu.onOpenCloseWindow, window, player);
        if not JoypadState[player + 1] then
          local tooltip = ISWorldObjectContextMenu.addToolTip()
          tooltip:setName(getText("ContextMenu_Info"))
          tooltip.description = getText("Tooltip_OpenClose", Keyboard.getKeyName(getCore():getKey("Interact")));
          opencloseoption.toolTip = tooltip;
        end
      end
      context:addOption(getText("ContextMenu_Smash_window"), worldobjects, ISWorldObjectContextMenu.onSmashWindow, window, player);
    end
    if window:canClimbThrough(playerObj) then
      if test == true then return true; end
      local climboption = context:addOption(getText("ContextMenu_Climb_through"), worldobjects, ISWorldObjectContextMenu.onClimbThroughWindow, window, player);
      if not JoypadState[player + 1] then
        local tooltip = ISWorldObjectContextMenu.addToolTip()
        tooltip:setName(getText("ContextMenu_Info"))
        tooltip.description = getText("Tooltip_Climb", Keyboard.getKeyName(getCore():getKey("Interact")));
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
    if test == true then return true; end
    context:addOption(text, worldobjects, ISWorldObjectContextMenu.onOpenCloseCurtain, curtain, player);

    context:addOption(getText("ContextMenu_Remove_curtains"), worldobjects, ISWorldObjectContextMenu.onRemoveCurtain, curtain, player);
  end

  -- window frame without window
  if windowFrame and not window and not thumpableWindow then
    local numSheetRope = IsoWindowFrame.countAddSheetRope(windowFrame)
    if IsoWindowFrame.canAddSheetRope(windowFrame) and playerObj:getCurrentSquare():getZ() > 0 and
    (playerObj:getInventory():getNumberOfItem("SheetRope") >= numSheetRope or playerObj:getInventory():getNumberOfItem("Rope") >= numSheetRope) and
    playerObj:getInventory():contains("Nails") then
      if test == true then return true; end
      context:addOption(getText("ContextMenu_Add_sheet_rope"), worldobjects, ISWorldObjectContextMenu.onAddSheetRope, windowFrame, player);
    end
    if IsoWindowFrame.haveSheetRope(windowFrame) then
      if test == true then return true; end
      context:addOption(getText("ContextMenu_Remove_sheet_rope"), worldobjects, ISWorldObjectContextMenu.onRemoveSheetRope, windowFrame, player);
    end
    if test == true then return true end
    local climboption = context:addOption(getText("ContextMenu_Climb_through"), worldobjects, ISWorldObjectContextMenu.onClimbThroughWindow, windowFrame, player)
    if not JoypadState[player + 1] then
      local tooltip = ISWorldObjectContextMenu.addToolTip()
      tooltip:setName(getText("ContextMenu_Info"))
      tooltip.description = getText("Tooltip_Climb", Keyboard.getKeyName(getCore():getKey("Interact")))
      climboption.toolTip = tooltip
    end
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
      if not JoypadState[player + 1] then
        local tooltip = ISWorldObjectContextMenu.addToolTip()
        tooltip:setName(getText("ContextMenu_Info"))
        tooltip.description = getText("Tooltip_OpenClose", Keyboard.getKeyName(getCore():getKey("Interact")));
        opendooroption.toolTip = tooltip;
      end
    end
    local barricade = door:getBarricadeForCharacter(playerObj)
    -- barricade (hammer on 1st hand, plank on 2nd hand)
    if (not barricade or barricade:canAddPlank()) and (playerObj:getInventory():contains("Hammer", true) or playerObj:getInventory():contains("HammerStone", true)) and
    playerObj:getInventory():contains("Plank", true) and playerObj:getInventory():contains("Nails", true) then
      if test == true then return true; end
      context:addOption(getText("ContextMenu_Barricade"), worldobjects, ISWorldObjectContextMenu.onBarricade, door, player);
    end
    if (barricade and barricade:getNumPlanks() > 0) and (playerObj:getInventory():contains("Hammer", true) or playerObj:getInventory():contains("HammerStone", true)) then
      if test == true then return true; end
      context:addOption(getText("ContextMenu_Unbarricade"), worldobjects, ISWorldObjectContextMenu.onUnbarricade, door, player);
    end
    if not barricade and ISWorldObjectContextMenu.checkBlowTorchForBarricade(playerObj) and playerObj:getInventory():contains("SheetMetal", true) then
      if test == true then return true; end
      context:addOption(getText("ContextMenu_MetalBarricade"), worldobjects, ISWorldObjectContextMenu.onMetalBarricade, door, player);
    end
    if not barricade and ISWorldObjectContextMenu.checkBlowTorchForBarricade(playerObj) and playerObj:getInventory():getItemCount("Base.MetalBar", true) >= 3 then
      if test == true then return true; end
      context:addOption(getText("ContextMenu_MetalBarBarricade"), worldobjects, ISWorldObjectContextMenu.onMetalBarBarricade, door, player);
    end
    if (barricade and barricade:isMetal()) and ISWorldObjectContextMenu.checkBlowTorchForBarricade(playerObj) then
      if test == true then return true; end
      context:addOption(getText("ContextMenu_Unbarricade"), worldobjects, ISWorldObjectContextMenu.onUnbarricadeMetal, door, player);
    end
    if instanceof(door, "IsoDoor") and door:HasCurtains() then
      if test == true then return true; end
      local text = getText(door:isCurtainOpen() and "ContextMenu_Close_curtains" or "ContextMenu_Open_curtains")
      context:addOption(text, worldobjects, ISWorldObjectContextMenu.onOpenCloseCurtain, door, player);
      context:addOption(getText("ContextMenu_Remove_curtains"), worldobjects, ISWorldObjectContextMenu.onRemoveCurtain, door, player);
    elseif instanceof(door, "IsoDoor") and door:getProperties() and door:getProperties():Is("doorTrans") then
      if playerObj:getInventory():contains("Sheet") then
        if test == true then return true; end
        context:addOption(getText("ContextMenu_Add_sheet"), worldobjects, ISWorldObjectContextMenu.onAddSheet, door, player);
      end
    end
  end

  -- survivor interaction
  if survivor ~= nil then
    if test == true then return true; end
    -- if the player is teamed up with the survivor
    if(getSpecificPlayer(player):getDescriptor():InGroupWith(survivor)) then
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
    local axe = (getSpecificPlayer(player):getInventory():getBestCondition("Axe") or getSpecificPlayer(player):getInventory():getBestCondition("AxeStone"))
    if axe and axe:getCondition() > 0 then
      if test == true then return true; end
      context:addOption(getText("ContextMenu_Chop_Tree"), worldobjects, ISWorldObjectContextMenu.onChopTree, getSpecificPlayer(player), tree)
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
  if haveFuel and (SandboxVars.ElecShutModifier > - 1 and GameTime:getInstance():getNightsSurvived() < SandboxVars.ElecShutModifier) then
    if test == true then return true; end
    context:addOption(getText("ContextMenu_TakeGasFromPump"), worldobjects, ISWorldObjectContextMenu.onTakeFuel, getSpecificPlayer(player), haveFuel:getSquare());
  end

  -- clicked on a player, medical check
  if clickedPlayer and clickedPlayer ~= getSpecificPlayer(player) and not getSpecificPlayer(player):HasTrait("Hemophobic") then
    if test == true then return true; end
    context:addOption(getText("ContextMenu_Medical_Check"), worldobjects, ISWorldObjectContextMenu.onMedicalCheck, getSpecificPlayer(player), clickedPlayer)
    if clickedPlayer:isAsleep() then
      local name = clickedPlayer:getDescriptor():getForename()
      if isClient() then name = clickedPlayer:getUsername() end
      context:addOption(getText("ContextMenu_Wake_Other", name), worldobjects, ISWorldObjectContextMenu.onWakeOther, playerObj, clickedPlayer)
    end
  end

  --    if clickedPlayer and getSpecificPlayer(player):canSeePlayerStats() then
  --    context:addOption("Check Stats2", worldobjects, ISWorldObjectContextMenu.onCheckStats, playerObj, playerObj)
  if clickedPlayer and isClient() and canSeePlayerStats() then
    context:addOption("Check Stats", worldobjects, ISWorldObjectContextMenu.onCheckStats, playerObj, clickedPlayer)
  end

  if clickedPlayer and not clickedPlayer:isAsleep() and isClient() and getServerOptions():getBoolean("AllowTradeUI") then
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

  -- generator interaction
  if generator then
    if test == true then return true; end
    local option = context:addOption(getText("ContextMenu_GeneratorInfo"), worldobjects, ISWorldObjectContextMenu.onInfoGenerator, generator, player);
    if playerObj:DistToSquared(generator:getX() + 0.5, generator:getY() + 0.5) < 2 * 2 then
      local tooltip = ISWorldObjectContextMenu.addToolTip()
      tooltip:setName(getText("IGUI_Generator_TypeGas"))
      tooltip.description = getText("IGUI_Generator_FuelAmount", generator:getFuel()) .. " <LINE> " .. getText("IGUI_Generator_Condition", generator:getCondition())
      option.toolTip = tooltip
    end
    if generator:isConnected() then
      if generator:isActivated() then
        context:addOption(getText("ContextMenu_Turn_Off"), worldobjects, ISWorldObjectContextMenu.onActivateGenerator, false, generator, player);
      else
        local option = context:addOption(getText("ContextMenu_GeneratorUnplug"), worldobjects, ISWorldObjectContextMenu.onPlugGenerator, generator, player, false);
        if generator:getFuel() > 0 then
          context:addOption(getText("ContextMenu_Turn_On"), worldobjects, ISWorldObjectContextMenu.onActivateGenerator, true, generator, player);
        end
      end
    else
      local option = context:addOption(getText("ContextMenu_GeneratorPlug"), worldobjects, ISWorldObjectContextMenu.onPlugGenerator, generator, player, true);
      if not getSpecificPlayer(player):getKnownRecipes():contains("Generator") then
        local tooltip = ISWorldObjectContextMenu.addToolTip();
        option.notAvailable = true;
        tooltip.description = getText("ContextMenu_GeneratorPlugTT");
        option.toolTip = tooltip;
      end
    end
    if not generator:isActivated() and playerObj:getInventory():FindAndReturn("PetrolCan") and generator:getFuel() < 100 then
      local petrolCan = playerObj:getInventory():FindAndReturn("PetrolCan");
      if petrolCan:getUsedDelta() > 0 then
        context:addOption(getText("ContextMenu_GeneratorAddFuel"), worldobjects, ISWorldObjectContextMenu.onAddFuel, petrolCan, generator, player);
      end
    end
    if not generator:isActivated() and generator:getCondition() < 100 then
      local option = context:addOption(getText("ContextMenu_GeneratorFix"), worldobjects, ISWorldObjectContextMenu.onFixGenerator, generator, player);
      if not playerObj:getKnownRecipes():contains("Generator") then
        local tooltip = ISWorldObjectContextMenu.addToolTip();
        option.notAvailable = true;
        tooltip.description = getText("ContextMenu_GeneratorPlugTT");
        option.toolTip = tooltip;
      end
      if not playerObj:getInventory():contains("ElectronicsScrap") then
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
    context:addOption(getText("ContextMenu_ViewSafehouse"), worldobjects, ISWorldObjectContextMenu.onViewSafeHouse, safehouse, playerObj);
  end
  if not safehouse and clickedSquare:getBuilding() and clickedSquare:getBuilding():getDef() then
    local reason = SafeHouse.canBeSafehouse(clickedSquare, playerObj);
    if reason then
      local option = context:addOption(getText("ContextMenu_SafehouseClaim"), worldobjects, ISWorldObjectContextMenu.onTakeSafeHouse, clickedSquare, player);
      if reason ~= "" then
        local toolTip = ISToolTip:new();
        toolTip:initialise();
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
    context:addOption(getText("ContextMenu_ExtinguishFire"), worldobjects, ISWorldObjectContextMenu.onRemoveFire, firetile, extinguisher, getSpecificPlayer(player));
  end

  if compost and compost:getCompost() > 10 and getSpecificPlayer(player):getInventory():getItemsFromType("EmptySandbag", true):size() > 0 then
    context:addOption(getText("ContextMenu_GetCompost") .. " (" .. math.floor(compost:getCompost()) .. getText("ContextMenu_FullPercent") .. ")", worldobjects, ISWorldObjectContextMenu.onGetCompost, compost, getSpecificPlayer(player));
  end

  -- debug stash
  if getCore():isInDebug() then
    context:addOption("Stash Debug", worldobjects, ISWorldObjectContextMenu.onStashDebug);
    context:addOption("Teleport", worldobjects, ISWorldObjectContextMenu.onTeleport);
  end

  -- walk to
  if JoypadState.players[player + 1] == nil then
    if test == true then return true; end
    context:addOption(getText("ContextMenu_Walk_to"), worldobjects, ISWorldObjectContextMenu.onWalkTo, item, player);
  end

  -- use the event (as you would 'OnTick' etc) to add items to context menu without mod conflicts.
  triggerEvent("OnFillWorldObjectContextMenu", player, context, worldobjects, test);

  if test then return ISWorldObjectContextMenu.Test end

  if context.numOptions == 1 then
    context:setVisible(false);
  end

  return context;
end

ISWorldObjectContextMenu.onStashDebug = function()
  local ui = StashDebug:new(0, 0, 300, 600);
  ui:initialise();
  ui:addToUIManager();
end

ISWorldObjectContextMenu.onTeleport = function()
  getPlayer():setX(2727);
  getPlayer():setY(13257);
  getPlayer():setLx(getPlayer():getX());
  getPlayer():setLy(getPlayer():getY());
end

ISWorldObjectContextMenu.doScavengeOptions = function(context, player, scavengeZone, clickedSquare)
  local text = "";
  local zone = ISScavengeAction.getScavengingZone(clickedSquare:getX(), clickedSquare:getY());
  if not zone then
    text = "(100" .. getText("ContextMenu_FullPercent") .. ")"
  else
    local plantLeft = tonumber(zone:getName());
    local scavengeZoneIncrease = 0;
    if SandboxVars.NatureAbundance == 1 then -- very poor
      scavengeZoneIncrease = -5;
    elseif SandboxVars.NatureAbundance == 2 then -- poor
      scavengeZoneIncrease = -2;
    elseif SandboxVars.NatureAbundance == 4 then -- abundant
      scavengeZoneIncrease = 2;
    elseif SandboxVars.NatureAbundance == 5 then -- very abundant
      scavengeZoneIncrease = 5;
    end
    local scavengeZoneNumber = ZombRand(5, 15) + scavengeZoneIncrease;
    if scavengeZoneNumber <= 0 then
      scavengeZoneNumber = 1;
    end
    if getGametimeTimestamp() - zone:getLastActionTimestamp() > 50000 then
      zone:setName(scavengeZoneNumber .. "");
      zone:setOriginalName(scavengeZoneNumber .. "");
    end
    if zone:getName() == "0" then
      text = "(" .. getText("ContextMenu_Empty") .. ")";
    else
      text = "(" .. math.floor((tonumber(zone:getName()) / tonumber(zone:getOriginalName())) * 100) .. getText("ContextMenu_FullPercent") .. ")";
    end
  end

  context:addOption(getText("ContextMenu_Forage") .. " " .. text, nil, ISWorldObjectContextMenu.onScavenge, player, scavengeZone, clickedSquare);
end

ISWorldObjectContextMenu.onAddPlayerToSafehouse = function(worldobjects, safehouse, player)
  safehouse:addPlayer(player:getUsername());
end

ISWorldObjectContextMenu.onGetCompost = function(worldobjects, compost, player)
  local sandbag = player:getInventory():getItemsFromType("EmptySandbag", true):get(0);
  if luautils.haveToBeTransfered(player, sandbag) then
    ISTimedActionQueue.add(ISInventoryTransferAction:new(player, sandbag, sandbag:getContainer(), player:getInventory()));
  end
  if luautils.walkAdj(player, compost:getSquare()) then
    ISTimedActionQueue.add(ISGetCompost:new(player, compost, sandbag, 100));
  end
end

ISWorldObjectContextMenu.onRemoveFire = function(worldobjects, firetile, extinguisher, player)
  local bo = ISExtinguishCursor:new(player, extinguisher)
  getCell():setDrag(bo, bo.player)
end

ISWorldObjectContextMenu.onRemovePlayerFromSafehouse = function(worldobjects, safehouse, playerName, playerNum)
  -- Don't remove players close to the safehouse, they'll get trapped inside.
  local players = getOnlinePlayers()
  for i = 1, players:size() do
    local player = players:get(i - 1)
    if player:getUsername() == playerName then
      if player:getX() >= safehouse:getX() - 10 and player:getX() < safehouse:getX2() + 10 and
      player:getY() >= safehouse:getY() - 10 and player:getY() < safehouse:getY2() + 10 then
        local modal = ISModalRichText:new(0, 0, 230, 90, getText("ContextMenu_RemovePlayerFailed"), false, nil, nil, playerNum)
        modal:initialise()
        modal:addToUIManager()
        if JoypadState.players[playerNum + 1] then
          JoypadState.players[playerNum + 1].focus = modal
        end
        return
      end
    end
  end
  safehouse:removePlayer(playerName)
end

ISWorldObjectContextMenu.onReleaseSafeHouse = function(worldobjects, safehouse, player)
  safehouse:removeSafeHouse(getSpecificPlayer(player));
end

ISWorldObjectContextMenu.onTakeSafeHouse = function(worldobjects, square, player)
  SafeHouse.addSafeHouse(square, getSpecificPlayer(player));
end

ISWorldObjectContextMenu.onViewSafeHouse = function(worldobjects, safehouse, player)
  local safehouseUI = ISSafehouseUI:new(getCore():getScreenWidth() / 2 - 250, getCore():getScreenHeight() / 2 - 225, 500, 450, safehouse, player);
  safehouseUI:initialise()
  safehouseUI:addToUIManager()
end

ISWorldObjectContextMenu.onTakeFuel = function(worldobjects, player, square)
  --   while tonumber(square:getProperties():Val("fuelAmount")) > 0 do
  local petrolCan = player:getInventory():FindAndReturn("EmptyPetrolCan");
  if petrolCan then
    player:getInventory():Remove(petrolCan);
    petrolCan = player:getInventory():AddItem("Base.PetrolCan");
    petrolCan:setUsedDelta(0);
  else
    local cans = player:getInventory():getItemsFromType("PetrolCan");
    for i = 0, cans:size() - 1 do
      local petrolCan2 = cans:get(i);
      if petrolCan2:getUsedDelta() < 1 then
        petrolCan = petrolCan2;
        break;
      end
    end
  end

  if petrolCan and luautils.walkAdj(player, square) then
    ISTimedActionQueue.add(ISTakeFuel:new(player, square, petrolCan, 100 - (petrolCan:getUsedDelta() * 50)));
  end
end

ISWorldObjectContextMenu.onInfoGenerator = function(worldobjects, generator, player)
  local playerObj = getSpecificPlayer(player)
  if luautils.walkAdj(playerObj, generator:getSquare()) then
    ISTimedActionQueue.add(ISGeneratorInfoAction:new(playerObj, generator))
  end
end

ISWorldObjectContextMenu.onPlugGenerator = function(worldobjects, generator, player, plug)
  local playerObj = getSpecificPlayer(player)
  if luautils.walkAdj(playerObj, generator:getSquare()) then
    ISTimedActionQueue.add(ISPlugGenerator:new(player, generator, plug, 300));
  end
end

ISWorldObjectContextMenu.onActivateGenerator = function(worldobjects, enable, generator, player)
  local playerObj = getSpecificPlayer(player)
  if luautils.walkAdj(playerObj, generator:getSquare()) then
    ISTimedActionQueue.add(ISActivateGenerator:new(player, generator, enable, 30));
  end
end

ISWorldObjectContextMenu.onFixGenerator = function(worldobjects, generator, player)
  local playerObj = getSpecificPlayer(player)
  if luautils.walkAdj(playerObj, generator:getSquare()) then
    ISTimedActionQueue.add(ISFixGenerator:new(getSpecificPlayer(player), generator, 150));
  end
end

ISWorldObjectContextMenu.onAddFuel = function(worldobjects, petrolCan, generator, player)
  local playerObj = getSpecificPlayer(player)
  if luautils.walkAdj(playerObj, generator:getSquare()) then
    ISTimedActionQueue.add(ISAddFuel:new(player, generator, petrolCan, 70 + (petrolCan:getUsedDelta() * 40)));
  end
end

ISWorldObjectContextMenu.onTakeGenerator = function(worldobjects, generator, player)
  local playerObj = getSpecificPlayer(player)
  if luautils.walkAdj(playerObj, generator:getSquare()) then
    ISTimedActionQueue.add(ISTakeGenerator:new(player, generator, 100));
  end
end

ISWorldObjectContextMenu.onFishing = function(worldobjects, player)
  --    if JoypadState.players[player:getPlayerNum()+1] then
  --        local target = FishingTarget:new(player)
  --        getCell():setDrag(target, 0)
  --        return
  --    end
  local rod = ISWorldObjectContextMenu.getFishingRode(player)
  ISWorldObjectContextMenu.equip(player, player:getPrimaryHandItem(), rod:getType(), true);
  local lure = nil
  if rod:getType() ~= "WoodenLance" then
    lure = ISWorldObjectContextMenu.getFishingLure(player, rod)
    ISWorldObjectContextMenu.equip(player, player:getSecondaryHandItem(), lure:getType(), false);
  end
  ISTimedActionQueue.add(ISFishingAction:new(player, worldobjects[1], rod, lure));
end

ISWorldObjectContextMenu.onFishingNet = function(worldobjects, player)
  local net = fishingNet:new(player);
  getCell():setDrag(net, player:getPlayerNum());
end

ISWorldObjectContextMenu.onCheckFishingNet = function(worldobjects, player, trap, hours)
  ISTimedActionQueue.add(ISCheckFishingNetAction:new(player, trap, hours));
end

ISWorldObjectContextMenu.onRemoveFishingNet = function(worldobjects, player, trap)
  fishingNet.remove(trap, player);
end

ISWorldObjectContextMenu.getFishingLure = function(player, rod)
  if not rod then
    return nil
  end
  if rod:getType() == "WoodenLance" then
    return true
  end
  if player:getSecondaryHandItem() and player:getSecondaryHandItem():isFishingLure() then
    return player:getSecondaryHandItem();
  end
  for i = 0, player:getInventory():getItems():size() - 1 do
    local item = player:getInventory():getItems():get(i);
    if item:isFishingLure() then
      return item;
    end
  end
  return nil;
end

ISWorldObjectContextMenu.getFishingRode = function(player)
  local types = {
    CraftedFishingRod = true,
    CraftedFishingRodTwineLine = true,
    FishingRod = true,
    FishingRodTwineLine = true,
    WoodenLance = true
  }
  local handItem = player:getPrimaryHandItem()
  if handItem and types[handItem:getType()] and ISWorldObjectContextMenu.getFishingLure(player, handItem) then
    return handItem
  end
  for i = 0, player:getInventory():getItems():size() - 1 do
    local item = player:getInventory():getItems():get(i)
    if not item:isBroken() and types[item:getType()] and ISWorldObjectContextMenu.getFishingLure(player, item) then
      return item
    end
  end
  return nil
end

ISWorldObjectContextMenu.onDestroy = function(worldobjects, player)
  local bo = ISDestroyCursor:new(player)
  getCell():setDrag(bo, bo.player)
end

-- maps object:getName() -> translated label
local ThumpableNameToLabel = {
  ["Bar"] = "ContextMenu_Bar",
  ["Barbed Fence"] = "ContextMenu_Barbed_Fence",
  ["Bed"] = "ContextMenu_Bed",
  ["Bookcase"] = "ContextMenu_Bookcase",
  ["Double Shelves"] = "ContextMenu_DoubleShelves",
  ["Gravel Bag Wall"] = "ContextMenu_Gravel_Bag_Wall",
  ["Lamp on Pillar"] = "ContextMenu_Lamp_on_Pillar",
  ["Large Table"] = "ContextMenu_Large_Table",
  ["Log Wall"] = "ContextMenu_Log_Wall",
  ["Rain Collector Barrel"] = "ContextMenu_Rain_Collector_Barrel",
  ["Sand Bag Wall"] = "ContextMenu_Sang_Bag_Wall",
  ["Shelves"] = "ContextMenu_Shelves",
  ["Small Bookcase"] = "ContextMenu_SmallBookcase",
  ["Small Table"] = "ContextMenu_Small_Table",
  ["Small Table with Drawer"] = "ContextMenu_Table_with_Drawer",
  ["Window Frame"] = "ContextMenu_Windows_Frame",
  ["Wooden Crate"] = "ContextMenu_Wooden_Crate",
  ["Wooden Door"] = "ContextMenu_Door",
  ["Wooden Fence"] = "ContextMenu_Wooden_Fence",
  ["Wooden Stairs"] = "ContextMenu_Stairs",
  ["Wooden Stake"] = "ContextMenu_Wooden_Stake",
  ["Wooden Wall"] = "ContextMenu_Wooden_Wall",
  ["Wooden Pillar"] = "ContextMenu_Wooden_Pillar",
  ["Wooden Chair"] = "ContextMenu_Wooden_Chair",
  ["Wooden Stairs"] = "ContextMenu_Stairs",
  ["Wooden Sign"] = "ContextMenu_Sign",
  ["Wooden Door Frame"] = "ContextMenu_Door_Frame",
}

function ISWorldObjectContextMenu.getThumpableName(thump)
  if ThumpableNameToLabel[thump:getName()] then
    return getText(ThumpableNameToLabel[thump:getName()])
  end
  return thump:getName()
end

ISWorldObjectContextMenu.onChopTree = function(worldobjects, player, tree)
  if tree:getObjectIndex() == -1 then return end
  if luautils.walkAdj(player, tree:getSquare()) then
    local handItem = player:getPrimaryHandItem()
    if not handItem or (handItem:getType() ~= "Axe" and handItem:getType() ~= "AxeStone") then
      handItem = (player:getInventory():getBestCondition("Axe") or player:getInventory():getBestCondition("AxeStone"))
      if not handItem or handItem:getCondition() <= 0 then return end
      local primary = true
      local twoHands = not player:getSecondaryHandItem()
      ISTimedActionQueue.add(ISEquipWeaponAction:new(player, handItem, 50, primary, twoHands))
    end
    ISTimedActionQueue.add(ISChopTreeAction:new(player, tree))
  end
end

ISWorldObjectContextMenu.onCheckStats = function(worldobjects, player, otherPlayer)
  local ui = ISPlayerStatsUI:new(50, 50, 800, 800, otherPlayer, player)
  ui:initialise();
  ui:addToUIManager();
  ui:setVisible(true);
end

ISWorldObjectContextMenu.onTrade = function(worldobjects, player, otherPlayer)
  local ui = ISTradingUI:new(50, 50, 500, 500, player, otherPlayer)
  ui:initialise();
  ui:addToUIManager();
  ui.pendingRequest = true;
  ui.blockingMessage = getText("IGUI_TradingUI_WaitingAnswer", otherPlayer:getDisplayName());
  requestTrading(player, otherPlayer);
end

ISWorldObjectContextMenu.onMedicalCheck = function(worldobjects, player, otherPlayer)
  if player:getAccessLevel() ~= "None" then
    ISTimedActionQueue.add(ISMedicalCheckAction:new(player, otherPlayer))
  else
    if luautils.walkAdj(player, otherPlayer:getCurrentSquare()) then
      ISTimedActionQueue.add(ISMedicalCheckAction:new(player, otherPlayer))
    end
  end
end

ISWorldObjectContextMenu.onWakeOther = function(worldobjects, player, otherPlayer)
  if luautils.walkAdj(player, otherPlayer:getCurrentSquare()) then
    ISTimedActionQueue.add(ISWakeOtherPlayer:new(player, otherPlayer))
  end
end

ISWorldObjectContextMenu.onScavenge = function(worldobjects, player, zone, clickedSquare)
  local modal = ISScavengeUI:new(0, 0, 300, 220, player, zone, clickedSquare);
  modal:initialise()
  modal:addToUIManager()
  if JoypadState.players[player + 1] then
    setJoypadFocus(player, modal)
  end
end

ISWorldObjectContextMenu.checkWeapon = function(chr)
  local weapon = chr:getPrimaryHandItem()
  weapon = weapon;
  if not weapon or weapon:getCondition() <= 0 then
    chr:setPrimaryHandItem(nil)
    if chr:getSecondaryHandItem() == weapon then
      chr:setSecondaryHandItem(nil)
    end
    weapon = chr:getInventory():getBestWeapon(chr:getDescriptor())
    if weapon and weapon ~= chr:getPrimaryHandItem() and weapon:getCondition() > 0 then
      chr:setPrimaryHandItem(weapon)
      if weapon:isTwoHandWeapon() and not chr:getSecondaryHandItem() then
        chr:setSecondaryHandItem(weapon)
      end
    end
    ISInventoryPage.dirtyUI();
  end
end

ISWorldObjectContextMenu.onToggleThumpableLight = function(lightSource, player)
  local playerObj = getSpecificPlayer(player)
  if luautils.walkAdj(playerObj, lightSource:getSquare()) then
    ISTimedActionQueue.add(ISToggleLightSourceAction:new(playerObj, lightSource, 5))
  end
end

ISWorldObjectContextMenu.onInsertFuel = function(lightSource, fuel, playerObj)
  if luautils.walkAdj(playerObj, lightSource:getSquare()) then
    ISTimedActionQueue.add(ISInsertLightSourceFuelAction:new(playerObj, lightSource, fuel, 50))
  end
end

ISWorldObjectContextMenu.onRemoveFuel = function(lightSource, player)
  local playerObj = getSpecificPlayer(player)
  if luautils.walkAdj(playerObj, lightSource:getSquare()) then
    ISTimedActionQueue.add(ISRemoveLightSourceFuelAction:new(playerObj, lightSource, 50))
  end
end

ISWorldObjectContextMenu.onRest = function(bed, player)
  local playerObj = getSpecificPlayer(player)
  if luautils.walkAdj(getSpecificPlayer(player), bed:getSquare()) then
    ISTimedActionQueue.add(ISRestAction:new(playerObj))
  end
end


ISWorldObjectContextMenu.onSleep = function(bed, player)
  local modal = ISModalDialog:new(0, 0, 250, 150, getText("IGUI_ConfirmSleep"), true, nil, ISWorldObjectContextMenu.onConfirmSleep, player, player, bed);
  modal:initialise()
  modal:addToUIManager()
  if JoypadState.players[player + 1] then
    setJoypadFocus(player, modal)
  end
end

function ISWorldObjectContextMenu.onConfirmSleep(this, button, player, bed)
  if button.internal == "YES" then
    local playerObj = getSpecificPlayer(player)
    ISTimedActionQueue.clear(playerObj)
    if AdjacentFreeTileFinder.isTileOrAdjacent(playerObj:getCurrentSquare(), bed:getSquare()) then
      ISWorldObjectContextMenu.onSleepWalkToComplete(player, bed)
    else
      local adjacent = AdjacentFreeTileFinder.Find(bed:getSquare(), playerObj)
      if adjacent ~= nil then
        local action = ISWalkToTimedAction:new(playerObj, adjacent)
        action:setOnComplete(ISWorldObjectContextMenu.onSleepWalkToComplete, player, bed)
        ISTimedActionQueue.add(action)
      end
    end
  end
end

function ISWorldObjectContextMenu.onSleepWalkToComplete(player, bed)
  local playerObj = getSpecificPlayer(player)
  local bedType = bed:getProperties():Val("BedType") or "averageBed";
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
    UIManager.getSpeedControls():SetCurrentGameSpeed(3)
    save(true)
  end
end

function ISWorldObjectContextMenu:onSleepModalClick(button)
  --	if JoypadState.players[ISContextMenu.globalPlayerContext+1] then
  --		JoypadState.players[ISContextMenu.globalPlayerContext+1].focus = nil;
  --		updateJoypadFocus(JoypadState.players[ISContextMenu.globalPlayerContext+1]);
  --	end
  if JoypadState.players[1] then
    JoypadState.players[1].focus = nil
    updateJoypadFocus(JoypadState[1])
  end
end

ISWorldObjectContextMenu.canStoreWater = function(object)
  -- check water shut off sandbox option
  -- if it's -1, the water have been shuted instant
  if SandboxVars.WaterShutModifier < 0 and (object:getSprite() and object:getSprite():getProperties() and object:getSprite():getProperties():Is(IsoFlagType.waterPiped)) then
    return nil;
  end
  if object ~= nil and instanceof(object, "IsoObject") and object:getSprite() and object:getSprite():getProperties() and
  (((object:getSprite():getProperties():Is(IsoFlagType.waterPiped)) and GameTime:getInstance():getNightsSurvived() < SandboxVars.WaterShutModifier) or object:getSprite():getProperties():Is("waterAmount")) and not instanceof(object, "IsoRaindrop") then
    return object;
  end
  -- we also check the square properties
  if object ~= nil and instanceof(object, "IsoObject") and object:getSquare() and object:getSquare():getProperties() and
  (((object:getSquare():getProperties():Is(IsoFlagType.waterPiped)) and GameTime:getInstance():getNightsSurvived() < SandboxVars.WaterShutModifier) or object:getSquare():getProperties():Is("waterAmount")) and not instanceof(object, "IsoRaindrop") then
    return object;
  end
end

ISWorldObjectContextMenu.haveWaterContainer = function(playerId)
  for i = 0, getSpecificPlayer(playerId):getInventory():getItems():size() - 1 do
    local item = getSpecificPlayer(playerId):getInventory():getItems():get(i);
    -- our item can store water, but doesn't have water right now
    if item:canStoreWater() and not item:isWaterSource() then
      return item;
    end
    -- or our item can store water and is not full
    if item:canStoreWater() and item:isWaterSource() and instanceof(item, "DrainableComboItem") and item:getUsedDelta() < 1 then
      return item;
    end
  end
  return nil;
end

ISWorldObjectContextMenu.onToggleStove = function(worldobjects, stove, player)
  local playerObj = getSpecificPlayer(player)
  if stove:getSquare() and luautils.walkAdj(playerObj, stove:getSquare()) then
    ISTimedActionQueue.add(ISToggleStoveAction:new(playerObj, stove))
  end
end

ISWorldObjectContextMenu.onMicrowaveSetting = function(worldobjects, stove, player)
  local playerObj = getSpecificPlayer(player)
  if luautils.walkAdj(playerObj, stove:getSquare()) then
    ISTimedActionQueue.add(ISOvenUITimedAction:new(playerObj, nil, stove))
  end
end

ISWorldObjectContextMenu.onStoveSetting = function(worldobjects, stove, player)
  local playerObj = getSpecificPlayer(player)
  if luautils.walkAdj(playerObj, stove:getSquare()) then
    ISTimedActionQueue.add(ISOvenUITimedAction:new(playerObj, stove, nil))
  end
end

ISWorldObjectContextMenu.onToggleLight = function(worldobjects, light, player)
  local playerObj = getSpecificPlayer(player)
  if light:getSquare() and luautils.walkAdj(playerObj, light:getSquare()) then
    ISTimedActionQueue.add(ISToggleLightAction:new(playerObj, light))
  end
end

ISWorldObjectContextMenu.onLightBulb = function(worldobjects, light, player, remove, bulbitem)
  local playerObj = getSpecificPlayer(player)
  if light:getSquare() and luautils.walkAdj(playerObj, light:getSquare()) then
    if remove then
      ISTimedActionQueue.add(ISLightActions:new("RemoveLightBulb", playerObj, light));
    else
      ISTimedActionQueue.add(ISLightActions:new("AddLightBulb", playerObj, light, bulbitem));
    end
  end
end

ISWorldObjectContextMenu.onLightModify = function(worldobjects, light, player, scrapitem)
  local playerObj = getSpecificPlayer(player)
  if light:getSquare() and luautils.walkAdj(playerObj, light:getSquare()) then
    ISTimedActionQueue.add(ISLightActions:new("ModifyLamp", playerObj, light, scrapitem));
  end
end

ISWorldObjectContextMenu.onLightBattery = function(worldobjects, light, player, remove, battery)
  local playerObj = getSpecificPlayer(player)
  if light:getSquare() and luautils.walkAdj(playerObj, light:getSquare()) then
    if remove then
      ISTimedActionQueue.add(ISLightActions:new("RemoveBattery", playerObj, light));
    else
      ISTimedActionQueue.add(ISLightActions:new("AddBattery", playerObj, light, battery));
    end
  end
end


-- This should return the same value as ISInventoryTransferAction
ISWorldObjectContextMenu.grabItemTime = function(playerObj, witem)
  local w = witem:getItem():getActualWeight()
  if w > 3 then w = 3 end
  local dest = playerObj:getInventory()
  local destCapacityDelta = dest:getCapacityWeight() / dest:getMaxWeight()
  return 50 * w * destCapacityDelta
end

ISWorldObjectContextMenu.onGrabWItem = function(worldobjects, WItem, player)
  local playerObj = getSpecificPlayer(player)
  if WItem:getSquare() and luautils.walkAdj(playerObj, WItem:getSquare()) then
    local time = ISWorldObjectContextMenu.grabItemTime(playerObj, WItem)
    ISTimedActionQueue.add(ISGrabItemAction:new(playerObj, WItem, time))
  end
end

ISWorldObjectContextMenu.onGrabHalfWItems = function(worldobjects, WItems, player)
  WItem = WItems[1]
  local playerObj = getSpecificPlayer(player)
  if WItem:getSquare() and luautils.walkAdj(playerObj, WItem:getSquare()) then
    local time = ISWorldObjectContextMenu.grabItemTime(playerObj, WItem)
    local count = 0
    for _, WItem in ipairs(WItems) do
      ISTimedActionQueue.add(ISGrabItemAction:new(playerObj, WItem, time))
      count = count + 1
      if count >= #WItems / 2 then return end
    end
  end
end

ISWorldObjectContextMenu.onGrabAllWItems = function(worldobjects, WItems, player)
  WItem = WItems[1]
  local playerObj = getSpecificPlayer(player)
  if WItem:getSquare() and luautils.walkAdj(playerObj, WItem:getSquare()) then
    local time = ISWorldObjectContextMenu.grabItemTime(playerObj, WItem)
    for _, WItem in ipairs(WItems) do
      ISTimedActionQueue.add(ISGrabItemAction:new(playerObj, WItem, time))
    end
  end
end

ISWorldObjectContextMenu.onTakeTrap = function(worldobjects, trap, player)
  local playerObj = getSpecificPlayer(player)
  if trap:getObjectIndex() ~= -1 and luautils.walkAdj(playerObj, trap:getSquare(), false) then
    ISTimedActionQueue.add(ISTakeTrap:new(playerObj, trap, 50));
  end
end

ISWorldObjectContextMenu.onGrabCorpseItem = function(worldobjects, WItem, player)
  local playerObj = getSpecificPlayer(player)
  if WItem:getSquare() and luautils.walkAdj(playerObj, WItem:getSquare()) then
    ISTimedActionQueue.add(ISGrabCorpseAction:new(playerObj, WItem, 50));
  end
end

ISWorldObjectContextMenu.onGetDoorKey = function(worldobjects, player, door, doorKeyId)
  local newKey = getSpecificPlayer(player):getInventory():AddItem("Base.Key1");
  newKey:setKeyId(doorKeyId);
  door:setHaveKey(false);
end

ISWorldObjectContextMenu.onLockDoor = function(worldobjects, player, door)
  local playerObj = getSpecificPlayer(player)
  if luautils.walkAdjWindowOrDoor(getSpecificPlayer(player), door:getSquare(), door) then
    ISTimedActionQueue.add(ISLockDoor:new(playerObj, door, true));
  end
end

ISWorldObjectContextMenu.onUnLockDoor = function(worldobjects, player, door, doorKeyId)
  local playerObj = getSpecificPlayer(player)
  if luautils.walkAdjWindowOrDoor(getSpecificPlayer(player), door:getSquare(), door) then
    ISTimedActionQueue.add(ISLockDoor:new(playerObj, door, false));
  end
end

ISWorldObjectContextMenu.onRemoveDigitalPadlockWalkToComplete = function(player, thump)
  local modal = ISDigitalCode:new(0, 0, 230, 120, nil, ISWorldObjectContextMenu.onCheckDigitalCode, player, nil, thump, true);
  modal:initialise();
  modal:addToUIManager();
  if JoypadState.players[player + 1] then
    setJoypadFocus(player, modal)
  end
end

ISWorldObjectContextMenu.onRemoveDigitalPadlock = function(worldobjects, player, thump)
  local playerObj = getSpecificPlayer(player)
  ISTimedActionQueue.clear(playerObj)

  if AdjacentFreeTileFinder.isTileOrAdjacent(playerObj:getCurrentSquare(), thump:getSquare()) then
    ISWorldObjectContextMenu.onRemoveDigitalPadlockWalkToComplete(player, thump)
  else
    local adjacent = AdjacentFreeTileFinder.Find(thump:getSquare(), playerObj)
    if adjacent ~= nil then
      local action = ISWalkToTimedAction:new(playerObj, adjacent)
      action:setOnComplete(ISWorldObjectContextMenu.onRemoveDigitalPadlockWalkToComplete, player, thump)
      ISTimedActionQueue.add(action)
    end
  end
end

ISWorldObjectContextMenu.onPutDigitalPadlockWalkToComplete = function(player, thump, padlock)
  local modal = ISDigitalCode:new(0, 0, 230, 120, nil, ISWorldObjectContextMenu.onSetDigitalCode, player, padlock, thump, true);
  modal:initialise();
  modal:addToUIManager();
  if JoypadState.players[player + 1] then
    setJoypadFocus(player, modal)
  end
end

ISWorldObjectContextMenu.onPutDigitalPadlock = function(worldobjects, player, thump, padlock)

  local playerObj = getSpecificPlayer(player)
  ISTimedActionQueue.clear(playerObj)

  if AdjacentFreeTileFinder.isTileOrAdjacent(playerObj:getCurrentSquare(), thump:getSquare()) then
    ISWorldObjectContextMenu.onPutDigitalPadlockWalkToComplete(player, thump, padlock)
  else
    local adjacent = AdjacentFreeTileFinder.Find(thump:getSquare(), playerObj)
    if adjacent ~= nil then
      local action = ISWalkToTimedAction:new(playerObj, adjacent)
      action:setOnComplete(ISWorldObjectContextMenu.onPutDigitalPadlockWalkToComplete, player, thump, padlock)
      ISTimedActionQueue.add(action)
    end
  end
end

function ISWorldObjectContextMenu:onSetDigitalCode(button, player, padlock, thumpable)
  local dialog = button.parent
  if button.internal == "OK" and dialog:getCode() ~= 0 then
    player:getInventory():Remove(padlock);
    thumpable:setLockedByCode(dialog:getCode());
    local pdata = getPlayerData(player:getPlayerNum());
    pdata.playerInventory:refreshBackpacks();
    pdata.lootInventory:refreshBackpacks()
  end
end

function ISWorldObjectContextMenu:onCheckDigitalCode(button, player, padlock, thumpable)
  local dialog = button.parent
  if button.internal == "OK" then
    if thumpable:getLockedByCode() == dialog:getCode() then
      thumpable:setLockedByCode(0);
      player:getInventory():AddItem("Base.CombinationPadlock");
      local pdata = getPlayerData(player:getPlayerNum());
      pdata.playerInventory:refreshBackpacks();
      pdata.lootInventory:refreshBackpacks()
    end
  end
end

ISWorldObjectContextMenu.onPutPadlock = function(worldobjects, player, thump, padlock)
  local playerObj = getSpecificPlayer(player)

  if luautils.walkAdj(playerObj, thump:getSquare()) then
    ISTimedActionQueue.add(ISPadlockAction:new(playerObj, thump, padlock, getPlayerData(player), true));
  end
end

ISWorldObjectContextMenu.onRemovePadlock = function(worldobjects, player, thump)
  local playerObj = getSpecificPlayer(player)

  if luautils.walkAdj(playerObj, thump:getSquare()) then
    ISTimedActionQueue.add(ISPadlockAction:new(playerObj, thump, nil, getPlayerData(player), false));
  end
end

ISWorldObjectContextMenu.onClearAshes = function(worldobjects, player, ashes)
  local playerObj = getSpecificPlayer(player)
  if ashes:getSquare() and luautils.walkAdj(playerObj, ashes:getSquare()) then
    if playerObj:getInventory():FindAndReturn("Shovel") then
      ISTimedActionQueue.add(ISEquipWeaponAction:new(playerObj, playerObj:getInventory():FindAndReturn("Shovel"), 20, true, false));
    end
    ISTimedActionQueue.add(ISClearAshes:new(playerObj, ashes, 60));
  end
end

ISWorldObjectContextMenu.onBurnCorpse = function(worldobjects, player, corpse)
  local playerObj = getSpecificPlayer(player)
  if corpse:getSquare() and luautils.walkAdj(playerObj, corpse:getSquare()) then
    if playerObj:getInventory():FindAndReturn("Lighter") then
      ISTimedActionQueue.add(ISEquipWeaponAction:new(playerObj, playerObj:getInventory():FindAndReturn("Lighter"), 20, true, false));
    elseif playerObj:getInventory():FindAndReturn("Matches") then
      ISTimedActionQueue.add(ISEquipWeaponAction:new(playerObj, playerObj:getInventory():FindAndReturn("Matches"), 20, true, false));
    end
    ISTimedActionQueue.add(ISEquipWeaponAction:new(playerObj, playerObj:getInventory():FindAndReturn("PetrolCan"), 40, false, false));
    ISTimedActionQueue.add(ISBurnCorpseAction:new(playerObj, corpse, 60));
  end
end



ISWorldObjectContextMenu.onDrink = function(worldobjects, waterObject, player)
  local playerObj = getSpecificPlayer(player)
  if not waterObject:getSquare() or not luautils.walkAdj(playerObj, waterObject:getSquare()) then
    return
  end
  local waterAvailable = waterObject:getWaterAmount()
  local waterNeeded = math.min(math.ceil(playerObj:getStats():getThirst() * 10), 10)
  local waterConsumed = math.min(waterNeeded, waterAvailable)
  ISTimedActionQueue.add(ISTakeWaterAction:new(playerObj, nil, waterConsumed, waterObject, (waterConsumed * 10) + 15));
end

ISWorldObjectContextMenu.onTakeWater = function(worldobjects, waterObject, waterContainer, player)
  local playerObj = getSpecificPlayer(player)
  local waterAvailable = waterObject:getWaterAmount()
  -- first case, fill an empty bottle
  if waterContainer:canStoreWater() and not waterContainer:isWaterSource() then
    if not waterObject:getSquare() or not luautils.walkAdj(playerObj, waterObject:getSquare()) then
      return
    end
    -- we create the item wich contain our water
    local newItem = waterObject:replaceItem(waterContainer);
    -- we empty it, so we gonna start to fill it in the timed action
    newItem:setUsedDelta(0);
    local destCapacity = 1 / newItem:getUseDelta()
    local waterConsumed = math.min(math.ceil(destCapacity), waterAvailable)
    ISTimedActionQueue.add(ISTakeWaterAction:new(playerObj, newItem, waterConsumed, waterObject, waterConsumed * 10));
  elseif waterContainer:canStoreWater() and waterContainer:isWaterSource() then -- second case, a bottle contain some water, we just fill it
    if not waterObject:getSquare() or not luautils.walkAdj(playerObj, waterObject:getSquare()) then
      return
    end
    local destCapacity = (1 - waterContainer:getUsedDelta()) / waterContainer:getUseDelta()
    local waterConsumed = math.min(math.ceil(destCapacity), waterAvailable)
    ISTimedActionQueue.add(ISTakeWaterAction:new(playerObj, waterContainer, waterConsumed, waterObject, waterConsumed * 10));
  end
end

ISWorldObjectContextMenu.onChooseSafehouse = function(worldobjects, building)
  getSpecificPlayer(ISContextMenu.globalPlayerContext):setSafehouse(building);
end

ISWorldObjectContextMenu.onTalkTo = function(worldobjects, survivor)
end

ISWorldObjectContextMenu.onStay = function(worldobjects, survivor)
  survivor:StayHere(getSpecificPlayer(ISContextMenu.globalPlayerContext));
end

ISWorldObjectContextMenu.onGuard = function(worldobjects, survivor)
  survivor:Guard(getSpecificPlayer(ISContextMenu.globalPlayerContext));
end

ISWorldObjectContextMenu.onFollow = function(worldobjects, survivor)
  survivor:FollowMe(getSpecificPlayer(ISContextMenu.globalPlayerContext));
end

ISWorldObjectContextMenu.onTeamUp = function(worldobjects, survivor)
  survivor:MeetFirstTime(getSpecificPlayer(ISContextMenu.globalPlayerContext), true, false);
end

ISWorldObjectContextMenu.onUnbarricade = function(worldobjects, window, player)
  local playerObj = getSpecificPlayer(player)
  if luautils.walkAdjWindowOrDoor(playerObj, window:getSquare(), window) then
    if playerObj:getInventory():contains("Hammer", true) then
      ISWorldObjectContextMenu.equip(playerObj, playerObj:getPrimaryHandItem(), "Hammer", true);
    else
      ISWorldObjectContextMenu.equip(playerObj, playerObj:getPrimaryHandItem(), "HammerStone", true);
    end
    ISTimedActionQueue.add(ISUnbarricadeAction:new(playerObj, window, (100 - (playerObj:getPerkLevel(Perks.Woodwork) * 5))));
  end
end

ISWorldObjectContextMenu.onUnbarricadeMetal = function(worldobjects, window, player)
  local playerObj = getSpecificPlayer(player)
  if luautils.walkAdjWindowOrDoor(playerObj, window:getSquare(), window) then
    ISWorldObjectContextMenu.equip(playerObj, playerObj:getPrimaryHandItem(), "BlowTorch", true);
    ISTimedActionQueue.add(ISUnbarricadeAction:new(playerObj, window, 120));
  end
end

ISWorldObjectContextMenu.isThumpDoor = function(thumpable)
  local isDoor = false;
  if instanceof(thumpable, "IsoThumpable") then
    if thumpable:isDoor() or thumpable:isWindow() then
      isDoor = true;
    end
  end
  if instanceof(thumpable, "IsoWindow") or instanceof(thumpable, "IsoDoor") then
    isDoor = true;
  end
  return isDoor;
end

ISWorldObjectContextMenu.onClimbSheetRope = function(worldobjects, square, down, player)
  if square then
    local playerObj = getSpecificPlayer(player)
    ISTimedActionQueue.add(ISWalkToTimedAction:new(playerObj, square))
    ISTimedActionQueue.add(ISClimbSheetRopeAction:new(playerObj, down))
  end
end

ISWorldObjectContextMenu.onSit = function(worldobjects, chair, player)
  ISTimedActionQueue.add(ISSitOnChairAction:new(getSpecificPlayer(player), chair));
end

ISWorldObjectContextMenu.onMetalBarBarricade = function(worldobjects, window, player)
  local playerObj = getSpecificPlayer(player)
  -- we must check these otherwise ISEquipWeaponAction will get a null item
  if playerObj:getInventory():getItemCount("Base.MetalBar", true) < 3 then return end
  local parent = window:getSquare();
  if not AdjacentFreeTileFinder.isTileOrAdjacent(playerObj:getCurrentSquare(), parent) then
    local adjacent = nil;
    if ISWorldObjectContextMenu.isThumpDoor(window) then
      adjacent = AdjacentFreeTileFinder.FindWindowOrDoor(parent, window, playerObj);
    else
      adjacent = AdjacentFreeTileFinder.Find(parent, playerObj);
    end
    if adjacent ~= nil then
      ISTimedActionQueue.clear(playerObj);
      ISWorldObjectContextMenu.equip(playerObj, playerObj:getPrimaryHandItem(), "BlowTorch", true);
      ISWorldObjectContextMenu.equip(playerObj, playerObj:getSecondaryHandItem(), "MetalBar", false);

      ISTimedActionQueue.add(ISWalkToTimedAction:new(playerObj, adjacent));
      ISTimedActionQueue.add(ISBarricadeAction:new(playerObj, window, false, true, (170 - (playerObj:getPerkLevel(Perks.MetalWelding) * 5))));
      return;
    else
      return;
    end
  else
    ISWorldObjectContextMenu.equip(playerObj, playerObj:getPrimaryHandItem(), "BlowTorch", true);
    ISWorldObjectContextMenu.equip(playerObj, playerObj:getSecondaryHandItem(), "MetalBar", false);
    ISTimedActionQueue.add(ISBarricadeAction:new(playerObj, window, false, true, (170 - (playerObj:getPerkLevel(Perks.MetalWelding) * 5))));
  end
end

ISWorldObjectContextMenu.onMetalBarricade = function(worldobjects, window, player)
  local playerObj = getSpecificPlayer(player)
  -- we must check these otherwise ISEquipWeaponAction will get a null item
  if not playerObj:getInventory():FindAndReturn("SheetMetal") then return end
  local parent = window:getSquare();
  if not AdjacentFreeTileFinder.isTileOrAdjacent(playerObj:getCurrentSquare(), parent) then
    local adjacent = nil;
    if ISWorldObjectContextMenu.isThumpDoor(window) then
      adjacent = AdjacentFreeTileFinder.FindWindowOrDoor(parent, window, playerObj);
    else
      adjacent = AdjacentFreeTileFinder.Find(parent, playerObj);
    end
    if adjacent ~= nil then
      ISTimedActionQueue.clear(playerObj);
      ISWorldObjectContextMenu.equip(playerObj, playerObj:getPrimaryHandItem(), "BlowTorch", true);
      ISWorldObjectContextMenu.equip(playerObj, playerObj:getSecondaryHandItem(), "SheetMetal", false);

      ISTimedActionQueue.add(ISWalkToTimedAction:new(playerObj, adjacent));
      ISTimedActionQueue.add(ISBarricadeAction:new(playerObj, window, true, false, (170 - (playerObj:getPerkLevel(Perks.MetalWelding) * 5))));
      return;
    else
      return;
    end
  else
    ISWorldObjectContextMenu.equip(playerObj, playerObj:getPrimaryHandItem(), "BlowTorch", true);
    ISWorldObjectContextMenu.equip(playerObj, playerObj:getSecondaryHandItem(), "SheetMetal", false);
    ISTimedActionQueue.add(ISBarricadeAction:new(playerObj, window, true, false, (170 - (playerObj:getPerkLevel(Perks.MetalWelding) * 5))));
  end
end

ISWorldObjectContextMenu.onBarricade = function(worldobjects, window, player)
  local playerObj = getSpecificPlayer(player)
  -- we must check these otherwise ISEquipWeaponAction will get a null item
  if not playerObj:getInventory():contains("Hammer", true) and not playerObj:getInventory():contains("HammerStone", true) then return end
  if not playerObj:getInventory():contains("Plank", true) then return end
  if not playerObj:getInventory():contains("Nails", true) then return end
  local parent = window:getSquare();
  if not AdjacentFreeTileFinder.isTileOrAdjacent(playerObj:getCurrentSquare(), parent) then
    local adjacent = nil;
    if ISWorldObjectContextMenu.isThumpDoor(window) then
      adjacent = AdjacentFreeTileFinder.FindWindowOrDoor(parent, window, playerObj);
    else
      adjacent = AdjacentFreeTileFinder.Find(parent, playerObj);
    end
    if adjacent ~= nil then
      ISTimedActionQueue.clear(playerObj);
      if playerObj:getInventory():contains("Hammer", true) then
        ISWorldObjectContextMenu.equip(playerObj, playerObj:getPrimaryHandItem(), "Hammer", true);
      else
        ISWorldObjectContextMenu.equip(playerObj, playerObj:getPrimaryHandItem(), "HammerStone", true);
      end
      ISWorldObjectContextMenu.equip(playerObj, playerObj:getSecondaryHandItem(), "Plank", false);
      ISTimedActionQueue.add(ISWalkToTimedAction:new(playerObj, adjacent));
      ISTimedActionQueue.add(ISBarricadeAction:new(playerObj, window, false, false, (100 - (playerObj:getPerkLevel(Perks.Woodwork) * 5))));
      return;
    else
      return;
    end
  else
    if playerObj:getInventory():contains("Hammer", true) then
      ISWorldObjectContextMenu.equip(playerObj, playerObj:getPrimaryHandItem(), "Hammer", true);
    else
      ISWorldObjectContextMenu.equip(playerObj, playerObj:getPrimaryHandItem(), "HammerStone", true);
    end
    ISWorldObjectContextMenu.equip(playerObj, playerObj:getSecondaryHandItem(), "Plank", false);
    ISTimedActionQueue.add(ISBarricadeAction:new(playerObj, window, false, false, (100 - (playerObj:getPerkLevel(Perks.Woodwork) * 5))));
  end
end

ISWorldObjectContextMenu.doorCurtainCheck = function(argTable)
  if argTable.door:IsOpen() ~= argTable.open then
    local square = argTable.door:getSheetSquare()
    if not square or not square:isFree(false) then return true end -- stop
    argTable.action.pathfindBehaviour:reset()
    argTable.action.pathfindBehaviour:setData(argTable.playerObj, square:getX(), square:getY(), square:getZ())
    argTable.open = argTable.door:IsOpen()
  end
  return false
end

ISWorldObjectContextMenu.restoreDoor = function(playerObj, door, isOpen)
  if door:IsOpen() ~= isOpen then
    door:ToggleDoor(playerObj)
  end
end

ISWorldObjectContextMenu.onAddSheet = function(worldobjects, window, player)
  local playerObj = getSpecificPlayer(player)
  local square = window:getAddSheetSquare(playerObj)
  if square and square:isFree(false) then
    local action = ISWalkToTimedAction:new(playerObj, square)
    if instanceof(window, "IsoDoor") then
      action:setOnComplete(ISWorldObjectContextMenu.restoreDoor, playerObj, window, window:IsOpen())
    end
    ISTimedActionQueue.add(action)
    ISTimedActionQueue.add(ISAddSheetAction:new(playerObj, window, 50));
  elseif luautils.walkAdjWindowOrDoor(playerObj, window:getSquare(), window) then
    if instanceof(window, "IsoDoor") then return end
    ISTimedActionQueue.add(ISAddSheetAction:new(playerObj, window, 50));
  end
end

ISWorldObjectContextMenu.onRemoveCurtain = function(worldobjects, curtain, player)
  local playerObj = getSpecificPlayer(player)
  if instanceof(curtain, "IsoDoor") then
    local square = curtain:getSheetSquare()
    if square and square:isFree(false) then
      --			local userData = {playerObj = playerObj, door = curtain, open = curtain:IsOpen()}
      --			local action = ISWalkToTimedAction:new(playerObj, square, ISWorldObjectContextMenu.doorCurtainCheck, userData)
      --			userData.action = action
      local action = ISWalkToTimedAction:new(playerObj, square)
      action:setOnComplete(ISWorldObjectContextMenu.restoreDoor, playerObj, curtain, curtain:IsOpen())
      ISTimedActionQueue.add(action)
      ISTimedActionQueue.add(ISRemoveSheetAction:new(playerObj, curtain, 50));
    end
    return
  end
  if curtain:getSquare() and curtain:getSquare():isFree(false) then
    ISTimedActionQueue.add(ISWalkToTimedAction:new(playerObj, curtain:getSquare()))
    ISTimedActionQueue.add(ISRemoveSheetAction:new(playerObj, curtain, 50));
  elseif luautils.walkAdjWindowOrDoor(playerObj, curtain:getSquare(), curtain) then
    ISTimedActionQueue.add(ISRemoveSheetAction:new(playerObj, curtain, 50));
  end
end

ISWorldObjectContextMenu.onOpenCloseCurtain = function(worldobjects, curtain, player)
  local playerObj = getSpecificPlayer(player)
  if instanceof(curtain, "IsoDoor") then
    local square = curtain:getSheetSquare()
    if square and square:isFree(false) then
      local action = ISWalkToTimedAction:new(playerObj, square)
      action:setOnComplete(ISWorldObjectContextMenu.restoreDoor, playerObj, curtain, curtain:IsOpen())
      ISTimedActionQueue.add(action)
      ISTimedActionQueue.add(ISOpenCloseCurtain:new(playerObj, curtain, 0));
    end
    return
  end
  if curtain:getSquare() and curtain:getSquare():isFree(false) then
    ISTimedActionQueue.add(ISWalkToTimedAction:new(playerObj, curtain:getSquare()))
    ISTimedActionQueue.add(ISOpenCloseCurtain:new(playerObj, curtain, 0));
  elseif luautils.walkAdjWindowOrDoor(playerObj, curtain:getSquare(), curtain) then
    ISTimedActionQueue.add(ISOpenCloseCurtain:new(playerObj, curtain, 0));
  end
end

ISWorldObjectContextMenu.onOpenCloseWindow = function(worldobjects, window, player)
  local playerObj = getSpecificPlayer(player)
  local square = window:getSquare()
  --[[
	-- If there is a counter in front of the window, don't walk outside the room to open it
	local square = window:getIndoorSquare()
	if not (square and square:getRoom() == playerObj:getCurrentSquare():getRoom()) then
--		square = window:getSquare()
	end
]]--
  if luautils.walkAdjWindowOrDoor(playerObj, square, window) then
    ISTimedActionQueue.add(ISOpenCloseWindow:new(playerObj, window, 0));
  end
end

ISWorldObjectContextMenu.onAddSheetRope = function(worldobjects, window, player)
  local playerObj = getSpecificPlayer(player)
  if luautils.walkAdjWindowOrDoor(playerObj, window:getSquare(), window) then
    ISTimedActionQueue.add(ISAddSheetRope:new(playerObj, window));
  end
end

ISWorldObjectContextMenu.onRemoveSheetRope = function(worldobjects, window, player)
  local playerObj = getSpecificPlayer(player)
  if luautils.walkAdjWindowOrDoor(playerObj, window:getSquare(), window) then
    ISTimedActionQueue.add(ISRemoveSheetRope:new(playerObj, window));
  end
end

ISWorldObjectContextMenu.isTrappedAdjacentToWindow = function(player, window)
  if not player or not window then return false end
  local sq = player:getCurrentSquare()
  local sq2 = window:getSquare()
  if not sq or not sq2 or sq:getZ() ~= sq2:getZ() then return false end
  if not (sq:Is(IsoFlagType.solid) or sq:Is(IsoFlagType.solidtrans)) then return false end
  local north = IsoWindowFrame.isWindowFrame(window) and window:getProperties():Is("WindowN") or window:getNorth()
  if north and sq:getX() == sq:getX() and (sq:getY() == sq2:getY() - 1 or sq:getY() == sq2:getY()) then
    return true
  end
  if not north and sq:getY() == sq:getY() and (sq:getX() == sq2:getX() - 1 or sq:getX() == sq2:getX()) then
    return true
  end
  return false
end

ISWorldObjectContextMenu.onClimbThroughWindow = function(worldobjects, window, player)
  local playerObj = getSpecificPlayer(player)
  if ISWorldObjectContextMenu.isTrappedAdjacentToWindow(playerObj, window) then
    ISTimedActionQueue.add(ISClimbThroughWindow:new(playerObj, window, 0))
    return
  end
  local square = window:getSquare()
  --[[
	-- If there is a counter in front of the window, don't walk outside the room to climb through it.
	-- This is for windows on the south or east wall of a room.
	if instanceof(window, 'IsoWindow') then
		if square:getRoom() ~= playerObj:getCurrentSquare():getRoom() then
			if window:getIndoorSquare() and window:getIndoorSquare():Is(IsoFlagType.solidtrans) then
				square = window:getIndoorSquare()
			end
		end
	end
]]--
  if luautils.walkAdjWindowOrDoor(playerObj, square, window) then
    ISTimedActionQueue.add(ISClimbThroughWindow:new(playerObj, window, 0));
  end
end
ISWorldObjectContextMenu.onSmashWindow = function(worldobjects, window, player)
  local playerObj = getSpecificPlayer(player)
  if luautils.walkAdjWindowOrDoor(playerObj, window:getSquare(), window) then
    ISTimedActionQueue.add(ISSmashWindow:new(playerObj, window, 0));
  end
end
ISWorldObjectContextMenu.onRemoveBrokenGlass = function(worldobjects, window, player)
  local playerObj = getSpecificPlayer(player)
  if luautils.walkAdjWindowOrDoor(playerObj, window:getSquare(), window) then
    ISTimedActionQueue.add(ISRemoveBrokenGlass:new(playerObj, window, 100));
  end
end
ISWorldObjectContextMenu.onOpenCloseDoor = function(worldobjects, door, player)
  local playerObj = getSpecificPlayer(player)
  if luautils.walkAdjWindowOrDoor(playerObj, door:getSquare(), door) then
    ISTimedActionQueue.add(ISOpenCloseDoor:new(playerObj, door, 0));
  end
end

ISWorldObjectContextMenu.onCleanBlood = function(worldobjects, square, player)
  local playerObj = getSpecificPlayer(player)
  if luautils.walkAdj(playerObj, square) then
    ISTimedActionQueue.add(ISCleanBlood:new(playerObj, square, 50));
  end
end

ISWorldObjectContextMenu.onRemoveTree = function(worldobjects, square, wallVine, player)
  player = getSpecificPlayer(player);
  if luautils.walkAdj(player, square) then
    local handItem = player:getPrimaryHandItem()
    if not handItem or (handItem:getType() ~= "Axe" and handItem:getType() ~= "KitchenKnife" and handItem:getType() ~= "HuntingKnife" and handItem:getType() ~= "AxeStone") then
      handItem = (player:getInventory():getBestCondition("Axe") or player:getInventory():getBestCondition("KitchenKnife") or player:getInventory():getBestCondition("HuntingKnife") or player:getInventory():getBestCondition("AxeStone"))
      if not handItem or handItem:getCondition() <= 0 then return end
      local primary = true
      ISTimedActionQueue.add(ISEquipWeaponAction:new(player, handItem, 50, primary, false))
    end
    ISTimedActionQueue.add(ISRemoveBush:new(player, square, wallVine));
  end
end

ISWorldObjectContextMenu.onRemoveGrass = function(worldobjects, square, player)
  player = getSpecificPlayer(player);
  if luautils.walkAdj(player, square) then
    ISTimedActionQueue.add(ISRemoveGrass:new(player, square));
  end
end

ISWorldObjectContextMenu.onRemoveWallVine = function(worldobjects, square, player)

end

ISWorldObjectContextMenu.onWalkTo = function(worldobjects, item, player)
  local playerObj = getSpecificPlayer(player)
  local parent = item:getSquare();
  local adjacent = AdjacentFreeTileFinder.Find(parent, playerObj);
  if instanceof(item, "IsoWindow") or instanceof(item, "IsoDoor") then
    adjacent = AdjacentFreeTileFinder.FindWindowOrDoor(parent, item, playerObj);
  end
  if adjacent ~= nil then
    ISTimedActionQueue.add(ISWalkToTimedAction:new(getSpecificPlayer(player), adjacent));
  end
end

-- we equip the item before if it's not equiped before using it
ISWorldObjectContextMenu.equip = function(player, handItem, item, primary)
  if not handItem or handItem:getType() ~= item then
    local items = player:getInventory():getItemsFromType(item, true);
    for i = 0, items:size() - 1 do
      handItem = items:get(i)
      if not handItem:isBroken() then
        if luautils.haveToBeTransfered(player, handItem) then
          ISTimedActionQueue.add(ISInventoryTransferAction:new(player, handItem, handItem:getContainer(), player:getInventory()));
        end
        ISTimedActionQueue.add(ISEquipWeaponAction:new(player, handItem, 50, primary))
        break
      end
    end
  end
  return handItem;
end

ISWorldObjectContextMenu.equip2 = function(player, handItem, item, primary)
  if not handItem or handItem ~= item then
    ISTimedActionQueue.add(ISEquipWeaponAction:new(player, item, 50, primary))
  end
  return handItem;
end

ISWorldObjectContextMenu.getZone = function(x, y, z)
  local zones = getZones(x, y, z);
  -- get the zone without name, the one with name are custom ones (for fishing, plant scavenging..)
  if zones then
    for i = 0, zones:size() - 1 do
      if not zones:get(i):getName() or zones:get(i):getName() == "" then
        return zones:get(i);
      end
    end
  end
end

ISWorldObjectContextMenu.addToolTip = function()
  local toolTip = ISToolTip:new();
  toolTip:initialise();
  toolTip:setVisible(false);
  return toolTip;
end

ISWorldObjectContextMenu.checkBlowTorchForBarricade = function(chr)
  local bt = chr:getInventory():FindAndReturn("BlowTorch");
  if not bt then return false; end
  return math.floor(bt:getUsedDelta() / bt:getUseDelta()) > 3;
end

ISWorldObjectContextMenu.doSleepOption = function(context, bed, player, playerObj)
  local sleepOption = context:addOption(getText("ContextMenu_Sleep"), bed, ISWorldObjectContextMenu.onSleep, player);
  -- Not tired enough
  if playerObj:getStats():getFatigue() <= 0.3 then
    sleepOption.notAvailable = true;
    local tooltip = ISWorldObjectContextMenu.addToolTip();
    tooltip:setName(getText("ContextMenu_Sleeping"));
    tooltip.description = getText("IGUI_Sleep_NotTiredEnough");
    sleepOption.toolTip = tooltip;
    --Player outside.
  elseif (playerObj:isOutside()) and RainManager:isRaining() then
    local square = getCell():getGridSquare(bed:getX(), bed:getY(), bed:getZ() + 1);
    if square == nil or square:getFloor() == nil then
      if bed:getName() ~= "Tent" then
        sleepOption.notAvailable = true;
        local tooltip = ISWorldObjectContextMenu.addToolTip();
        tooltip:setName(getText("ContextMenu_Sleeping"));
        tooltip.description = getText("IGUI_Sleep_OutsideRain");
        sleepOption.toolTip = tooltip;
      end
    end
  end

  -- Sleeping pills counter those sleeping problems
  if playerObj:getSleepingTabletEffect() < 2000 then
    -- In pain, can still sleep if really tired
    if playerObj:getMoodles():getMoodleLevel(MoodleType.Pain) >= 2 and playerObj:getStats():getFatigue() <= 0.85 then
      sleepOption.notAvailable = true;
      local tooltip = ISWorldObjectContextMenu.addToolTip();
      tooltip:setName(getText("ContextMenu_Sleeping"));
      tooltip.description = getText("ContextMenu_PainNoSleep");
      sleepOption.toolTip = tooltip;
      -- In panic
    elseif playerObj:getMoodles():getMoodleLevel(MoodleType.Panic) >= 1 then
      sleepOption.notAvailable = true;
      local tooltip = ISWorldObjectContextMenu.addToolTip();
      tooltip:setName(getText("ContextMenu_Sleeping"));
      tooltip.description = getText("ContextMenu_PanicNoSleep");
      sleepOption.toolTip = tooltip;
      -- tried to sleep not so long ago
    elseif (playerObj:getHoursSurvived() - playerObj:getLastHourSleeped()) <= 1 then
      sleepOption.notAvailable = true;
      local sleepTooltip = ISWorldObjectContextMenu.addToolTip();
      sleepTooltip:setName(getText("ContextMenu_Sleeping"));
      sleepTooltip.description = getText("ContextMenu_NoSleepTooEarly");
      sleepOption.toolTip = sleepTooltip;
    end
  end
end

ISWorldObjectContextMenu.onDigGraves = function(worldobjects, player)
  local bo = ISEmptyGraves:new("location_community_cemetary_01_33", "location_community_cemetary_01_32", "location_community_cemetary_01_34", "location_community_cemetary_01_35");
  bo.player = player;
  getCell():setDrag(bo, bo.player);
end

ISWorldObjectContextMenu.onBuryCorpse = function(grave, player)
  if luautils.walkAdj(getSpecificPlayer(player), grave:getSquare()) then
    ISTimedActionQueue.add(ISBuryCorpse:new(player, grave, 80));
  end
end
