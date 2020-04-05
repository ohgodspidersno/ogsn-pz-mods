require("ItemTweaker_Copy_ogsn");

-- beans
TweakItem("Base.BeanBowl","UnhappyChange","-5");
TweakItem("Base.OpenBeans","FoodType","Vegetables");
TweakItem("Base.OpenBeans","UnhappyChange","0");
TweakItem("Base.OpenBeans","EvolvedRecipe","Soup:25;Stew:25;Pie:25;Stir fry:25;Stir fry Griddle Pan:25;Roasted Vegetables:25;Salad:25;RicePan:25;RicePot:25");

-- oatmeal
TweakItem("Lemon","EvolvedRecipe","VanillaFoodFixesOGSN.OatmealEvolved:10");
-- TweakItem("Lemon","EvolvedRecipe","Cake:10;FruitSalad:10;VanillaFoodFixesOGSN.OatmealEvolved:10");
-- TweakItem("BerryBlack","EvolvedRecipe","Cake:10;FruitSalad:10;VanillaFoodFixesOGSN.OatmealEvolved:10");
-- TweakItem("BerryBlue","EvolvedRecipe","Cake:10;FruitSalad:10;VanillaFoodFixesOGSN.OatmealEvolved:10");
-- TweakItem("BerryGeneric1","EvolvedRecipe","Cake:5;FruitSalad:5;VanillaFoodFixesOGSN.OatmealEvolved:5");
-- TweakItem("BerryGeneric2","EvolvedRecipe","Cake:10;FruitSalad:10;VanillaFoodFixesOGSN.OatmealEvolved:10");
-- TweakItem("BerryGeneric3","EvolvedRecipe","Cake:5;FruitSalad:5;VanillaFoodFixesOGSN.OatmealEvolved:5");
-- TweakItem("BerryGeneric4","EvolvedRecipe","Cake:10;FruitSalad:10;VanillaFoodFixesOGSN.OatmealEvolved:10");
-- TweakItem("BerryGeneric5","EvolvedRecipe","Cake:10;FruitSalad:10;VanillaFoodFixesOGSN.OatmealEvolved:10");
-- TweakItem("Peach","EvolvedRecipe","Cake:6;FruitSalad:6;VanillaFoodFixesOGSN.OatmealEvolved:6");
-- TweakItem("Pineapple","EvolvedRecipe","Cake:10;FruitSalad:10;VanillaFoodFixesOGSN.OatmealEvolved:10");
-- TweakItem("Cherry","EvolvedRecipe","Cake:3;FruitSalad:3;VanillaFoodFixesOGSN.OatmealEvolved:3");
-- TweakItem("Watermelon","EvolvedRecipe","Salad:10;FruitSalad:10;VanillaFoodFixesOGSN.OatmealEvolved:10");
-- TweakItem("WatermelonSliced","EvolvedRecipe","Salad:100;FruitSalad:100;VanillaFoodFixesOGSN.OatmealEvolved:100");
-- TweakItem("WatermelonSmashed","EvolvedRecipe","Salad:100;FruitSalad:100;VanillaFoodFixesOGSN.OatmealEvolved:100");
-- TweakItem("Grapes","EvolvedRecipe","Cake:15;FruitSalad:15;VanillaFoodFixesOGSN.OatmealEvolved:15");
-- TweakItem("Orange","EvolvedRecipe","Cake:8;FruitSalad:8;VanillaFoodFixesOGSN.OatmealEvolved:8");
-- TweakItem("Apple","EvolvedRecipe","Cake:8;FruitSalad:8;VanillaFoodFixesOGSN.OatmealEvolved:8");
-- TweakItem("Banana","EvolvedRecipe","Cake:10;FruitSalad:10;VanillaFoodFixesOGSN.OatmealEvolved:10");
-- TweakItem("Milk","EvolvedRecipe","HotDrink:2;VanillaFoodFixesOGSN.OatmealEvolved:2");
-- TweakItem("Butter","EvolvedRecipe","Sandwich:5;Stir fry Griddle Pan:5;Stir fry:5;Roasted Vegetables:5;PastaPot:5;PastaPan:5;VanillaFoodFixesOGSN.OatmealEvolved:5");
-- TweakItem("Peanuts","EvolvedRecipe","RicePot:8;RicePan:8;VanillaFoodFixesOGSN.OatmealEvolved:8");
-- TweakItem("Honey","EvolvedRecipe","Cake:5;Sandwich:5;Salad:5;Roasted Vegetables:5;Stir fry Griddle Pan:5;Stir fry:5;HotDrink:5;VanillaFoodFixesOGSN.OatmealEvolved:5");
-- TweakItem("Modjeska","EvolvedRecipe","VanillaFoodFixesOGSN.OatmealEvolved:10");

-- if getActivatedMods():contains("AAApoc") then
--     TweakItem("Base.AAAVanillaExtract","EvolvedRecipe", "Soup:1;Stew:1;Pie:1;Stir fry Griddle Pan:1;Stir fry:1;Burger:1;Salad:1;Roasted Vegetables:1;RicePot:1;RicePan:1;PastaPot:1;PastaPan:1;VanillaFoodFixesOGSN.OatmealEvolved:1");
-- else end
--
-- if getActivatedMods():contains("SKLDairyModBeta") then
--     TweakItem("Base.MilkJar","EvolvedRecipe","HotDrink:2;VanillaFoodFixesOGSN.OatmealEvolved:2")
--     TweakItem("Base.MilkWaterBottle","EvolvedRecipe","HotDrink:2;VanillaFoodFixesOGSN.OatmealEvolved:2")
--     TweakItem("Base.MilkPopBottle","EvolvedRecipe","HotDrink:2;VanillaFoodFixesOGSN.OatmealEvolved:2")
-- else end
--
-- if getActivatedMods():contains("SKLDairyModBeta") and getActivatedMods():contains("CookWithHerbs") then
--     TweakItem("Base.MilkJar","EvolvedRecipe","HotDrink:2;VanillaFoodFixesOGSN.Evolved_CommonMallow:2;VanillaFoodFixesOGSN.Evolved_LemonGrass:2;VanillaFoodFixesOGSN.Evolved_BlackSage:2;VanillaFoodFixesOGSN.Evolved_Ginseng:2;VanillaFoodFixesOGSN.Evolved_Energizing:2;VanillaFoodFixesOGSN.Evolved_Medicinal:2;VanillaFoodFixesOGSN.OatmealEvolved:2");
--     TweakItem("Base.MilkWaterBottle","EvolvedRecipe","HotDrink:2;VanillaFoodFixesOGSN.Evolved_CommonMallow:2;VanillaFoodFixesOGSN.Evolved_LemonGrass:2;VanillaFoodFixesOGSN.Evolved_BlackSage:2;VanillaFoodFixesOGSN.Evolved_Ginseng:2;VanillaFoodFixesOGSN.Evolved_Energizing:2;VanillaFoodFixesOGSN.Evolved_Medicinal:2;VanillaFoodFixesOGSN.OatmealEvolved:2");
--     TweakItem("Base.MilkPopBottle","EvolvedRecipe","HotDrink:2;VanillaFoodFixesOGSN.Evolved_CommonMallow:2;VanillaFoodFixesOGSN.Evolved_LemonGrass:2;VanillaFoodFixesOGSN.Evolved_BlackSage:2;VanillaFoodFixesOGSN.Evolved_Ginseng:2;VanillaFoodFixesOGSN.Evolved_Energizing:2;VanillaFoodFixesOGSN.Evolved_Medicinal:2;VanillaFoodFixesOGSN.OatmealEvolved:2");
-- else end
