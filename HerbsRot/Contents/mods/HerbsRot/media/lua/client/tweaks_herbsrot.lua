-- if getActivatedMods():contains("ItemTweakerAPI") then
require("ItemTweaker_Copy_ogsn");
-- else return end

TweakItem("Base.CommonMallow","DaysFresh","7");
TweakItem("Base.LemonGrass","DaysFresh","7");
TweakItem("Base.BlackSage","DaysFresh","7");
TweakItem("Base.Ginseng","DaysFresh","7");
TweakItem("Base.Rosehips","DaysFresh","7");
TweakItem("Base.GrapeLeaves","DaysFresh","7");
TweakItem("Base.Violets","DaysFresh","7");

TweakItem("Base.CommonMallow","DaysTotallyRotten","30");
TweakItem("Base.LemonGrass","DaysTotallyRotten","30");
TweakItem("Base.BlackSage","DaysTotallyRotten","30");
TweakItem("Base.Ginseng","DaysTotallyRotten","30");
TweakItem("Base.Rosehips","DaysTotallyRotten","30");
TweakItem("Base.GrapeLeaves","DaysTotallyRotten","30");
TweakItem("Base.Violets","DaysTotallyRotten","30");

if getActivatedMods():contains("CookWithHerbs") then
    TweakItem("Base.Plantain","DaysFresh","7");
    TweakItem("Base.WildGarlic","DaysFresh","7");
    TweakItem("Base.Plantain","DaysTotallyRotten","30");
    TweakItem("Base.WildGarlic","DaysTotallyRotten","30");
else return end
