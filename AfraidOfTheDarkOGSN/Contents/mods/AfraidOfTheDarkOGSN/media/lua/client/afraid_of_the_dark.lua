-- Events.EveryTenMinutes.Add(NakedAndAfraid.EveryTenMinutes);
-- NakedAndAfraid.EveryTenMinutes = function()
-- 	if pillowmod.brutalstart
-- 		then NakedAndAfraid.BuildingAlarmCheck();
-- 	else end
-- end -- every 10 mins

--  pl:getStats():setPanic(100); -- 0 to 100
-- if not player:HasTrait(trait) then break end
-- local c = clim:getClimateColor(COLOR_GLOBAL_LIGHT):getAdminValue():getInterior();
--         local r = _slider.customData=="LightSliderR_int" and self.sliderLightR_intSlider:getCurrentValue()/255 or c:getRedFloat();
--         local g = _slider.customData=="LightSliderG_int" and self.sliderLightG_intSlider:getCurrentValue()/255 or c:getGreenFloat();
--         local b = _slider.customData=="LightSliderB_int" and self.sliderLightB_intSlider:getCurrentValue()/255 or c:getBlueFloat();
--         local a = _slider.customData=="LightSliderA_int" and self.sliderLightA_intSlider:getCurrentValue()/255 or c:getAlphaFloat();

AfraidOfTheDark = {}

AfraidOfTheDark.EveryTenMinutes = function()
  local player = getPlayer();
  local square = player.getSquare()

  local darkMulti = square:getDarkMulti(pn)
  local targetDarkMulti = square:getTargetDarkMulti(pn)

  local pn = self.gameState:fromLua0("getPlayerIndex")

  local vertLight0 = square:getVertLight(0, pn)
  local vertLight1 = square:getVertLight(1, pn)
  local vertLight2 = square:getVertLight(2, pn)
  local vertLight3 = square:getVertLight(3, pn)

end
