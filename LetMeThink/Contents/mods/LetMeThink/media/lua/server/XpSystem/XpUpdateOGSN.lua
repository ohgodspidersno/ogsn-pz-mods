-- if we press the toggle skill panel key we gonna display the character info screen
xpUpdate.displayCharacterInfo = function(key)
	local playerObj = getSpecificPlayer(0)
	if getGameSpeed() == 0 or not playerObj or playerObj:isDead() then
		return;
	end
	if not getPlayerData(0) then return end
	if key == getCore():getKey("Toggle Skill Panel") then
		xpUpdate.characterInfo = getPlayerInfoPanel(playerObj:getPlayerNum());
		xpUpdate.characterInfo:toggleView(xpSystemText.skills);
	end
	if key == getCore():getKey("Toggle Health Panel") then
		xpUpdate.characterInfo = getPlayerInfoPanel(playerObj:getPlayerNum());
		xpUpdate.characterInfo:toggleView(xpSystemText.health);
        xpUpdate.characterInfo.healthView.doctorLevel = playerObj:getPerkLevel(Perks.Doctor);
	end
	if key == getCore():getKey("Toggle Info Panel") then
		xpUpdate.characterInfo = getPlayerInfoPanel(playerObj:getPlayerNum());
		xpUpdate.characterInfo:toggleView(xpSystemText.info);
	end
	if key == getCore():getKey("Toggle Clothing Protection Panel") then
		xpUpdate.characterInfo = getPlayerInfoPanel(playerObj:getPlayerNum());
		xpUpdate.characterInfo:toggleView(xpSystemText.protection);
	end
end
