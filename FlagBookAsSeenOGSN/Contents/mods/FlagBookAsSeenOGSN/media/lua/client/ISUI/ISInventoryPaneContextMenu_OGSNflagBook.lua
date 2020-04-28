require "ISUI/ISInventoryPaneContextMenu"

ISInventoryPaneContextMenu.flagBookItem = function(item, player)
	-- if clothing isn't in main inventory, put it there first.
	local playerObj = getSpecificPlayer(player)
	ISInventoryPaneContextMenu.transferIfNeeded(playerObj, item)
	-- flag
	ISTimedActionQueue.add(ISFlagABookAsSeen:new(playerObj, item, 10));
end
