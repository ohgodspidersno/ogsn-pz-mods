local ISInventoryPaneContextMenu_createMenu = ISInventoryPaneContextMenu.createMenu

ISInventoryPaneContextMenu.createMenu = function(player, isInPlayerInventory, items, x, y, origin)
	if ISInventoryPaneContextMenu.dontCreateMenu then return; end
	-- if UIManager.getSpeedControls():getCurrentGameSpeed() == 0 then return end

	local context = ISInventoryPaneContextMenu_createMenu(player, isInPlayerInventory, items, x, y, origin)

	local canBeWrite, testItem = nil, nil
	for i, v in ipairs(items) do
		testItem = v
		if not instanceof(v, "InventoryItem") then
			testItem = v.items[1]
		end
		if testItem:getCategory() == "Literature" and testItem:canBeWrite() then
			canBeWrite = testItem
		end
	end

	if canBeWrite then
		local editable = getSpecificPlayer(player):getInventory():contains("BluePen") or getSpecificPlayer(player):getInventory():contains("RedPen")
		if canBeWrite:getLockedBy() and canBeWrite:getLockedBy() ~= getSpecificPlayer(player):getUsername() then editable = false end
		if editable then
			 -- ищем дубль этого пункта меню (читать/писать) и удаляем его, при необходимости сдвигая вперёд остальные
			for i = 1, context.numOptions - 1 do
				if context.options[i].name == getText("ContextMenu_Read_Note", canBeWrite:getName()) or
				   context.options[i].name == getText("ContextMenu_Write_Note", canBeWrite:getName()) or
				   context.options[i] == nil then
					context.options[i] = context.options[i + 1]
					context.options[i + 1] = nil
				end
			end
			if context.options[context.numOptions - 1] == nil then context.numOptions = context.numOptions - 1 end

			context:addOption(getText("ContextMenu_Write_Note", canBeWrite:getName()), canBeWrite, ISInventoryPaneContextMenu.onWriteSomething, true, player)
		end
	end

	return context
end
