Events.OnInitWorld.Add(function() {
print('OnInitWorld: WintersAreComing enabled')
});

Events.OnGameStart.Add(function() {
print('OnGameStart: WintersAreComing enabled')
});

Events.OnInitSeasons.Add(function(_season) {
print('OnInitSeasons: WintersAreComing enabled')
});

Events.EveryTenMinutes.Add(function() {
print('EveryTenMinutes: WintersAreComing enabled')
});

Events.EveryDays.Add(function() {
print('EveryDays: WintersAreComing enabled')
});
