require("ItemTweaker_Copy_ogsn");

if not getActivatedMods():contains("VFFogsn") then -- only want to make these changes once
  OGSNTweakItem("Base.WildGarlic","UnhappyChange","10");
  OGSNTweakItem("Base.WildGarlic","HungerChange","-8");
  OGSNTweakItem("Base.WildGarlic","ReduceInfectionPower","4");
  OGSNTweakItem("Base.WildGarlic","Spice","true");
  OGSNTweakItem("Base.WildGarlic","EvolvedRecipe","Soup:3;Pie:1;Stir fry:3;Stir fry Griddle Pan:3;Burger:1;Salad:2;Roasted Vegetables:3;RicePot:3;RicePan:3;PastaPot:3;PastaPan:3");
  OGSNTweakItem("Base.WildGarlic","Carbohydrates","9");
  OGSNTweakItem("Base.WildGarlic","Proteins","4.2");
  OGSNTweakItem("Base.WildGarlic","Lipids","0.3");
  OGSNTweakItem("Base.WildGarlic","Calories","88");
  OGSNTweakItem("Base.WildGarlic","CantBeFrozen","true");
end
