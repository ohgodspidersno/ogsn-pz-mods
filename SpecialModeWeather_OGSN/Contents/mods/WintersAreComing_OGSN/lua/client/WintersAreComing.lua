WinterIsComing = {}

WinterIsComing.OnGameStart = function()
    if getGameTime():getWorldAgeHours() >= 4*24 then
        getCore():setForceSnow(true);
        forceSnowCheck();
    end

    if getGameTime():getWorldAgeHours() >=3*24 and getGameTime():getWorldAgeHours() <=4*24 then
        getClimateManager():triggerWinterIsComingStorm();
    end

    --getClimateManager():forceDayInfoUpdate();

	if getGameTime():getDay() == 8 and getGameTime():getTimeOfDay() == 9 then
		local modal = ISModalRichText:new(getCore():getScreenWidth()/2 - 100, getCore():getScreenHeight()/2 - 50, 200, 100, getText("Challenge_WinterIsComingInfoBox"), false, nil, nil, 0);
		modal:initialise();
		modal:addToUIManager();
		if JoypadState.players[1] then
			JoypadState.players[1].focus = modal
		end
	end
end

WinterIsComing.OnInitSeasons = function(_season)
    _season:init(
        50, -- Newfoundland. _season:getLat(),
        -5,
        -20,
        8,
        _season:getSeasonLag(),
        _season:getHighNoon(),
        _season:getSeedA(),
        _season:getSeedB(),
        _season:getSeedC()
    );
end

WinterIsComing.OnInitWorld = function()
	SandboxVars.DayLength = 3;
	SandboxVars.StartMonth = 7;
	SandboxVars.StartTime = 2;
	SandboxVars.Temperature = 3;
	SandboxVars.Rain = 3;
--	    SandboxVars.erosion = 12
	-- SandboxVars.TimeSinceApo = 3;

	Events.OnGameStart.Add(WinterIsComing.OnGameStart);
    Events.EveryDays.Add(WinterIsComing.EveryDays);
    --Events.EveryTenMinutes.Add(WinterIsComing.EveryTenMinutes);
    Events.OnInitSeasons.Add(WinterIsComing.OnInitSeasons);
end

WinterIsComing.EveryDays = function()
    if getGameTime():getWorldAgeHours() >=4*24 then
        getCore():setForceSnow(true);
    end
    if getGameTime():getWorldAgeHours() >=3*24 and getGameTime():getWorldAgeHours() <=4*24 then
        getClimateManager():triggerWinterIsComingStorm();
    end
end

--[[
WinterIsComing.EveryTenMinutes = function()
    if getGameTime():getDaysSurvived() >= 7 then
        getWorld():setGlobalTemperature(ZombRand(-10,0));
    end
end
--]]

-- WinterIsComing.RemovePlayer = function(p)
--
-- end
--
-- WinterIsComing.AddPlayer = function(p)
--
-- end
--
-- WinterIsComing.Render = function()
--
-- --~ 	getTextManager():DrawStringRight(UIFont.Small, getCore():getOffscreenWidth() - 20, 20, "Zombies left : " .. (EightMonthsLater.zombiesSpawned - EightMonthsLater.deadZombie), 1, 1, 1, 0.8);
--
-- --~ 	getTextManager():DrawStringRight(UIFont.Small, (getCore():getOffscreenWidth()*0.9), 40, "Next wave : " .. tonumber(((60*60) - EightMonthsLater.waveTime)), 1, 1, 1, 0.8);
-- end

WinterIsComing.hourOfDay = 7;
