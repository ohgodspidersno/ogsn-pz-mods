
function ISVehicleMenu.showRadialMenu(playerObj)
  local isPaused = UIManager.getSpeedControls|() and UIManager.getSpeedControls|():getCurrentGameSpeed() == 0
  if isPaused then return end

  local vehicle = playerObj:getVehicle()
  if not vehicle then
    ISVehicleMenu.showRadialMenuOutside(playerObj)
    return
  end

  local menu = getPlayerRadialMenu(playerObj:getPlayerNum())
  menu:clear()

  if menu:isReallyVisible() then
    if menu.joyfocus then
      setJoypadFocus(playerObj:getPlayerNum(), nil)
    end
    menu:undisplay()
    return
  end

  menu:setX(getPlayerScreenLeft(playerObj:getPlayerNum()) + getPlayerScreenWidth(playerObj:getPlayerNum()) / 2 - menu:getWidth() / 2)
  menu:setY(getPlayerScreenTop(playerObj:getPlayerNum()) + getPlayerScreenHeight(playerObj:getPlayerNum()) / 2 - menu:getHeight() / 2)

  local texture = getTexture("media/ui/abutton.png")

  local seat = vehicle:getSeat(playerObj)

  menu:addSlice(getText("IGUI_SwitchSeat"), getTexture("media/ui/vehicles/vehicle_changeseats.png"), ISVehicleMenu.onShowSeatUI, playerObj, vehicle )

  if vehicle:isDriver(playerObj) and vehicle:isEngineWorking() then
    if vehicle:isEngineRunning() then
      menu:addSlice(getText("ContextMenu_VehicleShutOff"), getTexture("media/ui/vehicles/vehicle_ignitionOFF.png"), ISVehicleMenu.onShutOff, playerObj)
    else
      if vehicle:isEngineStarted() then
        --				menu:addSlice("Ignition", getTexture("media/ui/vehicles/vehicle_ignitionON.png"), ISVehicleMenu.onStartEngine, playerObj)
      else
        if (SandboxVars.VehicleEasyUse) then
          menu:addSlice(getText("ContextMenu_VehicleStartEngine"), getTexture("media/ui/vehicles/vehicle_ignitionON.png"), ISVehicleMenu.onStartEngine, playerObj)
        elseif not vehicle:isHotwired() and (playerObj:getInventory():haveThisKeyId(vehicle:getKeyId()) or vehicle:isKeysInIgnition()) then
          menu:addSlice(getText("ContextMenu_VehicleStartEngine"), getTexture("media/ui/vehicles/vehicle_ignitionON.png"), ISVehicleMenu.onStartEngine, playerObj)
        elseif not vehicle:isHotwired() and ((playerObj:getPerkLevel(Perks.Electricity) >= 1 and playerObj:getPerkLevel(Perks.Mechanics) >= 2) or playerObj:HasTrait("Burglar"))then
          --					menu:addSlice("Hotwire Vehicle", getTexture("media/ui/vehicles/vehicle_ignitionON.png"), ISVehicleMenu.onHotwire, playerObj)
        elseif vehicle:isHotwired() then
          menu:addSlice(getText("ContextMenu_VehicleStartEngine"), getTexture("media/ui/vehicles/vehicle_ignitionON.png"), ISVehicleMenu.onStartEngine, playerObj)
        else
          --					menu:addSlice("You need keys or\nelectricity level 1 and\nmechanic level 2\nto hotwire", getTexture("media/ui/vehicles/vehicle_ignitionOFF.png"), nil, playerObj)
        end
      end
    end
  end

  if vehicle:isDriver(playerObj) and
  not vehicle:isHotwired() and
  not vehicle:isEngineStarted() and
  not vehicle:isEngineRunning() and
  not SandboxVars.VehicleEasyUse and
  not vehicle:isKeysInIgnition() and
  not playerObj:getInventory():haveThisKeyId(vehicle:getKeyId()) then
    if ((playerObj:getPerkLevel(Perks.Electricity) >= 1 and playerObj:getPerkLevel(Perks.Mechanics) >= 2) or playerObj:HasTrait("Burglar")) then
      menu:addSlice(getText("ContextMenu_VehicleHotwire"), getTexture("media/ui/vehicles/vehicle_ignitionON.png"), ISVehicleMenu.onHotwire, playerObj)
    else
      menu:addSlice(getText("ContextMenu_VehicleHotwireSkill"), getTexture("media/ui/vehicles/vehicle_ignitionOFF.png"), nil, playerObj)
    end
  end

  if vehicle:isDriver(playerObj) and vehicle:hasHeadlights() then
    if vehicle:getHeadlightsOn() then
      menu:addSlice(getText("ContextMenu_VehicleHeadlightsOff"), getTexture("media/ui/vehicles/vehicle_lightsOFF.png"), ISVehicleMenu.onToggleHeadlights, playerObj)
    else
      menu:addSlice(getText("ContextMenu_VehicleHeadlightsOn"), getTexture("media/ui/vehicles/vehicle_lightsON.png"), ISVehicleMenu.onToggleHeadlights, playerObj)
    end
  end

  if vehicle:getPartById("Heater") then
    local tex = getTexture("media/ui/vehicles/vehicle_temperatureHOT.png")
    if (vehicle:getPartById("Heater"):getModData().temperature or 0) < 0 then
      tex = getTexture("media/ui/vehicles/vehicle_temperatureCOLD.png")
    end
    if vehicle:getPartById("Heater"):getModData().active then
      menu:addSlice(getText("ContextMenu_VehicleHeaterOff"), tex, ISVehicleMenu.onToggleHeater, playerObj )
    else
      menu:addSlice(getText("ContextMenu_VehicleHeaterOn"), tex, ISVehicleMenu.onToggleHeater, playerObj )
    end
  end

  if vehicle:isDriver(playerObj) and vehicle:hasHorn() then
    menu:addSlice(getText("ContextMenu_VehicleHorn"), getTexture("media/ui/vehicles/vehicle_horn.png"), ISVehicleMenu.onHorn, playerObj)
  end

  if (vehicle:hasLightbar()) then
    menu:addSlice(getText("ContextMenu_VehicleLightbar"), getTexture("media/ui/vehicles/vehicle_lightbar.png"), ISVehicleMenu.onLightbar, playerObj)
  end

  if seat <= 1 then -- only front seats can access the radio
    for partIndex = 1, vehicle:getPartCount() do
      local part = vehicle:getPartByIndex(partIndex - 1)
      if part:getDeviceData() and part:getInventoryItem() then
        menu:addSlice(getText("IGUI_DeviceOptions"), getTexture("media/ui/vehicles/vehicle_speakersON.png"), ISVehicleMenu.onSignalDevice, playerObj, part)
      end
    end
  end

  local door = vehicle:getPassengerDoor(seat)
  local windowPart = VehicleUtils.getChildWindow(door)
  if windowPart and (not windowPart:getItemType() or windowPart:getInventoryItem()) then
    local window = windowPart:getWindow()
    if window:isOpenable() and not window:isDestroyed() then
      if window:isOpen() then
        option = menu:addSlice(getText("ContextMenu_Close_window"), getTexture("media/ui/vehicles/vehicle_windowCLOSED.png"), ISVehiclePartMenu.onOpenCloseWindow, playerObj, windowPart, false)
      else
        option = menu:addSlice(getText("ContextMenu_Open_window"), getTexture("media/ui/vehicles/vehicle_windowOPEN.png"), ISVehiclePartMenu.onOpenCloseWindow, playerObj, windowPart, true)
      end
    end
  end

  local locked = vehicle:isAnyDoorLocked()
  if JoypadState.players[playerObj:getPlayerNum() + 1] then
    -- Hack: Mouse players click the trunk icon in the dashboard.
    locked = locked or vehicle:isTrunkLocked()
  end
  if locked then
    menu:addSlice(getText("ContextMenu_Unlock_Doors"), getTexture("media/ui/vehicles/vehicle_lockdoors.png"), ISVehiclePartMenu.onLockDoors, playerObj, vehicle, false)
  else
    menu:addSlice(getText("ContextMenu_Lock_Doors"), getTexture("media/ui/vehicles/vehicle_lockdoors.png"), ISVehiclePartMenu.onLockDoors, playerObj, vehicle, true)
  end

  --	menu:addSlice("Honk", texture, { playerObj, ISVehicleMenu.onHonk })
  if vehicle:getCurrentSpeedKmHour() > 1 then
    menu:addSlice(getText("ContextMenu_VehicleMechanicsStopCar"), getTexture("media/ui/vehicles/vehicle_repair.png"), nil, playerObj, vehicle )
  else
    menu:addSlice(getText("ContextMenu_VehicleMechanics"), getTexture("media/ui/vehicles/vehicle_repair.png"), ISVehicleMenu.onMechanic, playerObj, vehicle )
  end
  if (not isClient() or getServerOptions():getBoolean("SleepAllowed")) then
    local doSleep = true;
    if playerObj:getStats():getFatigue() <= 0.3 then
      menu:addSlice(getText("IGUI_Sleep_NotTiredEnough"), getTexture("media/ui/vehicles/vehicle_sleep.png"), nil, playerObj, vehicle)
      doSleep = false;
    else
      -- Sleeping pills counter those sleeping problems
      if playerObj:getSleepingTabletEffect() < 2000 then
        -- In pain, can still sleep if really tired
        if playerObj:getMoodles():getMoodleLevel(MoodleType.Pain) >= 2 and playerObj:getStats():getFatigue() <= 0.85 then
          menu:addSlice(getText("ContextMenu_PainNoSleep"), getTexture("media/ui/vehicles/vehicle_sleep.png"), nil, playerObj, vehicle)
          doSleep = false;
          -- In panic
        elseif playerObj:getMoodles():getMoodleLevel(MoodleType.Panic) >= 1 then
          menu:addSlice(getText("ContextMenu_PanicNoSleep"), getTexture("media/ui/vehicles/vehicle_sleep.png"), nil, playerObj, vehicle)
          doSleep = false;
          -- tried to sleep not so long ago
        elseif (playerObj:getHoursSurvived() - playerObj:getLastHourSleeped()) <= 1 then
          menu:addSlice(getText("ContextMenu_NoSleepTooEarly"), getTexture("media/ui/vehicles/vehicle_sleep.png"), nil, playerObj, vehicle)
          doSleep = false;
        end
      end
    end
    if doSleep then
      menu:addSlice(getText("ContextMenu_Sleep"), getTexture("media/ui/vehicles/vehicle_sleep.png"), ISVehicleMenu.onSleep, playerObj, vehicle);
    end
  end
  menu:addSlice(getText("IGUI_ExitVehicle"), getTexture("media/ui/vehicles/vehicle_exit.png"), ISVehicleMenu.onExit, playerObj)

  menu:addToUIManager()

  if JoypadState.players[playerObj:getPlayerNum() + 1] then
    menu:setHideWhenButtonReleased(Joypad.DPadUp)
    setJoypadFocus(playerObj:getPlayerNum(), menu)
    playerObj:setJoypadIgnoreAimUntilCentered(true)
  end
end

function ISVehicleMenu.onShowSeatUI(playerObj, vehicle)
  local isPaused = UIManager.getSpeedControls|() and UIManager.getSpeedControls|():getCurrentGameSpeed() == 0
  if isPaused then return end

  local playerNum = playerObj:getPlayerNum()
  if not ISVehicleMenu.seatUI then
    ISVehicleMenu.seatUI = {}
  end
  local ui = ISVehicleMenu.seatUI[playerNum]
  if not ui or ui.character ~= playerObj then
    ui = ISVehicleSeatUI:new(0, 0, playerObj)
    ui:initialise()
    ui:instantiate()
    ISVehicleMenu.seatUI[playerNum] = ui
  end
  if ui:isReallyVisible() then
    ui:removeFromUIManager()
    if JoypadState.players[playerNum + 1] then
      setJoypadFocus(playerNum, nil)
    end
  else
    ui:setVehicle(vehicle)
    ui:addToUIManager()
    if JoypadState.players[playerNum + 1] then
      JoypadState.players[playerNum + 1].focus = ui
    end
  end
end
