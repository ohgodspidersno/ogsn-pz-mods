-- if getActivatedMods():contains("ItemTweakerAPI") then
require("ItemTweaker_Copy_ogsn");
-- else return end
if getActivatedMods():contains("RelaxingTime") then
  TweakItem("filcher.RippedPages","Type","Normal")
end
