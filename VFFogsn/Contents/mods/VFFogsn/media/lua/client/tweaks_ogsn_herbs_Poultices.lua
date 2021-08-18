require("ItemTweaker_Copy_ogsn");
-- Plantain
OGSNTweakItem("Base.Plantain","HungerChange","-2");
OGSNTweakItem("Base.Plantain","Weight","0.1");
OGSNTweakItem("Base.Plantain","Type","Food");
OGSNTweakItem("Base.Plantain","DisplayName","Plantain");
OGSNTweakItem("Base.Plantain","Icon","PlantainPlantago");
OGSNTweakItem("Base.Plantain","Tooltip","Tooltip_Plantain");
OGSNTweakItem("Base.Plantain","Carbohydrates","6"); --24
OGSNTweakItem("Base.Plantain","Proteins","2");  --10
OGSNTweakItem("Base.Plantain","Lipids","1"); --9
OGSNTweakItem("Base.Plantain","Calories","55");--(9+10+24)*1.28 (PZ's weird coefficient) =
OGSNTweakItem("Base.Plantain","FoodType","Herbal");
OGSNTweakItem("Base.Plantain","EvolvedRecipe","Soup:2;Stew:2;Pie:2;Cake:2;Stir fry:2;Stir fry Griddle Pan:2;Roasted Vegetables:2;Burger:2;Salad:2;PastaPan:2;RicePan:2;PastaPot:2;RicePot:2;HotDrink:2;CommonMallowTeaEvolved:2;LemonGrassTeaEvolved:2;BlackSageTeaEvolved:2;GinsengTeaEvolved:2");
OGSNTweakItem("Base.Plantain","CantBeFrozen","False");
OGSNTweakItem("Base.Plantain","MinutesToCook","120");
OGSNTweakItem("Base.Plantain","MinutesToBurn","150");
OGSNTweakItem("Base.Plantain","OnCooked","CookRawHerbOGSN");
OGSNTweakItem("Base.Plantain","IsCookable","True");
-- WildGarlic
OGSNTweakItem("Base.WildGarlic","HungerChange","-1");
OGSNTweakItem("Base.WildGarlic","Weight","0.1");
OGSNTweakItem("Base.WildGarlic","Type","Food");
OGSNTweakItem("Base.WildGarlic","DisplayName","Wild Garlic");
OGSNTweakItem("Base.WildGarlic","Icon","WildGarlic");
OGSNTweakItem("Base.WildGarlic","Tooltip","Tooltip_Garlic");
OGSNTweakItem("Base.WildGarlic","Proteins","1"); --5
OGSNTweakItem("Base.WildGarlic","Carbohydrates","2"); --8
OGSNTweakItem("Base.WildGarlic","Lipids","0"); -- 0
OGSNTweakItem("Base.WildGarlic","Calories","16"); -- (5+8)*1.28 (PZ's weird coefficient) = 16.64
OGSNTweakItem("Base.WildGarlic","Spice","True");
OGSNTweakItem("Base.WildGarlic","FoodType","Herbal");
OGSNTweakItem("Base.WildGarlic","EvolvedRecipe","Soup:1;Stew:1;Pie:1;Stir fry:1;Stir fry Griddle Pan:1;Roasted Vegetables:1;Burger:1;Salad:1;PastaPan:1;RicePan:1;PastaPot:1;RicePot:1;HotDrink:1;CommonMallowTeaEvolved:1;LemonGrassTeaEvolved:1;BlackSageTeaEvolved:1;GinsengTeaEvolved:1");
OGSNTweakItem("Base.WildGarlic","CantBeFrozen","False");
OGSNTweakItem("Base.WildGarlic","MinutesToCook","120");
OGSNTweakItem("Base.WildGarlic","MinutesToBurn","150");
OGSNTweakItem("Base.WildGarlic","OnCooked","CookRawHerbOGSN");
OGSNTweakItem("Base.WildGarlic","IsCookable","True");

if getActivatedMods():contains("ForkMJsuperGarlic") then
  OGSNTweakItem("Base.WildGarlic","UnhappyChange","10");
  OGSNTweakItem("Base.WildGarlic","HungerChange","-8");
  OGSNTweakItem("Base.WildGarlic","ReduceInfectionPower","4");
  OGSNTweakItem("Base.WildGarlic","Carbohydrates","9");
  OGSNTweakItem("Base.WildGarlic","Proteins","4.2");
  OGSNTweakItem("Base.WildGarlic","Lipids","0.3");
  OGSNTweakItem("Base.WildGarlic","Calories","88");
end
