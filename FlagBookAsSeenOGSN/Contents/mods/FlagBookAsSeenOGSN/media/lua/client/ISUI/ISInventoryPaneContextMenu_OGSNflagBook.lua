local ISInventoryPaneContextMenu_createMenu = ISInventoryPaneContextMenu.createMenu

ISInventoryPaneContextMenu.createMenu = function(player, isInPlayerInventory, items, x, y, origin)
	print('inside ISInventoryPaneContextMenu.createMenu in NRK accountant')
	if ISInventoryPaneContextMenu.dontCreateMenu then return; end
	if UIManager.getSpeedControls():getCurrentGameSpeed() == 0 and not getActivatedMods():contains("LetMeThink") then return end

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
		print('inside canBeWrite')
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
	print('about to return context')
	return context
end

-- require "ISUI/ISInventoryPaneContextMenu"
--
-- local ISInventoryPaneContextMenu_createMenu = ISInventoryPaneContextMenu.createMenu
--
-- ISInventoryPaneContextMenu.createMenu = function(player, isInPlayerInventory, items, x, y, origin)
-- 	print('inside ISInventoryPaneContextMenu.createMenu')
-- 	if ISInventoryPaneContextMenu.dontCreateMenu then return; end
-- 	if UIManager.getSpeedControls():getCurrentGameSpeed() == 0 and not getActivatedMods():contains("LetMeThink") then return end
--
-- 	local context = ISInventoryPaneContextMenu_createMenu(player, isInPlayerInventory, items, x, y, origin)
-- 	canBeFlagged = nil
-- 	print("Just set canBeFlagged to nil")
-- 	local canBeFlagged, testItem = nil, nil
-- 	for i, v in ipairs(items) do
-- 		testItem = v
-- 		print(testItem)
-- 		if not instanceof(v, "InventoryItem") then
-- 			testItem = v.items[1]
-- 		end
-- 		print('testing to see if it hits the conditions')
-- 		print(testItem:getCategory() == "Literature")
-- 		print(testItem:getNumberOfPages() > 0)
-- 		print(testItem:getAlreadyReadPages() < 1)
-- 		print(not getSpecificPlayer(player):getTraits():isIlliterate())
--
-- 		if testItem:getCategory() == "Literature"
-- 		and testItem:getNumberOfPages() > 0
-- 		and testItem:getAlreadyReadPages() < 1
-- 		and not getSpecificPlayer(player):getTraits():isIlliterate() then
-- 				 canBeFlagged = testItem
-- 	end
-- 	if canBeFlagged then
-- 		print('yes, item canBeFlagged')
-- 		local flagOption = context:addOption(getText("ContextMenu_FlagBook"), items, ISInventoryPaneContextMenu.onFlagBookItems, player);
-- 	  if getSpecificPlayer(player):isAsleep() then
-- 	    flagOption.notAvailable = true;
-- 	    local tooltip = ISInventoryPaneContextMenu.addToolTip();
-- 	    tooltip.description = getText("ContextMenu_NoOptionSleeping");
-- 	    flagOption.toolTip = tooltip;
-- 	  end
-- 		end
-- 	end
-- 	print('returning context...')
-- 	return context
-- end
--
-- ISInventoryPaneContextMenu.onFlagBookItems = function(items, player)
-- 	print('inside ISInventoryPaneContextMenu.onFlagBookItems')
--   items = ISInventoryPane.getActualItems(items)
--   for i, k in ipairs(items) do
--     ISInventoryPaneContextMenu.flagBookItem(k, player)
--     break;
--   end
-- end
--
-- ISInventoryPaneContextMenu.flagBookItem = function(item, player)
-- 	print('inside ISInventoryPaneContextMenu.flagBookItem')
--   local playerObj = getSpecificPlayer(player)
--   ISInventoryPaneContextMenu.transferIfNeeded(playerObj, item)
--   ISTimedActionQueue.add(ISFlagABookAsSeen:new(playerObj, item, 10));
-- end
