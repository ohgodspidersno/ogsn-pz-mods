local function TPF_minutes()
  -- getClimateManager():triggerCustomWeather(0.95, true);
end

local function TPF_seasons(_season)
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

Events.EveryTenMinutes.Add(TPF_minutes);
Events.OnInitSeasons.Add(TPF_seasons);
