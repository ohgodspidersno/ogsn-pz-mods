--***********************************************************
--**                    THE INDIE STONE                    **
--***********************************************************

require "ISBaseObject"

ISDPadWheels = {}

function ISDPadWheels.onDisplayLeft(joypadData)
	local isPaused = UIManager.getSpeedControls() and UIManager.getSpeedControls():getCurrentGameSpeed() == 0
	if isPaused then return end

	local playerIndex = joypadData.player
	local playerObj = getSpecificPlayer(playerIndex)

	local menu = getPlayerRadialMenu(playerIndex)
	menu:clear()

	local inv = playerObj:getInventory():getItems()
	for i=1,inv:size() do
		local item = inv:get(i-1)
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
	local isPaused = UIManager.getSpeedControls() and UIManager.getSpeedControls():getCurrentGameSpeed() == 0
	if isPaused then return end

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
	local isPaused = UIManager.getSpeedControls() and UIManager.getSpeedControls():getCurrentGameSpeed() == 0
	if isPaused then return end

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

function ISDPadWheels.onShout(playerObj)
	playerObj:Callout()
end

