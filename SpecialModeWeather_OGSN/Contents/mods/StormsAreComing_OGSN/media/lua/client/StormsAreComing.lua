Events.OnInitWorld.Add(function() {
    print('OnInitWorld: StormsAreComing enabled')
});

Events.OnGameStart.Add(function() {
    print('OnGameStart: StormsAreComing enabled')
});

Events.OnInitSeasons.Add(function(_season) {
    print('OnInitSeasons: StormsAreComing enabled')
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
});

Events.EveryTenMinutes.Add(function() {
    print('EveryTenMinutes: StormsAreComing enabled')
    getClimateManager():triggerCustomWeather(0.95, true);
});

Events.EveryDays.Add(function() {
    print('EveryDays: StormsAreComing enabled')
});
