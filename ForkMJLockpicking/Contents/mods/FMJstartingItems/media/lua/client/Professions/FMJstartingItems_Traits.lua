require('NPCs/MainCreationMethods');

if getActivatedMods():contains("FMJlockPicking") then
		Events.OnNewGame.Add(function(player, square)
			if player:HasTrait("NimbleFingers") then
		    	player:getInventory():AddItem("FMJ.BobbyPin");
		    	player:getInventory():AddItem("FMJ.BobbyPin")
		    end
			if player:HasTrait("NimbleFingers2") then
		    	player:getInventory():AddItem("FMJ.BobbyPin");
		    	player:getInventory():AddItem("FMJ.BobbyPin")
			end
		end)
else return end
