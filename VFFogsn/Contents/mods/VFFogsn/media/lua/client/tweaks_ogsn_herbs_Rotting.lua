require("ItemTweaker_Copy_ogsn");

-- If they've activatated the herbs never rot optional submod, then it stops here
if getActivatedMods():contains("VFFogsn_herbsNoRot") then
  return end

-- Otherwise it gives them rottable attributes
OGSNTweakItem("Base.CommonMallow","DaysFresh","7");
OGSNTweakItem("Base.LemonGrass","DaysFresh","7");
OGSNTweakItem("Base.BlackSage","DaysFresh","7");
OGSNTweakItem("Base.Ginseng","DaysFresh","7");
OGSNTweakItem("Base.Rosehips","DaysFresh","7");
OGSNTweakItem("Base.GrapeLeaves","DaysFresh","7");
OGSNTweakItem("Base.Violets","DaysFresh","7");

OGSNTweakItem("Base.CommonMallow","DaysTotallyRotten","30");
OGSNTweakItem("Base.LemonGrass","DaysTotallyRotten","30");
OGSNTweakItem("Base.BlackSage","DaysTotallyRotten","30");
OGSNTweakItem("Base.Ginseng","DaysTotallyRotten","30");
OGSNTweakItem("Base.Rosehips","DaysTotallyRotten","30");
OGSNTweakItem("Base.GrapeLeaves","DaysTotallyRotten","30");
OGSNTweakItem("Base.Violets","DaysTotallyRotten","30");

OGSNTweakItem("Base.Plantain","DaysFresh","7");
OGSNTweakItem("Base.WildGarlic","DaysFresh","7");
OGSNTweakItem("Base.Plantain","DaysTotallyRotten","30");
OGSNTweakItem("Base.WildGarlic","DaysTotallyRotten","30");
