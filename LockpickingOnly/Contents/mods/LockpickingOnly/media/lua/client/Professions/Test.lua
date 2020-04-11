require('NPCs/MainCreationMethods');
debug = true
if debug then
	Events.OnNewGame.Add(
		function(player, square)
			player:getInventory():AddItem("FMJ.LockPickingMag")
			player:getInventory():AddItem("FMJ.LockPickingMag2")
			player:getInventory():AddItem("Base.Crowbar")
			player:getInventory():AddItem("Base.Screwdriver")
			player:getInventory():AddItem("FMJ.BobbyPin")
			player:getInventory():AddItem("FMJ.BobbyPin")
			player:getInventory():AddItem("FMJ.BobbyPin")
			player:getInventory():AddItem("FMJ.BobbyPin")
			player:getInventory():AddItem("FMJ.BobbyPin")
		end
	)
end
