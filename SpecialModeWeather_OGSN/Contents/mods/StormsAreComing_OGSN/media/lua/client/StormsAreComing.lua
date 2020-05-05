-- Events.OnInitWorld.Add(
--   function()
--     -- print('OnInitWorld: StormsAreComing enabled')
--   end
-- );

-- Events.OnGameStart.Add(
--   function()
--     -- print('OnGameStart: StormsAreComing enabled')
--   end
-- );

Events.OnInitSeasons.Add(
  function(_season)
    -- print('OnInitSeasons: StormsAreComing enabled')
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
);

Events.EveryTenMinutes.Add(
  function()
    -- print('EveryTenMinutes: StormsAreComing enabled')
    getClimateManager():triggerCustomWeather(0.95, true);
  end
);

-- Events.EveryDays.Add(
--   function()
--     -- print('EveryDays: StormsAreComing enabled')
--   end
-- );
