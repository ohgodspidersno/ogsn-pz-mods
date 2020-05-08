ISWorldObjectContextMenu = {}
ISWorldObjectContextMenu.fetchSquares = {}

ISWorldObjectContextMenu.clearFetch = function()
  c = 0;
  window = nil;
  windowFrame = nil;
  brokenGlass = nil;
  door = nil;
  clothingDryer = nil
  clothingWasher = nil
  campfire = nil
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
  carBatteryCharger = nil
  generator = nil;
  haveFuel = nil;
  safehouse = nil;
  firetile = nil;
  extinguisher = nil;
  trap = nil;
  ashes = nil;
  compost = nil;
  graves = nil;
  canBeWaterPiped = nil;
  shovel = nil;
  building = nil;
  ISWorldObjectContextMenu.fetchSquares = {}
end

local function timeString(timeInMinutes)
  local hourStr = getText("IGUI_Gametime_hour")
  local minuteStr = getText("IGUI_Gametime_minute")
  local hours = math.floor(timeInMinutes / 60)
  local minutes = timeInMinutes % 60
  if hours ~= 1 then hourStr = getText("IGUI_Gametime_hours") end
  if minutes ~= 1 then minuteStr = getText("IGUI_Gametime_minutes") end
  local str = ""
  if hours ~= 0 then
    str = hours .. ' ' .. hourStr
  end
  if str == '' or minutes ~= 0 then
    if str ~= '' then str = str .. ', ' end
    str = str .. minutes .. ' ' .. minuteStr
  end
  return str
end

local function predicateNotBroken(item)
  return not item:isBroken()
end

local function predicateNotEmpty(item)
  return item:getUsedDelta() > 0
end

local function predicateNotFull(item)
  return item:getUsedDelta() < 1
end

local CuttingToolTypes = { "WoodAxe", "Axe", "AxeStone", "HandAxe", "Machete", "HuntingKnife", "KitchenKnife" }
local CuttingToolTypeMap = {}
for _, type in ipairs(CuttingToolTypes) do
  CuttingToolTypeMap[type] = 1
end

local function predicateCuttingTool(item)
  return not item:isBroken() and (CuttingToolTypeMap[item:getType()] ~= nil)
end

local function predicateClearAshes(item)
  return not item:isBroken() and ISInventoryBuildMenu.shovelTypeMap[item:getFullType()] ~= nil
end

ISWorldObjectContextMenu.fetch = function(v, player, doSquare)
  local playerObj = getSpecificPlayer(player)
  local playerInv = playerObj:getInventory()

  shovel = ISFarmingMenu.getShovel(playerObj);

  if v:getSquare() then
    local worldItems = v:getSquare():getWorldObjects();
    if worldItems and not worldItems:isEmpty() then
      worldItem = worldItems:get(0);
    end
  end
  if v:getSquare() then
    building = v:getSquare():getBuilding();
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
    if CCampfireSystem.instance:isValidIsoObject(v) then
      campfire = v
    end
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
    if CRainBarrelSystem.instance:isValidIsoObject(v) then
      rainCollectorBarrel = v
    end
  end
  if instanceof(v, "IsoTree") then
    tree = v
  end
  if instanceof(v, "IsoClothingDryer") then
    clothingDryer = v
  end
  if instanceof(v, "IsoClothingWasher") then
    clothingWasher = v
  end
  if instanceof(v, "IsoStove") and v:getContainer() then
    -- A burnt-out stove has no container.  FIXME: It would be better to remove the burnt stove object
    stove = v;
  end
  if instanceof(v, "IsoDeadBody") then
    body = v;
  end
  if instanceof(v, "IsoCarBatteryCharger") then
    carBatteryCharger = v;
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
  if instanceof(v, "IsoBrokenGlass") then
    brokenGlass = v
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
  local rod = ISWorldObjectContextMenu.getFishingRode(playerObj)
  if instanceof(v, "IsoObject") and v:getSprite() and v:getSprite():getProperties() and v:getSprite():getProperties():Is(IsoFlagType.water) and v:getSquare():DistToProper(playerObj:getSquare()) < 10 then
    canFish = true;
  end
  local hasCuttingTool = playerInv:containsEvalRecurse(predicateCuttingTool)
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
  if instanceof(v, "IsoObject") and v:getSprite() and v:getSprite():getProperties() and v:getSprite():getProperties():Is(IsoFlagType.water) and playerInv:containsTypeRecurse("FishingNet") then
    canTrapFish = true;
  end
  if instanceof(v, "IsoObject") and v:getName() == "FishingNet" and v:getSquare() then
    trapFish = v;
  end
  if v:getSquare() and (v:getSquare():getProperties():Is(IsoFlagType.climbSheetN) or v:getSquare():getProperties():Is(IsoFlagType.climbSheetW) or
  v:getSquare():getProperties():Is(IsoFlagType.climbSheetS) or v:getSquare():getProperties():Is(IsoFlagType.climbSheetE)) then
    sheetRopeSquare = v:getSquare()
  end
  if FireFighting.getSquareToExtinguish(v:getSquare()) then
    extinguisher = FireFighting.getExtinguisher(playerObj);
    firetile = v:getSquare();
  end
  -- check for scavenging
  if v:getSquare() and v:getSquare():getZ() == 0 then
    local zone = v:getSquare():getChunk():getScavengeZone()
    if zone and (zone:getType() == "Forest" or zone:getType() == "DeepForest") then
      scavengeZone = zone;
    end
  end
  clickedSquare = v:getSquare();
  if doSquare and playerInv:containsEvalRecurse(predicateClearAshes) and instanceof(v, "IsoObject") and v:getSprite() then
    local spriteName = v:getSprite():getName()
    if not spriteName then
      spriteName = v:getSpriteName()
    end
    if spriteName == 'floors_burnt_01_1' or spriteName == 'floors_burnt_01_2' then
      if not ashes or (ashes:getTargetAlpha() <= v:getTargetAlpha()) then
        ashes = v
      end
    end
  end
  local sledgehammer = playerInv:getFirstTypeEvalRecurse("Sledgehammer", predicateNotBroken)
  if not sledgehammer then
    sledgehammer = playerInv:getFirstTypeEvalRecurse("Sledgehammer2", predicateNotBroken)
  end
  if doSquare and sledgehammer and sledgehammer:getCondition() > 0 and instanceof(v, "IsoObject") and v:getSprite() and v:getSprite():getProperties() and
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
  if ISWorldObjectContextMenu.canCleanBlood(playerObj, v:getSquare()) then
    haveBlood = v:getSquare();
  end
  if instanceof(v, "IsoPlayer") then
    clickedPlayer = v;
  end

  if v:getSquare():getProperties():Is("fuelAmount") and tonumber(v:getSquare():getProperties():Val("fuelAmount")) > 0 then
    if playerInv:containsTypeRecurse("EmptyPetrolCan") or playerInv:containsTypeEvalRecurse("PetrolCan", predicateNotFull) then
      haveFuel = v;
    end
  end

  -- safehouse
  safehouse = SafeHouse.getSafeHouse(v:getSquare());

  if v:hasModData() and v:getModData().canBeWaterPiped and v:getSquare() and v:getSquare():isInARoom() then
    canBeWaterPiped = v;
  end

  item = v;
  if v:getSquare() and doSquare and not ISWorldObjectContextMenu.fetchSquares[v:getSquare()] then
    for i = 0, v:getSquare():getObjects():size() - 1 do
      ISWorldObjectContextMenu.fetch(v:getSquare():getObjects():get(i), player, false);
    end
    for i = 0, v:getSquare():getStaticMovingObjects():size() - 1 do
      ISWorldObjectContextMenu.fetch(v:getSquare():getStaticMovingObjects():get(i), player, false);
    end
    -- help detecting a player by checking nearby squares
    for x = v:getSquare():getX() - 1, v:getSquare():getX() + 1 do
      for y = v:getSquare():getY() - 1, v:getSquare():getY() + 1 do
        local sq = getCell():getGridSquare(x, y, v:getSquare():getZ());
        if sq then
          for i = 0, sq:getMovingObjects():size() - 1 do
            local o = sq:getMovingObjects():get(i)
            -- Medical check
            --            if JoypadState.players[player+1] and instanceof(o, "IsoPlayer") then
            if instanceof(o, "IsoPlayer") then
              ISWorldObjectContextMenu.fetch(o, player, false)
            end
          end
        end
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

local function predicateNotBrokenAxe(item)
  return not item:isBroken() and item:getScriptItem():getCategories():contains("Axe")
end

local function predicateBlowTorch(item)
  return item:getType() == "BlowTorch" and item:getDrainableUsesInt() > 3
end

-- MAIN METHOD FOR CREATING RIGHT CLICK CONTEXT MENU FOR WORLD ITEMS
ISWorldObjectContextMenu.createMenu = function(player, worldobjects, x, y, test)

  -- LetMeThink
  -- if UIManager.getSpeedControls():getCurrentGameSpeed() == 0 then
  -- 	return;
  -- end

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
  if graves and (playerInv:contains("CorpseMale") or playerInv:contains("CorpseFemale")) then
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

  if campfire and playerObj:DistToSquared(campfire:getX() + 0.5, campfire:getY() + 0.5) < 2 * 2 then
    if test == true then return true; end
    local luaCampfire = CCampfireSystem.instance:getLuaObjectOnSquare(campfire:getSquare())
    local option = context:addOption(getText("ContextMenu_CampfireInfo"), worldobjects, nil)
    if playerObj:DistToSquared(campfire:getX() + 0.5, campfire:getY() + 0.5) < 2 * 2 then
      option.toolTip = ISToolTip:new()
      option.toolTip:initialise()
      option.toolTip:setVisible(false)
      option.toolTip:setName(getText("ContextMenu_CampfireInfo"))
      option.toolTip.description = getText("IGUI_BBQ_FuelAmount", timeString(luautils.round(luaCampfire.fuelAmt)))
    end
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
    local pourInto = playerInv:getAllEvalRecurse(function(item)
      -- our item can store water, but doesn't have water right now
      if item:canStoreWater() and not item:isWaterSource() and not item:isBroken() then
        return true
      end

      -- or our item can store water and is not full
      if item:canStoreWater() and item:isWaterSource() and not item:isBroken() and instanceof(item, "DrainableComboItem") and item:getUsedDelta() < 1 then
        return true
      end

      return false
    end)
    if not pourInto:isEmpty() then
      if test == true then return true; end
      local subMenuOption = context:addOption(getText("ContextMenu_Fill"), worldobjects, nil);
      if not storeWater:getSquare() or not AdjacentFreeTileFinder.Find(storeWater:getSquare(), playerObj) then
        subMenuOption.notAvailable = true;
      end
      local subMenu = context:getNew(context)
      context:addSubMenu(subMenuOption, subMenu)
      for i = 1, pourInto:size() do
        local item = pourInto:get(i - 1)
        suboption = subMenu:addOption(item:getName(), worldobjects, ISWorldObjectContextMenu.onTakeWater, storeWater, item, player);
        if not storeWater:getSquare() or not AdjacentFreeTileFinder.Find(storeWater:getSquare(), playerObj) then
          suboption.notAvailable = true;
        end
      end
    end
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
        tooltip.description = getText("Tooltip_Climb", getKeyName(getCore():getKey("Interact")));
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
        tooltip.description = getText("Tooltip_Climb", getKeyName(getCore():getKey("Interact")));
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
        tooltip.description = getText("Tooltip_Climb", getKeyName(getCore():getKey("Interact")))
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
    context:addOption(getText("ContextMenu_ExtinguishFire"), worldobjects, ISWorldObjectContextMenu.onRemoveFire, firetile, extinguisher, playerObj);
  end

  if compost then
    local option = context:addOption(getText("ContextMenu_GetCompost") .. " (" .. math.floor(compost:getCompost()) .. getText("ContextMenu_FullPercent") .. ")",
    worldobjects, ISWorldObjectContextMenu.onGetCompost, compost, playerObj)
    option.notAvailable = compost:getCompost() < 10 or not playerInv:containsTypeRecurse("EmptySandbag")
    option.toolTip = ISToolTip:new()
    option.toolTip:initialise()
    option.toolTip:setVisible(false)
    option.toolTip:setName(getText("ContextMenu_Compost"))
    local percent = math.floor(compost:getCompost())
    option.toolTip.description = percent .. getText("ContextMenu_FullPercent")
    if percent < 10 then
      option.toolTip.description = "<RGB:1,0,0> " .. getText("ContextMenu_CompostPercentRequired", percent, 10)
    end
    if not playerInv:containsTypeRecurse("EmptySandbag") then
      option.toolTip.description = option.toolTip.description .. " <LINE> <RGB:1,0,0> " .. getText("ContextMenu_EmptySandbagRequired")
    end
  end


  -- walk to
  if JoypadState.players[player + 1] == nil and not playerObj:getVehicle() then
    if test == true then return true; end
    context:addOption(getText("ContextMenu_Walk_to"), worldobjects, ISWorldObjectContextMenu.onWalkTo, item, player);
  end

  if not playerObj:getVehicle() and not playerObj:isSitOnGround() then
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

-- Pour water from an item in inventory into an IsoObject
function ISWorldObjectContextMenu.addWaterFromItem(test, context, worldobjects, playerObj, playerInv)
  local pourWaterInto = rainCollectorBarrel -- TODO: other IsoObjects too?
  if pourWaterInto and tonumber(pourWaterInto:getModData().waterMax) and
  pourWaterInto:getWaterAmount() < pourWaterInto:getModData().waterMax then
    local pourOut = {}
    for i = 1, playerInv:getItems():size() do
      local item = playerInv:getItems():get(i - 1)
      if item:canStoreWater() and item:isWaterSource() then
        table.insert(pourOut, item)
      end
    end
    if #pourOut > 0 then
      if test then return true end
      local subMenuOption = context:addOption(getText("ContextMenu_AddWaterFromItem"), worldobjects, nil);
      local subMenu = context:getNew(context)
      context:addSubMenu(subMenuOption, subMenu)
      for _, item in ipairs(pourOut) do
        subMenu:addOption(item:getName(), worldobjects, ISWorldObjectContextMenu.onAddWaterFromItem, pourWaterInto, item, playerObj);
      end
    end
  end
  return false
end

local function onCarBatteryCharger_Activate(carBatteryCharger, playerObj)
  if luautils.walkAdj(playerObj, carBatteryCharger:getSquare()) then
    ISTimedActionQueue.add(ISActivateCarBatteryChargerAction:new(playerObj, carBatteryCharger, true, 50))
  end
end

local function onCarBatteryCharger_Deactivate(carBatteryCharger, playerObj)
  if luautils.walkAdj(playerObj, carBatteryCharger:getSquare()) then
    ISTimedActionQueue.add(ISActivateCarBatteryChargerAction:new(playerObj, carBatteryCharger, false, 50))
  end
end

local function onCarBatteryCharger_ConnectBattery(carBatteryCharger, playerObj, battery)
  if luautils.walkAdj(playerObj, carBatteryCharger:getSquare()) then
    ISWorldObjectContextMenu.transferIfNeeded(playerObj, battery)
    ISTimedActionQueue.add(ISConnectCarBatteryToChargerAction:new(playerObj, carBatteryCharger, battery, 100))
  end
end

local function onCarBatteryCharger_RemoveBattery(carBatteryCharger, playerObj)
  if luautils.walkAdj(playerObj, carBatteryCharger:getSquare()) then
    ISTimedActionQueue.add(ISRemoveCarBatteryFromChargerAction:new(playerObj, carBatteryCharger, 100))
  end
end

local function onCarBatteryCharger_Take(carBatteryCharger, playerObj)
  if luautils.walkAdj(playerObj, carBatteryCharger:getSquare()) then
    ISTimedActionQueue.add(ISTakeCarBatteryChargerAction:new(playerObj, carBatteryCharger, 50))
  end
end

function ISWorldObjectContextMenu.handleCarBatteryCharger(test, context, worldobjects, playerObj, playerInv)
  if test == true then return true end
  if carBatteryCharger:getBattery() then
    if carBatteryCharger:isActivated() then
      context:addOption(getText("ContextMenu_Turn_Off"), carBatteryCharger, onCarBatteryCharger_Deactivate, playerObj)
    else
      local option = context:addOption(getText("ContextMenu_Turn_On"), carBatteryCharger, onCarBatteryCharger_Activate, playerObj)
      if not (carBatteryCharger:getSquare():haveElectricity() or
      (GameTime:getInstance():getNightsSurvived() < SandboxVars.ElecShutModifier and carBatteryCharger:getSquare():getRoom())) then
        option.notAvailable = true
        option.toolTip = ISToolTip:new()
        option.toolTip:initialise()
        option.toolTip:setVisible(false)
        option.toolTip.description = getText("IGUI_RadioRequiresPowerNearby")
      end
    end
    local label = getText("ContextMenu_Remove_Battery").." (" .. math.floor(carBatteryCharger:getBattery():getUsedDelta() * 100) .. "%)"
    context:addOption(label, carBatteryCharger, onCarBatteryCharger_RemoveBattery, playerObj)
  else
    local batteryList = playerInv:getAllTypeEvalRecurse("CarBattery1", predicateNotFull)
    playerInv:getAllTypeEvalRecurse("CarBattery2", predicateNotFull, batteryList)
    playerInv:getAllTypeEvalRecurse("CarBattery3", predicateNotFull, batteryList)
    if not batteryList:isEmpty() then
      local chargeOption = context:addOption(getText("ContextMenu_CarBatteryCharger_ConnectBattery"))
      local subMenuCharge = context:getNew(context)
      context:addSubMenu(chargeOption, subMenuCharge)
      local done = false
      for i = 1, batteryList:size() do
        local battery = batteryList:get(i - 1)
        if battery:getUsedDelta() < 1 then
          local label = battery:getName() .. " (" .. math.floor(battery:getUsedDelta() * 100) .. "%)"
          subMenuCharge:addOption(label, carBatteryCharger, onCarBatteryCharger_ConnectBattery, playerObj, battery)
          done = true
        end
      end
      if not done then context:removeLastOption() end
    end
    context:addOption(getText("ContextMenu_CarBatteryCharger_Take"), carBatteryCharger, onCarBatteryCharger_Take, playerObj)
  end
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
  local sandbag = player:getInventory():getFirstTypeRecurse("EmptySandbag")
  if luautils.walkAdj(player, compost:getSquare()) then
    ISWorldObjectContextMenu.transferIfNeeded(player, sandbag)
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

ISWorldObjectContextMenu.onTakeFuel = function(worldobjects, playerObj, square)
  -- Prefer an equipped EmptyPetrolCan/PetrolCan, then the fullest PetrolCan, then any EmptyPetrolCan.
  local petrolCan = nil
  local equipped = playerObj:getPrimaryHandItem()
  if equipped and equipped:getType() == "PetrolCan" and equipped:getUsedDelta() < 1 then
    petrolCan = equipped
  elseif equipped and equipped:getType() == "EmptyPetrolCan" then
    petrolCan = equipped
  end
  if not petrolCan then
    local cans = playerObj:getInventory():getAllTypeEvalRecurse("PetrolCan", predicateNotFull)
    local usedDelta = -1
    for i = 1, cans:size() do
      local petrolCan2 = cans:get(i - 1)
      if petrolCan2:getUsedDelta() < 1 and petrolCan2:getUsedDelta() > usedDelta then
        petrolCan = petrolCan2
        usedDelta = petrolCan:getUsedDelta()
      end
    end
  end
  if not petrolCan then
    petrolCan = playerObj:getInventory():getFirstTypeRecurse("EmptyPetrolCan")
  end
  if petrolCan and luautils.walkAdj(playerObj, square) then
    ISInventoryPaneContextMenu.equipWeapon(petrolCan, true, false, playerObj:getPlayerNum())
    ISTimedActionQueue.add(ISTakeFuel:new(playerObj, square, petrolCan, 100))
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
  if ISFishingUI.instance then
    ISFishingUI.instance:removeFromUIManager();
  end
  local modal = ISFishingUI:new(0, 0, 450, 270, player, worldobjects[1]);
  modal:initialise()
  modal:addToUIManager()
  if JoypadState.players[player:getPlayerNum() + 1] then
    setJoypadFocus(player:getPlayerNum(), modal)
  end
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
  if WeaponType.getWeaponType(rod) == WeaponType.spear then
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
    SpearCrafted = true,
    SpearBreadKnife = true,
    SpearButterKnife = true,
    SpearFork = true,
    SpearLetterOpener = true,
    SpearScalpel = true,
    SpearSpoon = true,
    SpearScissors = true,
    SpearHandFork = true,
    SpearScrewdriver = true,
    SpearKnife = true,
    SpearHuntingKnife = true,
    SpearMachete = true,
    SpearIcePick = true,
  }
  local handItem = player:getPrimaryHandItem()
  if handItem and types[handItem:getType()] and ISWorldObjectContextMenu.getFishingLure(player, handItem) then
    return handItem
  end
  for i = 0, player:getInventory():getItems():size() - 1 do
    local item = player:getInventory():getItems():get(i)
    if not item:isBroken() and (types[item:getType()] or (instanceof(item, "HandWeapon") and WeaponType.getWeaponType(item) == WeaponType.spear)) and ISWorldObjectContextMenu.getFishingLure(player, item) then
      return item
    end
  end
  return nil
end

ISWorldObjectContextMenu.onDestroy = function(worldobjects, player, sledgehammer)
  local bo = ISDestroyCursor:new(player, false, sledgehammer)
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

ISWorldObjectContextMenu.onChopTree = function(worldobjects, playerObj, tree)
  local bo = ISChopTreeCursor:new("", "", playerObj)
  getCell():setDrag(bo, playerObj:getPlayerNum())
end

ISWorldObjectContextMenu.doChopTree = function(playerObj, tree)
  if not tree or tree:getObjectIndex() == -1 then return end
  if luautils.walkAdj(playerObj, tree:getSquare(), true) then
    local handItem = playerObj:getPrimaryHandItem()
    if not handItem or not predicateNotBrokenAxe(handItem) then
      handItem = playerObj:getInventory():getFirstEvalRecurse(predicateNotBrokenAxe)
      if not handItem or handItem:getCondition() <= 0 then return end
      local primary = true
      local twoHands = not playerObj:getSecondaryHandItem()
      ISWorldObjectContextMenu.equip(playerObj, playerObj:getPrimaryHandItem(), handItem, primary, twoHands)
    end
    ISTimedActionQueue.add(ISChopTreeAction:new(playerObj, tree))
  end
end

ISWorldObjectContextMenu.onTrade = function(worldobjects, player, otherPlayer)
  local ui = ISTradingUI:new(50, 50, 500, 500, player, otherPlayer)
  ui:initialise();
  ui:addToUIManager();
  ui.pendingRequest = true;
  ui.blockingMessage = getText("IGUI_TradingUI_WaitingAnswer", otherPlayer:getDisplayName());
  requestTrading(player, otherPlayer);
end

ISWorldObjectContextMenu.onCheckStats = function(worldobjects, player, otherPlayer)
  if ISPlayerStatsUI.instance then
    ISPlayerStatsUI.instance:close()
  end
  local ui = ISPlayerStatsUI:new(50, 50, 800, 800, otherPlayer, player)
  ui:initialise();
  ui:addToUIManager();
  ui:setVisible(true);
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
  if ISScavengeUI.instance then
    ISScavengeUI.instance:removeFromUIManager();
  end
  local modal = ISScavengeUI:new(0, 0, 450, 270, player, zone, clickedSquare);
  modal:initialise()
  modal:addToUIManager()
  if JoypadState.players[player + 1] then
    setJoypadFocus(player, modal)
  end
end

ISWorldObjectContextMenu.checkWeapon = function(chr)
  local weapon = chr:getPrimaryHandItem()
  if not weapon or weapon:getCondition() <= 0 then
    chr:removeFromHands(weapon)
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

function ISWorldObjectContextMenu.toggleClothingDryer(context, worldobjects, playerId, object)
  local playerObj = getSpecificPlayer(playerId)

  if not object then return end
  if not object:getContainer() then return end
  if ISWorldObjectContextMenu.isSomethingTo(object, playerId) then return end
  if getCore():getGameMode() == "LastStand" then return end

  if test == true then return true end

  local option = nil
  if object:isActivated() then
    option = context:addOption(getText("ContextMenu_Turn_Off"), worldobjects, ISWorldObjectContextMenu.onToggleClothingDryer, object, playerId)
  else
    option = context:addOption(getText("ContextMenu_Turn_On"), worldobjects, ISWorldObjectContextMenu.onToggleClothingDryer, object, playerId)
  end
  if not object:getContainer():isPowered() then
    option.notAvailable = true
    option.toolTip = ISToolTip:new()
    option.toolTip:initialise()
    option.toolTip:setVisible(false)
    option.toolTip.description = getText("IGUI_RadioRequiresPowerNearby")
  end
end

function ISWorldObjectContextMenu.onToggleClothingDryer(worldobjects, object, playerId)
  local playerObj = getSpecificPlayer(playerId)
  if object:getSquare() and luautils.walkAdj(playerObj, object:getSquare()) then
    ISTimedActionQueue.add(ISToggleClothingDryer:new(playerObj, object))
  end
end

function ISWorldObjectContextMenu.toggleClothingWasher(context, worldobjects, playerId, object)
  local playerObj = getSpecificPlayer(playerId)

  if not object then return end
  if not object:getContainer() then return end
  if ISWorldObjectContextMenu.isSomethingTo(object, playerId) then return end
  if getCore():getGameMode() == "LastStand" then return end

  if test == true then return true end

  local option = nil
  if object:isActivated() then
    option = context:addOption(getText("ContextMenu_Turn_Off"), worldobjects, ISWorldObjectContextMenu.onToggleClothingWasher, object, playerId)
  else
    option = context:addOption(getText("ContextMenu_Turn_On"), worldobjects, ISWorldObjectContextMenu.onToggleClothingWasher, object, playerId)
  end
  if not object:getContainer():isPowered() or (object:getWaterAmount() <= 0) then
    option.notAvailable = true
    option.toolTip = ISToolTip:new()
    option.toolTip:initialise()
    option.toolTip:setVisible(false)
    option.toolTip:setName(Translator.getMoveableDisplayName("Washing Machine"))
    if not object:getContainer():isPowered() then
      option.toolTip.description = getText("IGUI_RadioRequiresPowerNearby")
    end
    if object:getWaterAmount() <= 0 then
      if option.toolTip.description ~= "" then
        option.toolTip.description = option.toolTip.description .. "\n" .. getText("IGUI_RequiresWaterSupply")
      else
        option.toolTip.description = getText("IGUI_RequiresWaterSupply")
      end
    end
  end
end

function ISWorldObjectContextMenu.onToggleClothingWasher(worldobjects, object, playerId)
  local playerObj = getSpecificPlayer(playerId)
  if object:getSquare() and luautils.walkAdj(playerObj, object:getSquare()) then
    ISTimedActionQueue.add(ISToggleClothingWasher:new(playerObj, object))
  end
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
      ISWorldObjectContextMenu.transferIfNeeded(playerObj, bulbitem)
      ISTimedActionQueue.add(ISLightActions:new("AddLightBulb", playerObj, light, bulbitem));
    end
  end
end

ISWorldObjectContextMenu.onLightModify = function(worldobjects, light, player, scrapitem)
  local playerObj = getSpecificPlayer(player)
  local playerInv = playerObj:getInventory()
  if light:getSquare() and luautils.walkAdj(playerObj, light:getSquare()) then
    local screwdriver = playerInv:getFirstTypeEvalRecurse("Screwdriver", predicateNotBroken)
    local scrapItem = playerInv:getFirstTypeRecurse("ElectronicsScrap")
    if not screwdriver or not scrapItem then return end
    ISWorldObjectContextMenu.equip(playerObj, playerObj:getPrimaryHandItem(), screwdriver, true, false)
    ISWorldObjectContextMenu.equip(playerObj, playerObj:getSecondaryHandItem(), scrapItem, false, false)
    ISTimedActionQueue.add(ISLightActions:new("ModifyLamp", playerObj, light, scrapItem));
  end
end

ISWorldObjectContextMenu.onLightBattery = function(worldobjects, light, player, remove, battery)
  local playerObj = getSpecificPlayer(player)
  if light:getSquare() and luautils.walkAdj(playerObj, light:getSquare()) then
    if remove then
      ISTimedActionQueue.add(ISLightActions:new("RemoveBattery", playerObj, light));
    else
      ISWorldObjectContextMenu.transferIfNeeded(playerObj, battery)
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

ISWorldObjectContextMenu.onPlumbItem = function(worldobjects, player, itemToPipe)
  local playerObj = getSpecificPlayer(player)
  local wrench = playerObj:getInventory():getFirstTypeEvalRecurse("Wrench", predicateNotBroken);
  ISWorldObjectContextMenu.equip(playerObj, playerObj:getPrimaryHandItem(), wrench, true)
  ISTimedActionQueue.add(ISPlumbItem:new(playerObj, itemToPipe, wrench, 100));
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
  local playerInv = playerObj:getInventory()
  if ashes:getSquare() and luautils.walkAdj(playerObj, ashes:getSquare()) then
    ISWorldObjectContextMenu.equip(playerObj, playerObj:getPrimaryHandItem(), predicateClearAshes, true)
    ISTimedActionQueue.add(ISClearAshes:new(playerObj, ashes, 60));
  end
end

ISWorldObjectContextMenu.onBurnCorpse = function(worldobjects, player, corpse)
  local playerObj = getSpecificPlayer(player)
  local playerInv = playerObj:getInventory()
  if corpse:getSquare() and luautils.walkAdj(playerObj, corpse:getSquare()) then
    if playerInv:containsTypeRecurse("Lighter") then
      ISWorldObjectContextMenu.equip(playerObj, playerObj:getPrimaryHandItem(), playerInv:getFirstTypeRecurse("Lighter"), true, false)
    elseif playerObj:getInventory():containsTypeRecurse("Matches") then
      ISWorldObjectContextMenu.equip(playerObj, playerObj:getPrimaryHandItem(), playerInv:getFirstTypeRecurse("Matches"), true, false)
    end
    ISWorldObjectContextMenu.equip(playerObj, playerObj:getSecondaryHandItem(), playerInv:getFirstTypeEvalRecurse("PetrolCan", predicateNotEmpty), false, false)
    ISTimedActionQueue.add(ISBurnCorpseAction:new(playerObj, corpse, 110));
  end
end

function ISWorldObjectContextMenu.compareClothingBlood(item1, item2)
  return ISWashClothing.GetRequiredSoap(item1) < ISWashClothing.GetRequiredSoap(item2)
end

ISWorldObjectContextMenu.doWashClothingMenu = function(sink, player, context)
  local playerObj = getSpecificPlayer(player)
  local playerInv = playerObj:getInventory()
  local washYourself = false
  local washEquipment = false
  local washList = {}
  local soapList = {}
  local noSoap = true

  for i = 0, BloodBodyPartType.MAX:index() - 1 do
    if playerObj:getVisual():getBlood(BloodBodyPartType.FromIndex(i)) > 0 or playerObj:getVisual():getDirt(BloodBodyPartType.FromIndex(i)) > 0 then
      washYourself = true
      break
    end
  end

  local barList = playerInv:getItemsFromType("Soap2", true)
  for i = 0, barList:size() - 1 do
    local item = barList:get(i)
    table.insert(soapList, item)
  end

  local bottleList = playerInv:getItemsFromType("CleaningLiquid2", true)
  for i = 0, bottleList:size() - 1 do
    local item = bottleList:get(i)
    table.insert(soapList, item)
  end

  local clothingInventory = playerInv:getItemsFromCategory("Clothing")
  for i = 0, clothingInventory:size() - 1 do
    local item = clothingInventory:get(i)
    -- Wasn't able to reproduce the wash 'Blooo' bug, don't know the exact cause so here's a fix...
    if not item:isHidden() and (item:hasBlood() or item:hasDirt()) then
      if washEquipment == false then
        washEquipment = true
      end
      table.insert(washList, item)
    end
  end


  local weaponInventory = playerInv:getItemsFromCategory("Weapon")
  for i = 0, weaponInventory:size() - 1 do
    local item = weaponInventory:get(i)
    if item:hasBlood() then
      if washEquipment == false then
        washEquipment = true
      end
      table.insert(washList, item)
    end
  end
  -- Sort clothes from least-bloody to most-bloody.
  table.sort(washList, ISWorldObjectContextMenu.compareClothingBlood)

  if washYourself or washEquipment then
    local mainOption = context:addOption(getText("ContextMenu_Wash"), nil, nil);
    local mainSubMenu = ISContextMenu:getNew(context)
    context:addSubMenu(mainOption, mainSubMenu)

    --		if #soapList < 1 then
    --			mainOption.notAvailable = true;
    --			local tooltip = ISWorldObjectContextMenu.addToolTip();
    --			tooltip:setName("Need soap.");
    --			mainOption.toolTip = tooltip;
    --			return;
    --		end

    if washYourself then
      mainSubMenu:addOption(getText("ContextMenu_Yourself"), playerObj, ISWorldObjectContextMenu.onWashYourself, sink, soapList);
    end

    if washEquipment then
      local soapRemaining = ISWashClothing.GetSoapRemaining(soapList)
      local waterRemaining = sink:getWaterAmount()
      if #washList > 1 then
        local soapRequired = 0
        local waterRequired = 0
        for _, item in ipairs(washList) do
          soapRequired = soapRequired + ISWashClothing.GetRequiredSoap(item)
          waterRequired = waterRequired + ISWashClothing.GetRequiredWater(item)
        end
        local tooltip = ISWorldObjectContextMenu.addToolTip();
        --				tooltip:setName(getText("ContextMenu_NeedSoap"));
        if (soapRemaining < soapRequired) then
          tooltip.description = getText("IGUI_Washing_WithoutSoap") .. " <LINE> "
          noSoap = true;
        else
          tooltip.description = getText("IGUI_Washing_Soap") .. ": " .. tostring(math.min(soapRemaining, soapRequired)) .. " / " .. tostring(soapRequired) .. " <LINE> "
          noSoap = false;
        end
        tooltip.description = tooltip.description .. getText("ContextMenu_WaterName") .. ": " .. tostring(math.min(waterRemaining, waterRequired)) .. " / " .. tostring(waterRequired)
        local option = mainSubMenu:addOption(getText("ContextMenu_WashAllClothing"), playerObj, ISWorldObjectContextMenu.onWashClothing, sink, soapList, washList, nil, noSoap);
        option.toolTip = tooltip;
        if (waterRemaining < waterRequired) then
          option.notAvailable = true;
        end
      end
      for i, item in ipairs(washList) do
        local soapRequired = ISWashClothing.GetRequiredSoap(item)
        local waterRequired = ISWashClothing.GetRequiredWater(item)
        local tooltip = ISWorldObjectContextMenu.addToolTip();
        --				tooltip:setName(getText("ContextMenu_NeedSoap"));
        if (soapRemaining < soapRequired) then
          tooltip.description = getText("IGUI_Washing_WithoutSoap") .. " <LINE> "
          noSoap = true;
        else
          tooltip.description = getText("IGUI_Washing_Soap") .. ": " .. tostring(math.min(soapRemaining, soapRequired)) .. " / " .. tostring(soapRequired) .. " <LINE> "
          noSoap = false;
        end
        tooltip.description = tooltip.description .. getText("ContextMenu_WaterName") .. ": " .. tostring(math.min(waterRemaining, waterRequired)) .. " / " .. tostring(waterRequired)
        local option = mainSubMenu:addOption(getText("ContextMenu_WashClothing", item:getDisplayName()), playerObj, ISWorldObjectContextMenu.onWashClothing, sink, soapList, nil, item, noSoap);
        option.toolTip = tooltip;
        if (waterRemaining < waterRequired) then
          option.notAvailable = true;
        end
      end
    end
  end
end

ISWorldObjectContextMenu.onWashClothing = function(playerObj, sink, soapList, washList, singleClothing, noSoap)
  if not sink:getSquare() or not luautils.walkAdj(playerObj, sink:getSquare(), true) then
    return
  end

  if not washList then
    washList = {};
    table.insert(washList, singleClothing);
  end

  for i, item in ipairs(washList) do
    local bloodAmount = 0
    local dirtAmount = 0
    if instanceof(item, "Clothing") then
      if BloodClothingType.getCoveredParts(item:getBloodClothingType()) then
        local coveredParts = BloodClothingType.getCoveredParts(item:getBloodClothingType())
        for j = 0, coveredParts:size() - 1 do
          local thisPart = coveredParts:get(j)
          bloodAmount = bloodAmount + item:getBlood(thisPart)
        end
      end
      if item:getDirtyness() > 0 then
        dirtAmount = dirtAmount + item:getDirtyness()
      end
    else
      bloodAmount = bloodAmount + item:getBloodLevel()
    end
    ISTimedActionQueue.add(ISWashClothing:new(playerObj, sink, soapList, item, bloodAmount, dirtAmount, noSoap))
  end
end

ISWorldObjectContextMenu.onWashYourself = function(playerObj, sink, soapList)
  if not sink:getSquare() or not luautils.walkAdj(playerObj, sink:getSquare(), true) then
    return
  end

  ISTimedActionQueue.add(ISWashYourself:new(playerObj, sink, soapList));
end

ISWorldObjectContextMenu.onDrink = function(worldobjects, waterObject, player)
  local playerObj = getSpecificPlayer(player)
  if not waterObject:getSquare() or not luautils.walkAdj(playerObj, waterObject:getSquare(), true) then
    return
  end
  local waterAvailable = waterObject:getWaterAmount()
  local waterNeeded = math.min(math.ceil(playerObj:getStats():getThirst() * 10), 10)
  local waterConsumed = math.min(waterNeeded, waterAvailable)
  ISTimedActionQueue.add(ISTakeWaterAction:new(playerObj, nil, waterConsumed, waterObject, (waterConsumed * 10) + 15));
end

ISWorldObjectContextMenu.onTakeWater = function(worldobjects, waterObject, waterContainer, player)
  local playerObj = getSpecificPlayer(player)
  local playerInv = playerObj:getInventory()
  local waterAvailable = waterObject:getWaterAmount()
  -- first case, fill an empty bottle
  if waterContainer:canStoreWater() and not waterContainer:isWaterSource() then
    if not waterObject:getSquare() or not luautils.walkAdj(playerObj, waterObject:getSquare(), true) then
      return
    end
    -- we create the item wich contain our water
    -- Probably we shouldn't create the new empty item in case ISTakeWaterAction() never happens.
    local newItem = waterObject:replaceItem(waterContainer);
    -- we empty it, so we gonna start to fill it in the timed action
    newItem:setUsedDelta(0);
    local returnToContainer = newItem:getContainer():isInCharacterInventory(playerObj) and newItem:getContainer()
    --        ISWorldObjectContextMenu.equip(playerObj, playerObj:getPrimaryHandItem(), newItem, true)
    ISWorldObjectContextMenu.transferIfNeeded(playerObj, newItem)
    local destCapacity = 1 / newItem:getUseDelta()
    local waterConsumed = math.min(math.floor(destCapacity + 0.001), waterAvailable)
    ISTimedActionQueue.add(ISTakeWaterAction:new(playerObj, newItem, waterConsumed, waterObject, waterConsumed * 10));
    if returnToContainer and (returnToContainer ~= playerInv) then
      ISTimedActionQueue.add(ISInventoryTransferAction:new(playerObj, newItem, playerInv, returnToContainer))
    end
  elseif waterContainer:canStoreWater() and waterContainer:isWaterSource() then -- second case, a bottle contain some water, we just fill it
    if not waterObject:getSquare() or not luautils.walkAdj(playerObj, waterObject:getSquare(), true) then
      return
    end
    local returnToContainer = waterContainer:getContainer():isInCharacterInventory(playerObj) and waterContainer:getContainer()
    if playerObj:getPrimaryHandItem() ~= waterContainer and playerObj:getSecondaryHandItem() ~= waterContainer then
      --			ISWorldObjectContextMenu.equip(playerObj, playerObj:getPrimaryHandItem(), waterContainer, true)
    end
    ISWorldObjectContextMenu.transferIfNeeded(playerObj, waterContainer)
    local destCapacity = (1 - waterContainer:getUsedDelta()) / waterContainer:getUseDelta()
    local waterConsumed = math.min(math.floor(destCapacity + 0.001), waterAvailable)
    ISTimedActionQueue.add(ISTakeWaterAction:new(playerObj, waterContainer, waterConsumed, waterObject, waterConsumed * 10));
    if returnToContainer then
      ISTimedActionQueue.add(ISInventoryTransferAction:new(playerObj, waterContainer, playerInv, returnToContainer))
    end
  end
end

ISWorldObjectContextMenu.onAddWaterFromItem = function(worldobjects, waterObject, waterItem, playerObj)
  if not luautils.walkAdj(playerObj, waterObject:getSquare(), true) then return end
  if waterItem:canStoreWater() and waterItem:isWaterSource() then
    ISWorldObjectContextMenu.equip(playerObj, playerObj:getPrimaryHandItem(), waterItem, true)
    ISTimedActionQueue.add(ISAddWaterFromItemAction:new(playerObj, waterItem, waterObject))
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
    if playerObj:getInventory():containsTypeEvalRecurse("Hammer", predicateNotBroken) then
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
    ISWorldObjectContextMenu.equip(playerObj, playerObj:getPrimaryHandItem(), predicateBlowTorch, true);
    ISTimedActionQueue.add(ISUnbarricadeAction:new(playerObj, window, 120));
  end
end

ISWorldObjectContextMenu.onUnbarricadeMetalBar = function(worldobjects, window, player)
  local playerObj = getSpecificPlayer(player)
  if luautils.walkAdjWindowOrDoor(playerObj, window:getSquare(), window) then
    ISWorldObjectContextMenu.equip(playerObj, playerObj:getPrimaryHandItem(), predicateBlowTorch, true);
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
  if playerObj:getInventory():getItemCountRecurse("Base.MetalBar") < 3 then return end
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
      ISWorldObjectContextMenu.equip(playerObj, playerObj:getPrimaryHandItem(), predicateBlowTorch, true);
      ISWorldObjectContextMenu.equip(playerObj, playerObj:getSecondaryHandItem(), "MetalBar", false);

      ISTimedActionQueue.add(ISWalkToTimedAction:new(playerObj, adjacent));
      ISTimedActionQueue.add(ISBarricadeAction:new(playerObj, window, false, true, (170 - (playerObj:getPerkLevel(Perks.MetalWelding) * 5))));
      return;
    else
      return;
    end
  else
    ISWorldObjectContextMenu.equip(playerObj, playerObj:getPrimaryHandItem(), predicateBlowTorch, true);
    ISWorldObjectContextMenu.equip(playerObj, playerObj:getSecondaryHandItem(), "MetalBar", false);
    ISTimedActionQueue.add(ISBarricadeAction:new(playerObj, window, false, true, (170 - (playerObj:getPerkLevel(Perks.MetalWelding) * 5))));
  end
end

ISWorldObjectContextMenu.onMetalBarricade = function(worldobjects, window, player)
  local playerObj = getSpecificPlayer(player)
  -- we must check these otherwise ISEquipWeaponAction will get a null item
  if not playerObj:getInventory():containsTypeRecurse("SheetMetal") then return end
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
      ISWorldObjectContextMenu.equip(playerObj, playerObj:getPrimaryHandItem(), predicateBlowTorch, true);
      ISWorldObjectContextMenu.equip(playerObj, playerObj:getSecondaryHandItem(), "SheetMetal", false);

      ISTimedActionQueue.add(ISWalkToTimedAction:new(playerObj, adjacent));
      ISTimedActionQueue.add(ISBarricadeAction:new(playerObj, window, true, false, (170 - (playerObj:getPerkLevel(Perks.MetalWelding) * 5))));
      return;
    else
      return;
    end
  else
    ISWorldObjectContextMenu.equip(playerObj, playerObj:getPrimaryHandItem(), predicateBlowTorch, true);
    ISWorldObjectContextMenu.equip(playerObj, playerObj:getSecondaryHandItem(), "SheetMetal", false);
    ISTimedActionQueue.add(ISBarricadeAction:new(playerObj, window, true, false, (170 - (playerObj:getPerkLevel(Perks.MetalWelding) * 5))));
  end
end

ISWorldObjectContextMenu.onBarricade = function(worldobjects, window, player)
  local playerObj = getSpecificPlayer(player)
  local playerInv = playerObj:getInventory()
  -- we must check these otherwise ISEquipWeaponAction will get a null item
  local hammer = playerInv:getFirstTypeEvalRecurse("Hammer", predicateNotBroken) or playerInv:getFirstTypeEvalRecurse("HammerStone", predicateNotBroken)
  if not hammer then return end
  if not playerInv:containsTypeRecurse("Plank") then return end
  if playerInv:getItemCountRecurse("Base.Nails") < 2 then return end
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
      ISWorldObjectContextMenu.equip(playerObj, playerObj:getPrimaryHandItem(), hammer, true);
      ISWorldObjectContextMenu.equip(playerObj, playerObj:getSecondaryHandItem(), "Plank", false);
      ISTimedActionQueue.add(ISWalkToTimedAction:new(playerObj, adjacent));
      ISTimedActionQueue.add(ISBarricadeAction:new(playerObj, window, false, false, (100 - (playerObj:getPerkLevel(Perks.Woodwork) * 5))));
      return;
    else
      return;
    end
  else
    ISWorldObjectContextMenu.equip(playerObj, playerObj:getPrimaryHandItem(), hammer, true);
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
  local playerInv = playerObj:getInventory()
  local square = window:getAddSheetSquare(playerObj)
  local sheet = playerInv:getFirstTypeRecurse("Sheet")
  if not sheet then return end
  if square and square:isFree(false) then
    local action = ISWalkToTimedAction:new(playerObj, square)
    if instanceof(window, "IsoDoor") then
      action:setOnComplete(ISWorldObjectContextMenu.restoreDoor, playerObj, window, window:IsOpen())
    end
    ISTimedActionQueue.add(action)
    ISWorldObjectContextMenu.transferIfNeeded(playerObj, sheet)
    ISTimedActionQueue.add(ISAddSheetAction:new(playerObj, window, 50));
  elseif luautils.walkAdjWindowOrDoor(playerObj, window:getSquare(), window) then
    if instanceof(window, "IsoDoor") then return end
    ISWorldObjectContextMenu.transferIfNeeded(playerObj, sheet)
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
  if (not playerObj:isBlockMovement()) then
    if luautils.walkAdjWindowOrDoor(playerObj, square, window) then
      ISTimedActionQueue.add(ISOpenCloseWindow:new(playerObj, window, 0));
    end
  end
end

ISWorldObjectContextMenu.onAddSheetRope = function(worldobjects, window, player)
  local playerObj = getSpecificPlayer(player)
  local playerInv = playerObj:getInventory()
  if luautils.walkAdjWindowOrDoor(playerObj, window:getSquare(), window) then
    local numRequired = 0
    if IsoWindowFrame.isWindowFrame(window) then
      numRequired = IsoWindowFrame.countAddSheetRope(window)
    else
      numRequired = window:countAddSheetRope()
    end
    local items = playerInv:getSomeTypeRecurse("SheetRope", numRequired)
    if items:size() < numRequired then
      items = playerInv:getSomeTypeRecurse("Rope", numRequired)
    end
    if items:size() < numRequired then return end
    local nail = playerInv:getFirstTypeRecurse("Nails")
    if not nail then return end
    ISWorldObjectContextMenu.transferIfNeeded(playerObj, nail)
    for i = 1, numRequired do
      ISWorldObjectContextMenu.transferIfNeeded(playerObj, items:get(i - 1))
    end
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
  local north = false
  if IsoWindowFrame.isWindowFrame(window) then
    north = window:getProperties():Is(IsoFlagType.WindowN)
  else
    north = window:getNorth()
  end
  if north and sq:getX() == sq:getX() and (sq:getY() == sq2:getY() - 1 or sq:getY() == sq2:getY()) then
    return true
  end
  if not north and sq:getY() == sq:getY() and (sq:getX() == sq2:getX() - 1 or sq:getX() == sq2:getX()) then
    return true
  end
  return false
end

ISWorldObjectContextMenu.onClimbOverFence = function(worldobjects, fence, player)
  local playerObj = getSpecificPlayer(player)
  local square = fence:getSquare()
  if luautils.walkAdjWindowOrDoor(playerObj, square, fence) then
    ISTimedActionQueue.add(ISClimbOverFence:new(playerObj, fence))
  end
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
ISWorldObjectContextMenu.onPickupBrokenGlass = function(worldobjects, brokenGlass, player)
  local playerObj = getSpecificPlayer(player)
  if luautils.walkAdj(playerObj, brokenGlass:getSquare()) then
    ISTimedActionQueue.add(ISPickupBrokenGlass:new(playerObj, brokenGlass, 100));
  end
end
ISWorldObjectContextMenu.onOpenCloseDoor = function(worldobjects, door, player)
  local playerObj = getSpecificPlayer(player)
  if luautils.walkAdjWindowOrDoor(playerObj, door:getSquare(), door) then
    ISTimedActionQueue.add(ISOpenCloseDoor:new(playerObj, door, 0));
  end
end

function ISWorldObjectContextMenu.canCleanBlood(playerObj, square)
  local playerInv = playerObj:getInventory()
  return square ~= nil and square:haveBlood() and playerInv:containsTypeRecurse("Bleach") and
  (playerInv:containsTypeRecurse("BathTowel") or playerInv:containsTypeRecurse("DishCloth") or
  playerInv:containsTypeRecurse("Mop") or playerInv:containsTypeEvalRecurse("Broom", predicateNotBroken))
end

function ISWorldObjectContextMenu.onCleanBlood(worldobjects, square, player)
  local playerObj = getSpecificPlayer(player)
  local bo = ISCleanBloodCursor:new("", "", playerObj)
  getCell():setDrag(bo, playerObj:getPlayerNum())
end

function ISWorldObjectContextMenu.doCleanBlood(playerObj, square)
  local player = playerObj:getPlayerNum()
  local playerInv = playerObj:getInventory()
  if luautils.walkAdj(playerObj, square) then
    local item = playerInv:getFirstTypeRecurse("Mop") or
    playerInv:getFirstTypeEvalRecurse("Broom", predicateNotBroken) or
    playerInv:getFirstTypeRecurse("DishCloth") or
    playerInv:getFirstTypeRecurse("BathTowel");
    local bleach = playerInv:getFirstTypeRecurse("Bleach");
    ISWorldObjectContextMenu.transferIfNeeded(playerObj, item)
    ISWorldObjectContextMenu.transferIfNeeded(playerObj, bleach)
    -- dish clothes will be doing a low animation
    if item:getType() == "DishCloth" or item:getType() == "BathTowel" then
      ISInventoryPaneContextMenu.equipWeapon(item, true, false, player)
      ISInventoryPaneContextMenu.equipWeapon(bleach, false, false, player)
    else -- broom/mop equipped in both hands
      ISInventoryPaneContextMenu.equipWeapon(item, true, true, player)
    end
    ISTimedActionQueue.add(ISCleanBlood:new(playerObj, square, 150));
  end
end

ISWorldObjectContextMenu.onRemoveTree = function(worldobjects, square, wallVine, player)
  local playerObj = getSpecificPlayer(player);
  local playerInv = playerObj:getInventory()
  if wallVine then
    ISTimedActionQueue.add(ISWalkToTimedAction:new(playerObj, square))
  else
    if not luautils.walkAdj(playerObj, square) then return end
  end
  local handItem = playerObj:getPrimaryHandItem()
  if not handItem or not predicateCuttingTool(handItem) then
    for _, type in ipairs(CuttingToolTypes) do
      handItem = playerInv:getFirstTypeEvalRecurse(type, predicateNotBroken)
      if handItem then
        ISWorldObjectContextMenu.equip(playerObj, playerObj:getPrimaryHandItem(), handItem, true)
        break
      end
    end
  end
  ISTimedActionQueue.add(ISRemoveBush:new(playerObj, square, wallVine));
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
  local parent = item:getSquare()
  local adjacent = AdjacentFreeTileFinder.Find(parent, playerObj)
  if instanceof(item, "IsoWindow") or instanceof(item, "IsoDoor") then
    adjacent = AdjacentFreeTileFinder.FindWindowOrDoor(parent, item, playerObj)
  end
  if adjacent ~= nil then
    ISTimedActionQueue.add(ISWalkToTimedAction:new(getSpecificPlayer(player), adjacent))
  end
end

ISWorldObjectContextMenu.onWalkTo = function(worldobjects, item, playerNum)
  local playerObj = getSpecificPlayer(playerNum)
  local bo = ISWalkToCursor:new("", "", playerObj)
  getCell():setDrag(bo, playerNum)
end

function ISWorldObjectContextMenu.transferIfNeeded(playerObj, item)
  if luautils.haveToBeTransfered(playerObj, item) then
    ISTimedActionQueue.add(ISInventoryTransferAction:new(playerObj, item, item:getContainer(), playerObj:getInventory()))
  end
end

-- we equip the item before if it's not equiped before using it
ISWorldObjectContextMenu.equip = function(playerObj, handItem, item, primary, twoHands)
  if type(item) == "function" then
    local predicate = item
    if not handItem or not predicate(handItem) then
      handItem = playerObj:getInventory():getFirstEvalRecurse(predicate)
      if handItem then
        ISWorldObjectContextMenu.transferIfNeeded(playerObj, handItem)
        ISTimedActionQueue.add(ISEquipWeaponAction:new(playerObj, handItem, 50, primary, twoHands))
      end
    end
    return handItem
  end
  if instanceof(item, "InventoryItem") then
    if handItem ~= item then
      handItem = item
      ISWorldObjectContextMenu.transferIfNeeded(playerObj, handItem)
      ISTimedActionQueue.add(ISEquipWeaponAction:new(playerObj, handItem, 50, primary, twoHands))
    end
    return handItem
  end
  if not handItem or handItem:getType() ~= item then
    handItem = playerObj:getInventory():getFirstTypeEvalRecurse(item, predicateNotBroken);
    if handItem then
      ISWorldObjectContextMenu.transferIfNeeded(playerObj, handItem)
      ISTimedActionQueue.add(ISEquipWeaponAction:new(playerObj, handItem, 50, primary, twoHands))
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
  return chr:getInventory():containsEvalRecurse(predicateBlowTorch)
end

ISWorldObjectContextMenu.doSleepOption = function(context, bed, player, playerObj)
  local sleepOption = context:addOption(getText("ContextMenu_Sleep"), bed, ISWorldObjectContextMenu.onSleep, player);
  -- Not tired enough
  local sleepNeeded = not isClient() or getServerOptions():getBoolean("SleepNeeded")
  if sleepNeeded and playerObj:getStats():getFatigue() <= 0.3 then
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
    elseif sleepNeeded and (playerObj:getHoursSurvived() - playerObj:getLastHourSleeped()) <= 1 then
      sleepOption.notAvailable = true;
      local sleepTooltip = ISWorldObjectContextMenu.addToolTip();
      sleepTooltip:setName(getText("ContextMenu_Sleeping"));
      sleepTooltip.description = getText("ContextMenu_NoSleepTooEarly");
      sleepOption.toolTip = sleepTooltip;
    end
  end
end

ISWorldObjectContextMenu.onDigGraves = function(worldobjects, player, shovel)
  local bo = ISEmptyGraves:new("location_community_cemetary_01_33", "location_community_cemetary_01_32", "location_community_cemetary_01_34", "location_community_cemetary_01_35", shovel);
  bo.player = player;
  getCell():setDrag(bo, bo.player);
end

ISWorldObjectContextMenu.onBuryCorpse = function(grave, player, shovel)
  local playerObj = getSpecificPlayer(player)
  if luautils.walkAdj(playerObj, grave:getSquare()) then
    -- We can't equip the shovel because that will drop the corpse.
    --		ISInventoryPaneContextMenu.equipWeapon(shovel, true, true, player)
    ISInventoryPaneContextMenu.transferIfNeeded(playerObj, shovel)
    ISTimedActionQueue.add(ISBuryCorpse:new(player, grave, 80, shovel));
  end
end

ISWorldObjectContextMenu.onFillGrave = function(grave, player, shovel)
  if luautils.walkAdj(getSpecificPlayer(player), grave:getSquare()) then
    ISInventoryPaneContextMenu.equipWeapon(shovel, true, true, player)
    ISTimedActionQueue.add(ISFillGrave:new(player, grave, 150, shovel));
  end
end

ISWorldObjectContextMenu.onSitOnGround = function(player)
  getSpecificPlayer(player):reportEvent("EventSitOnGround");
end
