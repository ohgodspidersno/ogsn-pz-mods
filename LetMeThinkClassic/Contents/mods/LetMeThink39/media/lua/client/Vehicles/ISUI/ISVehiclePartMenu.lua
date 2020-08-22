--***********************************************************
--**                    THE INDIE STONE                    **
--***********************************************************

ISVehiclePartMenu = {}

function ISVehiclePartMenu.create(playerNum, part, x, y)
  local playerObj = getSpecificPlayer(playerNum)

  local context = ISContextMenu.get(playerNum, x, y)
  local option = nil

  if part:getItemType() then
    if part:getInventoryItem() then
      option = context:addOption("Uninstall", playerObj, ISVehiclePartMenu.onUninstallPart, part)
      if not part:getVehicle():canUninstallPart(playerObj, part) then
        option.notAvailable = true
      end
    else
      option = context:addOption("Install", playerObj, ISVehiclePartMenu.onInstallPart, part)
      if not part:getVehicle():canInstallPart(playerObj, part) then
        option.notAvailable = true
      end
    end
  end

  local typeToItem = VehicleUtils.getItems(playerObj:getPlayerNum())

  if part:isContainer() and part:getContainerContentType() == "Gasoline" then
    local square = ISVehiclePartMenu.getNearbyFuelPump(part:getVehicle())
    if square then
      option = context:addOption("Refuel From Gas Pump", playerObj, ISVehiclePartMenu.onPumpGasoline, part)
      if part:getContainerContentAmount() >= part:getContainerCapacity() then
        option.notAvailable = true
      end
    end

    -- TODO: how much to add, choose item to use
    option = context:addOption("Add Gasoline", playerObj, ISVehiclePartMenu.onAddGasoline, part)
    if not typeToItem["Base.PetrolCan"] or part:getContainerContentAmount() >= part:getContainerCapacity() then
      option.notAvailable = true
    end

    option = context:addOption("Take Gasoline", playerObj, ISVehiclePartMenu.onTakeGasoline, part)
    if not ISVehiclePartMenu.getGasCanNotFull(typeToItem) or part:getContainerContentAmount() == 0 then
      option.notAvailable = true
    end

    option = context:addOption("DBG: Fill", playerObj, ISVehiclePartMenu.onDebugFill, part)
  end

  -- max pressure stamped on tire
  -- recommended pressure listed on door / owner's manual
  if part:isContainer() and part:getContainerContentType() == "Air" and part:getInventoryItem() then
    option = context:addOption("Inflate Tire", playerObj, ISVehiclePartMenu.onInflateTire, part)
    if part:getContainerContentAmount() >= part:getContainerCapacity() then
      option.notAvailable = true
    end
    option = context:addOption("Deflate Tire", playerObj, ISVehiclePartMenu.onDeflateTire, part)
    if part:getContainerContentAmount() == 0 then
      option.notAvailable = true
    end
  end

  if part:getDeviceData() then
    option = context:addOption(getText("IGUI_DeviceOptions"), playerObj, ISVehiclePartMenu.onDeviceOptions, part)
  end

  if part:getDoor() then
    local door = part:getDoor()
    if door:isLocked() then
      option = context:addOption(getText("ContextMenu_UnlockDoor"), playerObj, ISVehiclePartMenu.onUnlockDoor, part)
    else
      option = context:addOption(getText("ContextMenu_LockDoor"), playerObj, ISVehiclePartMenu.onLockDoor, part)
    end
  end

  if part:getWindow() and (not part:getItemType() or part:getInventoryItem()) then
    local window = part:getWindow()
    if window:isOpenable() and not window:isDestroyed() then
      if window:isOpen() then
        option = context:addOption(getText("ContextMenu_Close_window"), playerObj, ISVehiclePartMenu.onOpenCloseWindow, part, false)
      else
        option = context:addOption(getText("ContextMenu_Open_window"), playerObj, ISVehiclePartMenu.onOpenCloseWindow, part, true)
      end
    end
    if not window:isDestroyed() then
      option = context:addOption(getText("ContextMenu_Smash_window"), playerObj, ISVehiclePartMenu.onSmashWindow, part)
    end
  end

  if context.numOptions == 1 then
    context:setVisible(false)
  else
    if JoypadState.players[playerNum + 1] then
      context.mouseOver = 1
      context.origin = getPlayerVehicleUI(playerNum)
      JoypadState.players[playerNum + 1].focus = context
      updateJoypadFocus(JoypadState.players[playerNum + 1])
    end
  end
end

function ISVehiclePartMenu.getNearbyFuelPump(vehicle)
  local part = vehicle:getPartById("GasTank")
  if not part then return nil end
  local areaCenter = vehicle:getAreaCenter(part:getArea())
  if not areaCenter then return nil end
  local square = getCell():getGridSquare(areaCenter:getX(), areaCenter:getY(), vehicle:getZ())
  if not square then return nil end
  for dy = -2, 2 do
    for dx = -2, 2 do
      -- TODO: check line-of-sight between 2 squares
      local square2 = getCell():getGridSquare(square:getX() + dx, square:getY() + dy, square:getZ())
      if square2 and square2:getProperties():Is("fuelAmount") and tonumber(square2:getProperties():Val("fuelAmount")) > 0 then
        return square2
      end
    end
  end
end

function ISVehiclePartMenu.getGasCanNotEmpty(typeToItem)
  if typeToItem["Base.PetrolCan"] then
    for _, item in ipairs(typeToItem["Base.PetrolCan"]) do
      if item:getUsedDelta() > 0 then
        return item
      end
    end
  end
  return nil
end

function ISVehiclePartMenu.getGasCanNotFull(typeToItem)
  if typeToItem["Base.EmptyPetrolCan"] then
    return typeToItem["Base.EmptyPetrolCan"][1]
  elseif typeToItem["Base.PetrolCan"] then
    for _, item in ipairs(typeToItem["Base.PetrolCan"]) do
      if item:getUsedDelta() < 1 then
        return item
      end
    end
  end
  return nil
end

function ISVehiclePartMenu.toPlayerInventory(playerObj, item)
  if item and item:getContainer() and item:getContainer() ~= playerObj:getInventory() then
    local action = ISInventoryTransferAction:new(playerObj, item, item:getContainer(), playerObj:getInventory())
    ISTimedActionQueue.add(action)
  end
end

function ISVehiclePartMenu.transferRequiredItems(playerObj, part, tbl)
  if tbl and tbl.items then
    local typeToItem = VehicleUtils.getItems(playerObj:getPlayerNum())
    for _, item in pairs(tbl.items) do
      -- FIXME: handle drainables
      for i = 1, tonumber(item.count) do
        ISVehiclePartMenu.toPlayerInventory(playerObj, typeToItem[item.type][i])
      end
    end
  end
end

function ISVehiclePartMenu.equipRequiredItems(playerObj, part, tbl)
  if tbl and tbl.items then
    for _, item in pairs(tbl.items) do
      local module, type = VehicleUtils.split(item.type, "\\.")
      type = type or item.type -- in case item.type has no '.'
      if item.equip == "primary" then
        ISWorldObjectContextMenu.equip(playerObj, playerObj:getPrimaryHandItem(), type, true)
      elseif item.equip == "secondary" then
        ISWorldObjectContextMenu.equip(playerObj, playerObj:getSecondaryHandItem(), type, false)
      elseif item.equip == "both" then
        ISWorldObjectContextMenu.equip(playerObj, playerObj:getPrimaryHandItem(), type, false, true)
      end
    end
  end
end

function ISVehiclePartMenu.onInstallPart(playerObj, part, item)
  if not ISVehicleMechanics.cheat then
    if playerObj:getVehicle() then
      ISVehicleMenu.onExit(playerObj)
    end

    ISVehiclePartMenu.toPlayerInventory(playerObj, item)

    local tbl = part:getTable("install")
    ISVehiclePartMenu.transferRequiredItems(playerObj, part, tbl)

    local area = tbl.area or part:getArea()
    ISTimedActionQueue.add(ISPathFindAction:pathToVehicleArea(playerObj, part:getVehicle(), area))

    ISVehiclePartMenu.equipRequiredItems(playerObj, part, tbl)
  end

  -- Open the engine cover if needed
  -- TODO: pop hood inside vehicle?
  local engineCover = nil
  local keyvalues = part:getTable("install")
  if keyvalues.door then
    local doorPart = part:getVehicle():getPartById(keyvalues.door)
    if doorPart and doorPart:getDoor() and doorPart:getInventoryItem() and not doorPart:getDoor():isOpen() then
      engineCover = doorPart
    end
  end

  local time = tonumber(keyvalues.time) or 50
  if engineCover then
    ISTimedActionQueue.add(ISOpenVehicleDoor:new(playerObj, part:getVehicle(), engineCover))
    ISTimedActionQueue.add(ISInstallVehiclePart:new(playerObj, part, item, time))
    ISTimedActionQueue.add(ISCloseVehicleDoor:new(playerObj, part:getVehicle(), engineCover))
  else
    ISTimedActionQueue.add(ISInstallVehiclePart:new(playerObj, part, item, time))
  end
end

function ISVehiclePartMenu.onUninstallPart(playerObj, part)
  if not ISVehicleMechanics.cheat then
    if playerObj:getVehicle() then
      ISVehicleMenu.onExit(playerObj)
    end
    local tbl = part:getTable("uninstall")
    ISVehiclePartMenu.transferRequiredItems(playerObj, part, tbl)

    local area = tbl.area or part:getArea()
    ISTimedActionQueue.add(ISPathFindAction:pathToVehicleArea(playerObj, part:getVehicle(), area))

    ISVehiclePartMenu.equipRequiredItems(playerObj, part, tbl)
  end
  -- Open the engine cover if needed
  -- TODO: pop hood inside vehicle?
  local engineCover = nil;
  local keyvalues = part:getTable("install")
  if keyvalues.door then
    local doorPart = part:getVehicle():getPartById(keyvalues.door)
    if doorPart and doorPart:getDoor() and doorPart:getInventoryItem() and not doorPart:getDoor():isOpen() then
      engineCover = doorPart
    end
  end
  local time = tonumber(keyvalues.time) or 50
  if engineCover then
    ISTimedActionQueue.add(ISOpenVehicleDoor:new(playerObj, part:getVehicle(), engineCover))
    ISTimedActionQueue.add(ISUninstallVehiclePart:new(playerObj, part, time))
    ISTimedActionQueue.add(ISCloseVehicleDoor:new(playerObj, part:getVehicle(), engineCover))
  else
    ISTimedActionQueue.add(ISUninstallVehiclePart:new(playerObj, part, time))
  end
end

function ISVehiclePartMenu.onPumpGasoline(playerObj, part)
  if playerObj:getVehicle() then
    ISVehicleMenu.onExit(playerObj)
  end
  local square = ISVehiclePartMenu.getNearbyFuelPump(part:getVehicle())
  if square then
    ISTimedActionQueue.add(ISPathFindAction:pathToVehicleArea(playerObj, part:getVehicle(), part:getArea()))
    ISTimedActionQueue.add(ISRefuelFromGasPump:new(playerObj, part, square, 100))
  end
end

function ISVehiclePartMenu.onAddGasoline(playerObj, part)
  if playerObj:getVehicle() then
    ISVehicleMenu.onExit(playerObj)
  end
  local typeToItem = VehicleUtils.getItems(playerObj:getPlayerNum())
  local item = ISVehiclePartMenu.getGasCanNotEmpty(typeToItem)
  if item then
    ISVehiclePartMenu.toPlayerInventory(playerObj, item)
    ISTimedActionQueue.add(ISPathFindAction:pathToVehicleArea(playerObj, part:getVehicle(), part:getArea()))
    ISTimedActionQueue.add(ISAddGasolineToVehicle:new(playerObj, part, item, 50))
  end
end

function ISVehiclePartMenu.onTakeGasoline(playerObj, part)
  if playerObj:getVehicle() then
    ISVehicleMenu.onExit(playerObj)
  end
  local typeToItem = VehicleUtils.getItems(playerObj:getPlayerNum())
  local item = ISVehiclePartMenu.getGasCanNotFull(typeToItem)
  if item then
    ISVehiclePartMenu.toPlayerInventory(playerObj, item)
    ISTimedActionQueue.add(ISPathFindAction:pathToVehicleArea(playerObj, part:getVehicle(), part:getArea()))
    ISTimedActionQueue.add(ISTakeGasolineFromVehicle:new(playerObj, part, item, 50))
  end
end

function ISVehiclePartMenu.onDebugFill(playerObj, part)
  part:setContainerContentAmount(part:getContainerCapacity())
end

function ISVehiclePartMenu.onInflateTire(playerObj, part)
  if not playerObj:getInventory():contains("TirePump", true) then return end
  if playerObj:getVehicle() then
    ISVehicleMenu.onExit(playerObj)
  end
  -- TODO: choose desired tire pressure (underinflated - recommended - max)
  ISTimedActionQueue.add(ISPathFindAction:pathToVehicleArea(playerObj, part:getVehicle(), part:getArea()))
  local pump = ISWorldObjectContextMenu.equip(playerObj, playerObj:getPrimaryHandItem(), "TirePump", true)
  ISTimedActionQueue.add(ISInflateTire:new(playerObj, part, pump, part:getContainerCapacity() + 5, (part:getContainerCapacity()) * 50))
end

function ISVehiclePartMenu.onDeflateTire(playerObj, part)
  if playerObj:getVehicle() then
    ISVehicleMenu.onExit(playerObj)
  end
  -- TODO: choose desired tire pressure (underinflated - recommended - max)
  ISTimedActionQueue.add(ISPathFindAction:pathToVehicleArea(playerObj, part:getVehicle(), part:getArea()))
  ISTimedActionQueue.add(ISDeflateTire:new(playerObj, part, 0, (part:getContainerContentAmount() - 0) * 50))
end

function ISVehiclePartMenu.onDeviceOptions(playerObj, part)
  if playerObj:getVehicle() ~= part:getVehicle() then
    if playerObj:getVehicle() then
      ISVehicleMenu.onExit(playerObj)
    end
    -- TODO: walk to vehicle and enter it
  end
  ISRadioWindow.activate(playerObj, part)
end

function ISVehiclePartMenu.onLockDoor(playerObj, part)
  if playerObj:getVehicle() ~= part:getVehicle() then
    if playerObj:getVehicle() then
      ISVehicleMenu.onExit(playerObj)
    end
  end
  -- TODO: check key
  -- TODO: walk to door
  ISTimedActionQueue.add(ISLockVehicleDoor:new(playerObj, part))
end

function ISVehiclePartMenu.onUnlockDoor(playerObj, part)
  if playerObj:getVehicle() ~= part:getVehicle() then
    if playerObj:getVehicle() then
      ISVehicleMenu.onExit(playerObj)
    end
  end
  -- TODO: check key
  -- TODO: walk to door
  ISTimedActionQueue.add(ISUnlockVehicleDoor:new(playerObj, part))
end

function ISVehiclePartMenu.onOpenCloseWindow(playerObj, part, open)
  -- get seat to sit in to operate this window
  -- if seat occupied, fail
  -- if entrace blocked, find another seat we can sit it that can switch to the desired seat
  -- possibly allow operting window from outside, by opening the door first
  if playerObj:getVehicle() ~= part:getVehicle() then
    if playerObj:getVehicle() then
      ISVehicleMenu.onExit(playerObj)
    end
  end
  ISTimedActionQueue.add(ISOpenCloseVehicleWindow:new(playerObj, part, open, 50))
end


function ISVehiclePartMenu.onLockDoors(playerObj, vehicle, lock)
  if playerObj:getInventory():haveThisKeyId(vehicle:getKeyId()) or vehicle:isEngineRunning() then
    ISTimedActionQueue.add(ISLockDoors:new(playerObj, vehicle, lock, 10))
  end
end

function ISVehiclePartMenu.onSmashWindow(playerObj, part, open)
  if playerObj:getVehicle() == part:getVehicle() then
    -- if in vehicle, must be in the seat
  else
    if playerObj:getVehicle() then
      ISVehicleMenu.onExit(playerObj)
    end
    ISTimedActionQueue.add(ISPathFindAction:pathToVehicleArea(playerObj, part:getVehicle(), part:getArea()))
  end

  ISTimedActionQueue.add(ISSmashVehicleWindow:new(playerObj, part))
end
