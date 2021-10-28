require("ItemTweaker_Copy_ogsn");

-- VANILLA ITEMS
OGSNTweakItem("Base.Sugar","EvolvedRecipe","HotDrink:1;CommonMallowTeaEvolved:1;LemonGrassTeaEvolved:1;BlackSageTeaEvolved:1;GinsengTeaEvolved:1;EnergizingTeaEvolved:1;MedicinalTeaEvolved:1");
OGSNTweakItem("Base.Milk","EvolvedRecipe","HotDrink:2;CommonMallowTeaEvolved:2;LemonGrassTeaEvolved:2;BlackSageTeaEvolved:2;GinsengTeaEvolved:2;EnergizingTeaEvolved:2;MedicinalTeaEvolved:2");
OGSNTweakItem("Base.Honey","EvolvedRecipe","HotDrink:5;CommonMallowTeaEvolved:5;LemonGrassTeaEvolved:5;BlackSageTeaEvolved:5;GinsengTeaEvolved:5;EnergizingTeaEvolved:5;MedicinalTeaEvolved:5");

-- MEDICINAL HERBS
OGSNTweakItem("Base.CommonMallow","HungerChange", "-2");
OGSNTweakItem("Base.CommonMallow","Carbohydrates", "6");
OGSNTweakItem("Base.CommonMallow","Proteins", "2");
OGSNTweakItem("Base.CommonMallow","Lipids", "1");
OGSNTweakItem("Base.CommonMallow","Calories", "36");
OGSNTweakItem("Base.CommonMallow","FoodType", "Herbal");
OGSNTweakItem("Base.CommonMallow","EvolvedRecipe", "Soup:2;Stew:2;Pie:2;Stir fry:2;Stir fry Griddle Pan:2;Roasted Vegetables:2;PastaPan:2;RicePan:2;PastaPot:2;RicePot:2");
OGSNTweakItem("Base.CommonMallow","IsCookable","True");
OGSNTweakItem("Base.CommonMallow","MinutesToCook","120");
OGSNTweakItem("Base.CommonMallow","MinutesToBurn","150");
OGSNTweakItem("Base.CommonMallow","OnCooked","CookRawHerbOGSN");

OGSNTweakItem("Base.LemonGrass","Spice","True");
OGSNTweakItem("Base.LemonGrass","FoodType","Herbal");
OGSNTweakItem("Base.LemonGrass","EvolvedRecipe","Soup:1;Stew:1;Pie:1;Cake:1;Stir fry:1;Stir fry Griddle Pan:1;Roasted Vegetables:1;Sandwich:1;Burger:1;Salad:1;FruitSalad:1;PastaPan:1;RicePan:1;PastaPot:1;RicePot:1");
OGSNTweakItem("Base.LemonGrass","IsCookable","True");
OGSNTweakItem("Base.LemonGrass","MinutesToCook","120");
OGSNTweakItem("Base.LemonGrass","MinutesToBurn","150");
OGSNTweakItem("Base.LemonGrass","OnCooked","CookRawHerbOGSN");

OGSNTweakItem("Base.BlackSage","Spice","True");
OGSNTweakItem("Base.BlackSage","FoodType","Herbal");
OGSNTweakItem("Base.BlackSage","EvolvedRecipe","Soup:1;Stew:1;Pie:1;Cake:1;Stir fry:1;Stir fry Griddle Pan:1;Roasted Vegetables:1;Burger:1;PastaPan:1;RicePan:1;PastaPot:1;RicePot:1");
OGSNTweakItem("Base.BlackSage","IsCookable","True");
OGSNTweakItem("Base.BlackSage","MinutesToCook","120");
OGSNTweakItem("Base.BlackSage","MinutesToBurn","150");
OGSNTweakItem("Base.BlackSage","OnCooked","CookRawHerbOGSN");

OGSNTweakItem("Base.Ginseng","Spice","True");
OGSNTweakItem("Base.Ginseng","FoodType","Herbal")
OGSNTweakItem("Base.Ginseng","EvolvedRecipe","Soup:1;Stew:1;Pie:1;Cake:1;Stir fry:1;Stir fry Griddle Pan:1;Roasted Vegetables:1;Salad:1;PastaPan:1;RicePan:1;PastaPot:1;RicePot:1")
OGSNTweakItem("Base.Ginseng","IsCookable","True");
OGSNTweakItem("Base.Ginseng","MinutesToCook","120");
OGSNTweakItem("Base.Ginseng","MinutesToBurn","150");
OGSNTweakItem("Base.Ginseng","OnCooked","CookRawHerbOGSN");

-- FOOD HERBS
OGSNTweakItem("Base.Rosehips","FoodType","Herbal");
OGSNTweakItem("Base.Rosehips","EvolvedRecipe","Soup:3;Stew:3;Pie:3;Cake:3;Stir fry:3;Stir fry Griddle Pan:3;Roasted Vegetables:3;Burger:3;Salad:3;PastaPan:3;RicePan:3;PastaPot:3;RicePot:3;HotDrink:3;CommonMallowTeaEvolved:3;LemonGrassTeaEvolved:3;BlackSageTeaEvolved:3;GinsengTeaEvolved:3;EnergizingTeaEvolved:3;MedicinalTeaEvolved:3");
OGSNTweakItem("Base.Rosehips","IsCookable","True");
OGSNTweakItem("Base.Rosehips","MinutesToCook","120");
OGSNTweakItem("Base.Rosehips","MinutesToBurn","150");
OGSNTweakItem("Base.Rosehips","OnCooked","CookRawHerbOGSN");

OGSNTweakItem("Base.GrapeLeaves","FoodType","Herbal");
OGSNTweakItem("Base.GrapeLeaves","EvolvedRecipe","Soup:2;Stew:2;Pie:2;Stir fry:2;Stir fry Griddle Pan:2;Roasted Vegetables:2;Burger:2;Salad:2;PastaPan:2;RicePan:2;PastaPot:2;RicePot:2;HotDrink:2;CommonMallowTeaEvolved:2;LemonGrassTeaEvolved:2;BlackSageTeaEvolved:2;GinsengTeaEvolved:2;EnergizingTeaEvolved:2;MedicinalTeaEvolved:2");
OGSNTweakItem("Base.GrapeLeaves","IsCookable","True");
OGSNTweakItem("Base.GrapeLeaves","MinutesToCook","120");
OGSNTweakItem("Base.GrapeLeaves","MinutesToBurn","150");
OGSNTweakItem("Base.GrapeLeaves","OnCooked","CookRawHerbOGSN");

OGSNTweakItem("Base.Violets","FoodType","Herbal");
OGSNTweakItem("Base.Violets","EvolvedRecipe","Soup:2;Stew:2;Pie:2;Cake:2;Stir fry:2;Stir fry Griddle Pan:2;Roasted Vegetables:2;Salad:2;FruitSalad:2;PastaPan:2;RicePan:2;PastaPot:2;RicePot:2;HotDrink:2;CommonMallowTeaEvolved:2;LemonGrassTeaEvolved:2;BlackSageTeaEvolved:2;GinsengTeaEvolved:2;EnergizingTeaEvolved:2;MedicinalTeaEvolved:2");
OGSNTweakItem("Base.Violets","IsCookable","True");
OGSNTweakItem("Base.Violets","MinutesToCook","120");
OGSNTweakItem("Base.Violets","MinutesToBurn","150");
OGSNTweakItem("Base.Violets","OnCooked","CookRawHerbOGSN");

-- COMPATIBILITY WITH OTHER FOOD MODS
if getActivatedMods():contains("AAApoc") then
    OGSNTweakItem("Base.LemonGrass","EvolvedRecipe","Soup:1;Stew:1;Pie:1;Cake:1;Stir fry:1;Stir fry Griddle Pan:1;Roasted Vegetables:1;Sandwich:1;Burger:1;Salad:1;FruitSalad:1;PastaPan:1;RicePan:1;PastaPot:1;RicePot:1;AAAHotDogEV:1;AAACorndog:1");
    OGSNTweakItem("Base.WildGarlic","EvolvedRecipe","Soup:1;Stew:1;Pie:1;Stir fry:1;Stir fry Griddle Pan:1;Roasted Vegetables:1;Burger:1;Salad:1;PastaPan:1;RicePan:1;PastaPot:1;RicePot:1;AAAHotDogEV:1;AAACorndog:1");
    OGSNTweakItem("Base.LemonGrassDried","EvolvedRecipe","Soup:1;Stew:1;Pie:1;Cake:1;Stir fry:1;Stir fry Griddle Pan:1;Roasted Vegetables:1;Sandwich:1;Burger:1;Salad:1;FruitSalad:1;PastaPan:1;RicePan:1;PastaPot:1;RicePot:1;AAAHotDogEV:1;AAACorndog:1");
    OGSNTweakItem("Base.WildGarlicDried","EvolvedRecipe","Soup:1;Stew:1;Pie:1;Stir fry:1;Stir fry Griddle Pan:1;Roasted Vegetables:1;Burger:1;Salad:1;PastaPan:1;RicePan:1;PastaPot:1;RicePot:1;AAAHotDogEV:1;AAACorndog:1");
else end
