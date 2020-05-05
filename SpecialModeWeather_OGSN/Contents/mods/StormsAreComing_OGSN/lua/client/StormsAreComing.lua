--***********************************************************
--**                    THE INDIE STONE                    **
--**				  Author: turbotutone				   **
--***********************************************************

AStormIsComing = {}


AStormIsComing.OnGameStart = function()
    --[[
    local modal = ISModalRichText:new(getCore():getScreenWidth()/2 - 100, getCore():getScreenHeight()/2 - 50, 200, 100, getText("Challenge_AStormIsComingInfoBox"), false, nil, nil, 0);
    modal:initialise();
    modal:addToUIManager();
    if JoypadState.players[1] then
        JoypadState.players[1].focus = modal
    end
    --]]
end

AStormIsComing.OnInitSeasons = function(_season)
    _season:init(
        25, --aprox miami florida
        16, --min
        30, --max
        4, --amount of degrees temp can go lower or higher then mean
        _season:getSeasonLag(),
        _season:getHighNoon(),
        _season:getSeedA(),
        _season:getSeedB(),
        _season:getSeedC()
    );
end

AStormIsComing.OnInitWorld = function()
    SandboxVars.DayLength = 3;
    SandboxVars.StartMonth = 7;
    SandboxVars.StartTime = 2;
    SandboxVars.Temperature = 3;
    SandboxVars.Rain = 3;
    -- SandboxVars.TimeSinceApo = 1;
    Events.OnGameStart.Add(AStormIsComing.OnGameStart);
    --Events.EveryDays.Add(AStormIsComing.EveryDays);
    Events.EveryTenMinutes.Add(AStormIsComing.EveryTenMinutes);
    Events.OnInitSeasons.Add(AStormIsComing.OnInitSeasons);
end

AStormIsComing.EveryTenMinutes = function()
    getClimateManager():triggerCustomWeather(0.95, true);
end


AStormIsComing.RemovePlayer = function(p)
end

AStormIsComing.AddPlayer = function(p)

end

AStormIsComing.Render = function()
end

AStormIsComing.hourOfDay = 7;
