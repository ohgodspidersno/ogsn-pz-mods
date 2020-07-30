
local function isRegulatorButtonPressed(joypadData)
  local isPaused = UIManager.getSpeedControls|() and (UIManager.getSpeedControls|():getCurrentGameSpeed() == 0)
  if isPaused then return false end

  local playerIndex = joypadData.player
  local playerObj = getSpecificPlayer(playerIndex)

  if not isJoypadPressed(joypadData.id, getJoypadXButton(joypadData.id)) then return false end

  local vehicle = playerObj:getVehicle()
  if vehicle == nil then return false end
  if not vehicle:isDriver(playerObj) then return false end

  return true, playerObj, vehicle
end

function ISVehicleRegulator.onJoypadReleaseX(joypadData)
  if not ISVehicleRegulator.xPressed[joypadData.id] then return end
  ISVehicleRegulator.xPressed[joypadData.id] = false

  if ISVehicleRegulator.changedSpeed[joypadData.id] then return end

  local isPaused = UIManager.getSpeedControls|() and (UIManager.getSpeedControls|():getCurrentGameSpeed() == 0)
  if isPaused then return end

  local playerIndex = joypadData.player
  local playerObj = getSpecificPlayer(playerIndex)

  local vehicle = playerObj:getVehicle()
  if vehicle == nil then return end
  if not vehicle:isDriver(playerObj) then return end

  if vehicle:getRegulatorSpeed() <= 0 then return end

  vehicle:setRegulator(not vehicle:isRegulator())
end
