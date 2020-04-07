require("ItemTweaker_Copy_ogsn");

if getActivatedMods():contains("SKLDairyModBeta") then
    TweakItem("Base.MilkJar","EvolvedRecipe","HotDrink:2;Evolved_CommonMallow:2;Evolved_LemonGrass:2;Evolved_BlackSage:2;Evolved_Ginseng:2;Evolved_Energizing:2;Evolved_Medicinal:2;OatmealEvolved:2");
    TweakItem("Base.MilkWaterBottle","EvolvedRecipe","HotDrink:2;Evolved_CommonMallow:2;Evolved_LemonGrass:2;Evolved_BlackSage:2;Evolved_Ginseng:2;Evolved_Energizing:2;Evolved_Medicinal:2;OatmealEvolved:2");
    TweakItem("Base.MilkPopBottle","EvolvedRecipe","HotDrink:2;Evolved_CommonMallow:2;Evolved_LemonGrass:2;Evolved_BlackSage:2;Evolved_Ginseng:2;Evolved_Energizing:2;Evolved_Medicinal:2;OatmealEvolved:2");
else end

if getActivatedMods():contains("FMJ") or getActivatedMods():contains("FMJfoodDairy") then
    TweakItem("FMJ.MilkJar","EvolvedRecipe","HotDrink:2;Evolved_CommonMallow:2;Evolved_LemonGrass:2;Evolved_BlackSage:2;Evolved_Ginseng:2;Evolved_Energizing:2;Evolved_Medicinal:2;OatmealEvolved:2");
    TweakItem("FMJ.MilkWaterBottle","EvolvedRecipe","HotDrink:2;Evolved_CommonMallow:2;Evolved_LemonGrass:2;Evolved_BlackSage:2;Evolved_Ginseng:2;Evolved_Energizing:2;Evolved_Medicinal:2;OatmealEvolved:2");
    TweakItem("FMJ.MilkPopBottle","EvolvedRecipe","HotDrink:2;Evolved_CommonMallow:2;Evolved_LemonGrass:2;Evolved_BlackSage:2;Evolved_Ginseng:2;Evolved_Energizing:2;Evolved_Medicinal:2;OatmealEvolved:2");
else end
