require("ItemTweaker_Copy_ogsn");

if getActivatedMods():contains("SKLDairyModBeta") then
    OGSNTweakItem("Base.MilkJar","EvolvedRecipe","HotDrink:2;CommonMallowTeaEvolved:2;LemonGrassTeaEvolved:2;BlackSageTeaEvolved:2;GinsengTeaEvolved:2;EnergizingTeaEvolved:2;MedicinalTeaEvolved:2;OatmealEvolved:2");
    OGSNTweakItem("Base.MilkWaterBottle","EvolvedRecipe","HotDrink:2;CommonMallowTeaEvolved:2;LemonGrassTeaEvolved:2;BlackSageTeaEvolved:2;GinsengTeaEvolved:2;EnergizingTeaEvolved:2;MedicinalTeaEvolved:2;OatmealEvolved:2");
    OGSNTweakItem("Base.MilkPopBottle","EvolvedRecipe","HotDrink:2;CommonMallowTeaEvolved:2;LemonGrassTeaEvolved:2;BlackSageTeaEvolved:2;GinsengTeaEvolved:2;EnergizingTeaEvolved:2;MedicinalTeaEvolved:2;OatmealEvolved:2");
else end

if getActivatedMods():contains("FMJ") or getActivatedMods():contains("FMJfoodDairy") then
    OGSNTweakItem("FMJ.MilkJar","EvolvedRecipe","HotDrink:2;CommonMallowTeaEvolved:2;LemonGrassTeaEvolved:2;BlackSageTeaEvolved:2;GinsengTeaEvolved:2;EnergizingTeaEvolved:2;MedicinalTeaEvolved:2;OatmealEvolved:2");
    OGSNTweakItem("FMJ.MilkWaterBottle","EvolvedRecipe","HotDrink:2;CommonMallowTeaEvolved:2;LemonGrassTeaEvolved:2;BlackSageTeaEvolved:2;GinsengTeaEvolved:2;EnergizingTeaEvolved:2;MedicinalTeaEvolved:2;OatmealEvolved:2");
    OGSNTweakItem("FMJ.MilkPopBottle","EvolvedRecipe","HotDrink:2;CommonMallowTeaEvolved:2;LemonGrassTeaEvolved:2;BlackSageTeaEvolved:2;GinsengTeaEvolved:2;EnergizingTeaEvolved:2;MedicinalTeaEvolved:2;OatmealEvolved:2");
else end
