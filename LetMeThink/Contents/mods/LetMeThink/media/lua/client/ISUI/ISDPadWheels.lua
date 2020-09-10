--***********************************************************
--**                    THE INDIE STONE                    **
--***********************************************************

require "ISBaseObject"

ISDPadWheels = {}

local function isEquippedOrAttached(playerObj, item)
  return playerObj:isEquipped(item) or playerObj:isAttachedItem(item)
end

function ISDPadWheels.onDisplayLeft(joypadData) -- LMT
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

function ISDPadWheels.onDisplayRight(joypadData) -- LMT
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

function ISDPadWheels.onDisplayUp(joypadData)
  ISVehicleMenu.showRadialMenu(getSpecificPlayer(joypadData.player))
end

function ISDPadWheels.onDisplayDown(joypadData) -- LMT
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

function ISDPadWheels.onEquipPrimary(playerObj, item)
  -- FIXME: ISInventoryPaneContextMenu checks for injured hands (code is broken though)
  if item and item == playerObj:getPrimaryHandItem() then
    ISTimedActionQueue.add(ISUnequipAction:new(playerObj, playerObj:getPrimaryHandItem(), 50));
  else
    ISTimedActionQueue.add(ISEquipWeaponAction:new(playerObj, item, 50, true, item:isTwoHandWeapon()));
  end
end

function ISDPadWheels.onToggleLight(playerObj, item)
  if not isEquippedOrAttached(playerObj, item) then
    ISTimedActionQueue.add(ISEquipWeaponAction:new(playerObj, item, 50, false))
  else
    item:setActivated(not item:isActivated())
  end
end

function ISDPadWheels.onShout(playerObj)
  playerObj:Callout()
end
