--***********************************************************
--**                    THE INDIE STONE                    **
--***********************************************************

require "ISBaseObject"

ISDPadWheels = {}

function ISDPadWheels.onDisplayLeft(joypadData)
  local playerIndex = joypadData.player
  local playerObj = getSpecificPlayer(playerIndex)

  local menu = getPlayerRadialMenu(playerIndex)
  menu:clear()

  local inv = playerObj:getInventory():getItems()
  for i = 1, inv:size() do
    local item = inv:get(i - 1)
    if instanceof(item, "HandWeapon") and item:getCondition() > 0 then
      menu:addSlice(item:getDisplayName(), item:getTex(), ISDPadWheels.onEquipPrimary, playerObj, item)
    end
  end

  menu:setX(getPlayerScreenLeft(playerIndex) + getPlayerScreenWidth(playerIndex) / 2 - menu:getWidth() / 2)
  menu:setY(getPlayerScreenTop(playerIndex) + getPlayerScreenHeight(playerIndex) / 2 - menu:getHeight() / 2)
  menu:addToUIManager()
  setJoypadFocus(playerIndex, menu)
  playerObj:setJoypadIgnoreAimUntilCentered(true)
end

function ISDPadWheels.onDisplayRight(joypadData)
  local playerIndex = joypadData.player
  local playerObj = getSpecificPlayer(playerIndex)

  local menu = getPlayerRadialMenu(playerIndex)
  menu:clear()

  menu:setX(getPlayerScreenLeft(playerIndex) + getPlayerScreenWidth(playerIndex) / 2 - menu:getWidth() / 2)
  menu:setY(getPlayerScreenTop(playerIndex) + getPlayerScreenHeight(playerIndex) / 2 - menu:getHeight() / 2)
  menu:addToUIManager()
  setJoypadFocus(playerIndex, menu)
  playerObj:setJoypadIgnoreAimUntilCentered(true)
end

function ISDPadWheels.onDisplayUp(joypadData)
  ISVehicleMenu.showRadialMenu(getSpecificPlayer(joypadData.player))
end

function ISDPadWheels.onDisplayDown(joypadData)
  local playerIndex = joypadData.player
  local playerObj = getSpecificPlayer(playerIndex)

  local menu = getPlayerRadialMenu(playerIndex)
  menu:clear()

  menu:addSlice("Shout", getTexture("media/ui/Traits/trait_talkative.png"), ISDPadWheels.onShout, playerObj)

  menu:setX(getPlayerScreenLeft(playerIndex) + getPlayerScreenWidth(playerIndex) / 2 - menu:getWidth() / 2)
  menu:setY(getPlayerScreenTop(playerIndex) + getPlayerScreenHeight(playerIndex) / 2 - menu:getHeight() / 2)
  menu:addToUIManager()
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

--[[
function ISDPadWheels.onVehicleInfo(playerObj, vehicle)
	local ui = getPlayerVehicleUI(playerObj:getPlayerNum())
	ui:setVehicle(vehicle)
	ui:setVisible(true)
	if JoypadState.players[playerObj:getPlayerNum()+1] then
		JoypadState.players[playerObj:getPlayerNum()+1].focus = ui
	end
end

function ISDPadWheels.onVehicleEnter(playerObj, vehicle, seat)
	if vehicle:isSeatOccupied(seat) then return end
	local switchSeat = nil
	if vehicle:isEnterBlocked(playerObj, seat) then
		-- find a seat we can get into and switch to the final seat
		for seat2=0,vehicle:getMaxPassengers()-1 do
			if seat ~= seat2 and vehicle:canSwitchSeat(seat2, seat) and not vehicle:isSeatOccupied(seat2) and not vehicle:isEnterBlocked(playerObj, seat2) then
				switchSeat = seat
				seat = seat2
				break
			end
		end
		if not switchSeat then return end
	end
	-- FIXME: path to vehicle enter x,y instead
	local area = vehicle:getPassengerArea(seat)
	if area then
		ISTimedActionQueue.add(ISPathFindAction:pathToVehicleArea(playerObj, vehicle, area))
		ISVehicleMenu.onEnter(playerObj, vehicle, seat)
		if switchSeat then
			ISTimedActionQueue.add(ISSwitchVehicleSeat:new(playerObj, switchSeat))
		end
	end
end
]]--

function ISDPadWheels.onShout(playerObj)
  playerObj:Callout()
end
