-- Events.OnInitWorld.Add(
--   function()
--     -- print('OnInitWorld: WintersAreComing enabled')
--   end
-- );

Events.OnGameStart.Add(
  function()
    -- print('OnGameStart: WintersAreComing enabled')
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
);

Events.OnInitSeasons.Add(
  function(_season)
    -- print('OnInitSeasons: WintersAreComing enabled')
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
);

-- Events.EveryTenMinutes.Add(
--   function()
--     -- print('EveryTenMinutes: WintersAreComing enabled')
--   end
-- );

Events.EveryDays.Add(
  function()
    -- print('EveryDays: WintersAreComing enabled')
    if getGameTime():getWorldAgeHours() >=4*24 then
        getCore():setForceSnow(true);
    end
    if getGameTime():getWorldAgeHours() >=3*24 and getGameTime():getWorldAgeHours() <=4*24 then
        getClimateManager():triggerWinterIsComingStorm();
    end
  end
);
