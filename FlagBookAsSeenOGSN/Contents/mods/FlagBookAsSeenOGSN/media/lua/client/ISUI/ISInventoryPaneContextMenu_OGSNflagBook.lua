require "ISUI/ISInventoryPaneContextMenu"

local ISInventoryPaneContextMenu_createMenu = ISInventoryPaneContextMenu.createMenu

ISInventoryPaneContextMenu.createMenu = function(player, isInPlayerInventory, items, x, y, origin)
	if ISInventoryPaneContextMenu.dontCreateMenu then return; end
	if UIManager.getSpeedControls():getCurrentGameSpeed() == 0 and not getActivatedMods():contains("LetMeThink") then return end

	local context = ISInventoryPaneContextMenu_createMenu(player, isInPlayerInventory, items, x, y, origin)
	canBeFlagged = nil

	local canBeFlagged, testItem = nil, nil
	for i, v in ipairs(items) do
		testItem = v
		if not instanceof(v, "InventoryItem") then
			testItem = v.items[1]
		end
		if self.character:getInventory():contains(self.item)
		   and self.item:getNumberOfPages() > 0
		   and self.item:getAlreadyReadPages() < 1
		   and not self.character:HasTrait("Illiterate") then
				 canBeFlagged = testItem
	end
	if canBeFlagged then
		local flagOption = context:addOption(getText("ContextMenu_FlagBook"), items, ISInventoryPaneContextMenu.onFlagBookItems, player);
	  if getSpecificPlayer(player):isAsleep() then
	    flagOption.notAvailable = true;
	    local tooltip = ISInventoryPaneContextMenu.addToolTip();
	    tooltip.description = getText("ContextMenu_NoOptionSleeping");
	    flagOption.toolTip = tooltip;
	  end
		end
	end
	return context
end

ISInventoryPaneContextMenu.onFlagBookItems = function(items, player)
  items = ISInventoryPane.getActualItems(items)
  for i, k in ipairs(items) do
    ISInventoryPaneContextMenu.flagBookItem(k, player)
    break;
  end
end

ISInventoryPaneContextMenu.flagBookItem = function(item, player)
  local playerObj = getSpecificPlayer(player)
  ISInventoryPaneContextMenu.transferIfNeeded(playerObj, item)
  ISTimedActionQueue.add(ISFlagABookAsSeen:new(playerObj, item, 10));
end
