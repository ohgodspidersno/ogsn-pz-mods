require("ItemTweaker_Copy_ogsn");

if getActivatedMods():contains("SKLDairyModBeta") then
    TweakItem("Base.MilkJar","EvolvedRecipe","HotDrink:2;CommonMallowEvolved:2;LemonGrassEvolved:2;BlackSageEvolved:2;GinsengEvolved:2;EnergizingEvolved:2;MedicinalEvolved:2;OatmealEvolved:2");
    TweakItem("Base.MilkWaterBottle","EvolvedRecipe","HotDrink:2;CommonMallowEvolved:2;LemonGrassEvolved:2;BlackSageEvolved:2;GinsengEvolved:2;EnergizingEvolved:2;MedicinalEvolved:2;OatmealEvolved:2");
    TweakItem("Base.MilkPopBottle","EvolvedRecipe","HotDrink:2;CommonMallowEvolved:2;LemonGrassEvolved:2;BlackSageEvolved:2;GinsengEvolved:2;EnergizingEvolved:2;MedicinalEvolved:2;OatmealEvolved:2");
else end

if getActivatedMods():contains("FMJ") or getActivatedMods():contains("FMJfoodDairy") then
    TweakItem("FMJ.MilkJar","EvolvedRecipe","HotDrink:2;CommonMallowEvolved:2;LemonGrassEvolved:2;BlackSageEvolved:2;GinsengEvolved:2;EnergizingEvolved:2;MedicinalEvolved:2;OatmealEvolved:2");
    TweakItem("FMJ.MilkWaterBottle","EvolvedRecipe","HotDrink:2;CommonMallowEvolved:2;LemonGrassEvolved:2;BlackSageEvolved:2;GinsengEvolved:2;EnergizingEvolved:2;MedicinalEvolved:2;OatmealEvolved:2");
    TweakItem("FMJ.MilkPopBottle","EvolvedRecipe","HotDrink:2;CommonMallowEvolved:2;LemonGrassEvolved:2;BlackSageEvolved:2;GinsengEvolved:2;EnergizingEvolved:2;MedicinalEvolved:2;OatmealEvolved:2");
else end
