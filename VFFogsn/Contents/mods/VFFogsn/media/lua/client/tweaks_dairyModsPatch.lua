require("ItemTweaker_Copy_ogsn");

if getActivatedMods():contains("SKLDairyModBeta") then
    TweakItem("Base.MilkJar","EvolvedRecipe","HotDrink:2;CommonMallowTeaEvolved:2;LemonGrassTeaEvolved:2;BlackSageTeaEvolved:2;GinsengTeaEvolved:2;EnergizingTeaEvolved:2;MedicinalTeaEvolved:2;OatmealEvolved:2");
    TweakItem("Base.MilkWaterBottle","EvolvedRecipe","HotDrink:2;CommonMallowTeaEvolved:2;LemonGrassTeaEvolved:2;BlackSageTeaEvolved:2;GinsengTeaEvolved:2;EnergizingTeaEvolved:2;MedicinalTeaEvolved:2;OatmealEvolved:2");
    TweakItem("Base.MilkPopBottle","EvolvedRecipe","HotDrink:2;CommonMallowTeaEvolved:2;LemonGrassTeaEvolved:2;BlackSageTeaEvolved:2;GinsengTeaEvolved:2;EnergizingTeaEvolved:2;MedicinalTeaEvolved:2;OatmealEvolved:2");
else end

if getActivatedMods():contains("FMJ") or getActivatedMods():contains("FMJfoodDairy") then
    TweakItem("FMJ.MilkJar","EvolvedRecipe","HotDrink:2;CommonMallowTeaEvolved:2;LemonGrassTeaEvolved:2;BlackSageTeaEvolved:2;GinsengTeaEvolved:2;EnergizingTeaEvolved:2;MedicinalTeaEvolved:2;OatmealEvolved:2");
    TweakItem("FMJ.MilkWaterBottle","EvolvedRecipe","HotDrink:2;CommonMallowTeaEvolved:2;LemonGrassTeaEvolved:2;BlackSageTeaEvolved:2;GinsengTeaEvolved:2;EnergizingTeaEvolved:2;MedicinalTeaEvolved:2;OatmealEvolved:2");
    TweakItem("FMJ.MilkPopBottle","EvolvedRecipe","HotDrink:2;CommonMallowTeaEvolved:2;LemonGrassTeaEvolved:2;BlackSageTeaEvolved:2;GinsengTeaEvolved:2;EnergizingTeaEvolved:2;MedicinalTeaEvolved:2;OatmealEvolved:2");
else end
