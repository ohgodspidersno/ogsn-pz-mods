local function SAC_minutes()
  getClimateManager():triggerCustomWeather(0.95, true);
end

local function SAC_seasons(_season)
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

Events.EveryTenMinutes.Add(SAC_minutes);
Events.OnInitSeasons.Add(SAC_seasons);
