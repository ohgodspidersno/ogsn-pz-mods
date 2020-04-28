require "ISUI/ISInventoryPaneContextMenu"

local ISInventoryPaneContextMenu_createMenu = ISInventoryPaneContextMenu.createMenu

ISInventoryPaneContextMenu.createMenu = function(player, isInPlayerInventory, items, x, y, origin)
	if ISInventoryPaneContextMenu.dontCreateMenu then return; end
	if UIManager.getSpeedControls():getCurrentGameSpeed() == 0 and not getActivatedMods():contains("LetMeThink") then return end

	local context = ISInventoryPaneContextMenu_createMenu(player, isInPlayerInventory, items, x, y, origin)
	canBeFlagged = nil
	print("Just set canBeFlagged to nil")
	local canBeFlagged, testItem = nil, nil
	for i, v in ipairs(items) do
		testItem = v
		print(testItem)
		if not instanceof(v, "InventoryItem") then
			testItem = v.items[1]
		end
		print('testing to see if it hits the conditions')
		print(testItem:getCategory() == "Literature")
		print(testItem:getNumberOfPages() > 0)
		print(testItem:getAlreadyReadPages() < 1)
		print(not getSpecificPlayer(player):getTraits():isIlliterate())

		if testItem:getCategory() == "Literature"
		and testItem:getNumberOfPages() > 0
		and testItem:getAlreadyReadPages() < 1
		and not getSpecificPlayer(player):getTraits():isIlliterate() then
				 canBeFlagged = testItem
	end
	if canBeFlagged then
		print('yes, item canBeFlagged')
		local flagOption = context:addOption(getText("ContextMenu_FlagBook"), items, ISInventoryPaneContextMenu.onFlagBookItems, player);
	  if getSpecificPlayer(player):isAsleep() then
	    flagOption.notAvailable = true;
	    local tooltip = ISInventoryPaneContextMenu.addToolTip();
	    tooltip.description = getText("ContextMenu_NoOptionSleeping");
	    flagOption.toolTip = tooltip;
	  end
		end
	end
	print('returning context...')
	return context
end

ISInventoryPaneContextMenu.onFlagBookItems = function(items, player)
	print('inside ISInventoryPaneContextMenu.onFlagBookItems')
  items = ISInventoryPane.getActualItems(items)
  for i, k in ipairs(items) do
    ISInventoryPaneContextMenu.flagBookItem(k, player)
    break;
  end
end

ISInventoryPaneContextMenu.flagBookItem = function(item, player)
	print('inside ISInventoryPaneContextMenu.flagBookItem')
  local playerObj = getSpecificPlayer(player)
  ISInventoryPaneContextMenu.transferIfNeeded(playerObj, item)
  ISTimedActionQueue.add(ISFlagABookAsSeen:new(playerObj, item, 10));
end
