--***********************************************************
--**                    THE INDIE STONE                    **
--**				  Author: turbotutone				   **
--***********************************************************

TheDescendingFog = {}

TheDescendingFog.OnGameStart = function()
    --[[
    local modal = ISModalRichText:new(getCore():getScreenWidth()/2 - 100, getCore():getScreenHeight()/2 - 50, 200, 100, getText("Challenge_TheDescendingFogInfoBox"), false, nil, nil, 0);
    modal:initialise();
    modal:addToUIManager();
    if JoypadState.players[1] then
        JoypadState.players[1].focus = modal
    end
    --]]
end

TheDescendingFog.OnInitSeasons = function(_season)
    _season:init(
        _season:getLat(), --aprox miami florida
        _season:getTempMin(), --min
        _season:getTempMax(), --max
        _season:getTempDiff(), --amount of degrees temp can go lower or higher then mean
        _season:getSeasonLag(),
        _season:getHighNoon(),
        _season:getSeedA(),
        _season:getSeedB(),
        _season:getSeedC()
    );
end

TheDescendingFog.OnInitWorld = function()
    SandboxVars.DayLength = 3;
    SandboxVars.StartMonth = 7;
    SandboxVars.StartTime = 2;
    SandboxVars.Temperature = 3;
    SandboxVars.Rain = 3;
    SandboxVars.TimeSinceApo = 1;
    Events.OnGameStart.Add(TheDescendingFog.OnGameStart);
    --Events.EveryDays.Add(TheDescendingFog.EveryDays);
    Events.EveryTenMinutes.Add(TheDescendingFog.EveryTenMinutes);
    Events.OnInitSeasons.Add(TheDescendingFog.OnInitSeasons);
end

TheDescendingFog.EveryTenMinutes = function()
    --getClimateManager():triggerCustomWeather(0.95, true);
end


TheDescendingFog.RemovePlayer = function(p)
end

TheDescendingFog.AddPlayer = function(p)

end

TheDescendingFog.Render = function()
end

TheDescendingFog.hourOfDay = 7;

Events.OnGameStart.Add(TheDescendingFog.OnGameStart);
--Events.EveryDays.Add(TheDescendingFog.EveryDays);
Events.EveryTenMinutes.Add(TheDescendingFog.EveryTenMinutes);
Events.OnInitSeasons.Add(TheDescendingFog.OnInitSeasons);
