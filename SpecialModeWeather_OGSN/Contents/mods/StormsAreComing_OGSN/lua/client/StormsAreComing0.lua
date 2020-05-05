Events.OnInitWorld.Add(function() {
print('OnInitWorld: StormsAreComing enabled')
});

Events.OnGameStart.Add(function() {
print('OnGameStart: StormsAreComing enabled')
});

Events.OnInitSeasons.Add(function(_season) {
print('OnInitSeasons: StormsAreComing enabled')
});

Events.EveryTenMinutes.Add(function() {
print('EveryTenMinutes: StormsAreComing enabled')
});

Events.EveryDays.Add(function() {
print('EveryDays: StormsAreComing enabled')
});
