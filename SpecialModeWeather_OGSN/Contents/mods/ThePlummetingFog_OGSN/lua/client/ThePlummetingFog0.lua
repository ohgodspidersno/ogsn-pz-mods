Events.OnInitWorld.Add(function() {
print('OnInitWorld: ThePlummetingFog enabled')
});

Events.OnGameStart.Add(function() {
print('OnGameStart: ThePlummetingFog enabled')
});

Events.OnInitSeasons.Add(function(_season) {
print('OnInitSeasons: ThePlummetingFog enabled')
});

Events.EveryTenMinutes.Add(function() {
print('EveryTenMinutes: ThePlummetingFog enabled')
});

Events.EveryDays.Add(function() {
print('EveryDays: ThePlummetingFog enabled')
});
