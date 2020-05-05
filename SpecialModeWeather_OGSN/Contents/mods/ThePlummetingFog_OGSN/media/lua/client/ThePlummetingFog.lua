Events.OnInitWorld.Add(function() {
print('OnInitWorld: ThePlummetingFog enabled')
});

Events.OnGameStart.Add(function() {
print('OnGameStart: ThePlummetingFog enabled')
});

Events.OnInitSeasons.Add(function(_season) {
    print('OnInitSeasons: ThePlummetingFog enabled')
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
});

Events.EveryTenMinutes.Add(function() {
print('EveryTenMinutes: ThePlummetingFog enabled')
});

Events.EveryDays.Add(function() {
print('EveryDays: ThePlummetingFog enabled')
});


-- from AdminPanel/ISAdmPanelClimate
-- local FLOAT_CLOUD_INTENSITY = 8;
-- ...
-- local clim = getClimateManager();
-- ...
-- elseif _tickbox.customData == "Fog" then
--         if clim:getClimateFloat(FLOAT_FOG_INTENSITY):isEnableAdmin() then
--             clim:getClimateFloat(FLOAT_FOG_INTENSITY):setEnableAdmin(false);
--         else
--             local val = self.sliderFogSlider:getCurrentValue();
--             clim:getClimateFloat(FLOAT_FOG_INTENSITY):setEnableAdmin(true);
--             clim:getClimateFloat(FLOAT_FOG_INTENSITY):setAdminValue(val);
--         end
