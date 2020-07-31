
local ISDPadWheels_onDisplayLeft_original = ISDPadWheels.onDisplayLeft
function ISDPadWheels.onDisplayLeft(joypadData, ...)
  local isPaused = UIManager.getSpeedControls|() and UIManager.getSpeedControls|():getCurrentGameSpeed() == 0
  if not isPaused then
    ISDPadWheels_onDisplayLeft_original(self, joypadData, ...)
    return
  end

  local playerIndex = joypadData.player
  local playerObj = getSpecificPlayer(playerIndex)

  local menu = getPlayerRadialMenu(playerIndex)
  menu:clear()

  local bestLight, bestLightEquipped = nil
  local inv = playerObj:getInventory():getItems()
  for i = 1, inv:size() do
    local item = inv:get(i - 1)
    if instanceof(item, "HandWeapon") and item:getCondition() > 0 then
      menu:addSlice(item:getDisplayName(), item:getTex(), ISDPadWheels.onEquipPrimary, playerObj, item)
    elseif item:canEmitLight() then
      if not bestLight then
        bestLight = item
      elseif bestLight:getLightStrength() < item:getLightStrength() then
        bestLight = item
      end
      if isEquippedOrAttached(playerObj, item) then
        if not bestLightEquipped then
          bestLightEquipped = item
        elseif bestLightEquipped:getLightStrength() < item:getLightStrength() then
          bestLightEquipped = item
        end
      end
    end
  end

  bestLight = bestLightEquipped or bestLight
  if bestLight then
    menu:addSlice(bestLight:getDisplayName(), bestLight:getTex(), ISDPadWheels.onToggleLight, playerObj, bestLight)
  end

  menu:setX(getPlayerScreenLeft(playerIndex) + getPlayerScreenWidth(playerIndex) / 2 - menu:getWidth() / 2)
  menu:setY(getPlayerScreenTop(playerIndex) + getPlayerScreenHeight(playerIndex) / 2 - menu:getHeight() / 2)
  menu:addToUIManager()
  menu:setHideWhenButtonReleased(Joypad.DPadLeft)
  setJoypadFocus(playerIndex, menu)
  playerObj:setJoypadIgnoreAimUntilCentered(true)
end

local ISDPadWheels_onDisplayRight_original = ISDPadWheels.onDisplayRight
function ISDPadWheels.onDisplayRight(joypadData, ...)
  local isPaused = UIManager.getSpeedControls|() and UIManager.getSpeedControls|():getCurrentGameSpeed() == 0
  if isPaused then
    ISDPadWheels_onDisplayRight_original(self, joypadData, ...)
    return
  end

  local playerIndex = joypadData.player
  local playerObj = getSpecificPlayer(playerIndex)

  local menu = getPlayerRadialMenu(playerIndex)
  menu:clear()

  menu:setX(getPlayerScreenLeft(playerIndex) + getPlayerScreenWidth(playerIndex) / 2 - menu:getWidth() / 2)
  menu:setY(getPlayerScreenTop(playerIndex) + getPlayerScreenHeight(playerIndex) / 2 - menu:getHeight() / 2)
  menu:addToUIManager()
  menu:setHideWhenButtonReleased(Joypad.DPadRight)
  setJoypadFocus(playerIndex, menu)
  playerObj:setJoypadIgnoreAimUntilCentered(true)
end

local ISDPadWheels_onDisplayDown_original = ISDPadWheels.onDisplayDown
function ISDPadWheels.onDisplayDown(joypadData, ...)
  local isPaused = UIManager.getSpeedControls|() and UIManager.getSpeedControls|():getCurrentGameSpeed() == 0
  if isPaused then
    ISDPadWheels_onDisplayDown_original(self, joypadData, ...)
    return
  end

  local playerIndex = joypadData.player
  local playerObj = getSpecificPlayer(playerIndex)

  local menu = getPlayerRadialMenu(playerIndex)
  menu:clear()

  menu:addSlice("Shout", getTexture("media/ui/Traits/trait_talkative.png"), ISDPadWheels.onShout, playerObj)

  menu:setX(getPlayerScreenLeft(playerIndex) + getPlayerScreenWidth(playerIndex) / 2 - menu:getWidth() / 2)
  menu:setY(getPlayerScreenTop(playerIndex) + getPlayerScreenHeight(playerIndex) / 2 - menu:getHeight() / 2)
  menu:addToUIManager()
  menu:setHideWhenButtonReleased(Joypad.DPadDown)
  setJoypadFocus(playerIndex, menu)
  playerObj:setJoypadIgnoreAimUntilCentered(true)
end
