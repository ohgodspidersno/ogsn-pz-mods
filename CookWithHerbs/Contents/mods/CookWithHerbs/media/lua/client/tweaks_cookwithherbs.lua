require("ItemTweaker_Copy_ogsn");

-- VANILLA ITEMS
TweakItem("Base.Sugar","EvolvedRecipe","HotDrink:1;Evolved_CommonMallow:1;Evolved_LemonGrass:1;Evolved_BlackSage:1;Evolved_Ginseng:1;Evolved_Energizing:1;Evolved_Medicinal:1");
TweakItem("Base.Milk","EvolvedRecipe","HotDrink:2;Evolved_CommonMallow:2;Evolved_LemonGrass:2;Evolved_BlackSage:2;Evolved_Ginseng:2;Evolved_Energizing:2;Evolved_Medicinal:2");
TweakItem("Base.Honey","EvolvedRecipe","HotDrink:5;Evolved_CommonMallow:5;Evolved_LemonGrass:5;Evolved_BlackSage:5;Evolved_Ginseng:5;Evolved_Energizing:5;Evolved_Medicinal:5");

-- MEDICINAL HERBS
TweakItem("Base.CommonMallow","HungerChange", "-2");
TweakItem("Base.CommonMallow","Carbohydrates", "6");
TweakItem("Base.CommonMallow","Proteins", "2");
TweakItem("Base.CommonMallow","Lipids", "1");
TweakItem("Base.CommonMallow","Calories", "36");
TweakItem("Base.CommonMallow","FoodType", "Herbal");
TweakItem("Base.CommonMallow","EvolvedRecipe", "Soup:2;Stew:2;Pie:2;Stir fry:2;Stir fry Griddle Pan:2;Roasted Vegetables:2;PastaPan:2;RicePan:2;PastaPot:2;RicePot:2");

TweakItem("Base.LemonGrass","Spice","True");
TweakItem("Base.LemonGrass","FoodType","Herbal");
TweakItem("Base.LemonGrass","EvolvedRecipe","Soup:1;Stew:1;Pie:1;Cake:1;Stir fry:1;Stir fry Griddle Pan:1;Roasted Vegetables:1;Sandwich:1;Burger:1;Salad:1;FruitSalad:1;PastaPan:1;RicePan:1;PastaPot:1;RicePot:1");

TweakItem("Base.BlackSage","Spice","True");
TweakItem("Base.BlackSage","FoodType","Herbal");
TweakItem("Base.BlackSage","EvolvedRecipe","Soup:1;Stew:1;Pie:1;Cake:1;Stir fry:1;Stir fry Griddle Pan:1;Roasted Vegetables:1;Burger:1;PastaPan:1;RicePan:1;PastaPot:1;RicePot:1");

TweakItem("Base.Ginseng","Spice","True");
TweakItem("Base.Ginseng","FoodType","Herbal")
TweakItem("Base.Ginseng","EvolvedRecipe","Soup:1;Stew:1;Pie:1;Cake:1;Stir fry:1;Stir fry Griddle Pan:1;Roasted Vegetables:1;Salad:1;PastaPan:1;RicePan:1;PastaPot:1;RicePot:1")

-- FOOD HERBS
TweakItem("Base.Rosehips","FoodType","Herbal");
TweakItem("Base.Rosehips","EvolvedRecipe","Soup:3;Stew:3;Pie:3;Cake:3;Stir fry:3;Stir fry Griddle Pan:3;Roasted Vegetables:3;Burger:3;Salad:3;PastaPan:3;RicePan:3;PastaPot:3;RicePot:3;HotDrink:3;Evolved_CommonMallow:3;Evolved_LemonGrass:3;Evolved_BlackSage:3;Evolved_Ginseng:3;Evolved_Energizing:3;Evolved_Medicinal:3");

TweakItem("Base.GrapeLeaves","FoodType","Herbal")
TweakItem("Base.GrapeLeaves","EvolvedRecipe","Soup:2;Stew:2;Pie:2;Stir fry:2;Stir fry Griddle Pan:2;Roasted Vegetables:2;Salad:2;PastaPan:2;RicePan:2;PastaPot:2;RicePot:2;HotDrink:2;Evolved_CommonMallow:2;Evolved_LemonGrass:2;Evolved_BlackSage:2;Evolved_Ginseng:2;Evolved_Energizing:2;Evolved_Medicinal:2")

TweakItem("Base.Violets","FoodType","Herbal")
TweakItem("Base.Violets","EvolvedRecipe","Soup:2;Stew:2;Pie:2;Cake:2;Stir fry:2;Stir fry Griddle Pan:2;Roasted Vegetables:2;Salad:2;FruitSalad:2;PastaPan:2;RicePan:2;PastaPot:2;RicePot:2;HotDrink:2;Evolved_CommonMallow:2;Evolved_LemonGrass:2;Evolved_BlackSage:2;Evolved_Ginseng:2;Evolved_Energizing:2;Evolved_Medicinal:2")

-- COMPATIBILITY WITH OTHER FOOD MODS
if getActivatedMods():contains("AAApoc") then
    TweakItem("Base.LemonGrass","EvolvedRecipe","Soup:1;Stew:1;Pie:1;Cake:1;Stir fry:1;Stir fry Griddle Pan:1;Roasted Vegetables:1;Sandwich:1;Burger:1;Salad:1;FruitSalad:1;PastaPan:1;RicePan:1;PastaPot:1;RicePot:1;AAAHotDog:1;AAAChiliDog:1;AAAToast:1");
    TweakItem("Base.BlackSage","EvolvedRecipe","Soup:1;Stew:1;Pie:1;Cake:1;Stir fry:1;Stir fry Griddle Pan:1;Roasted Vegetables:1;Burger:1;PastaPan:1;RicePan:1;PastaPot:1;RicePot:1;AAAHotDog:1;AAAChiliDog:1;AAAToast:1");
    TweakItem("Base.WildGarlic","EvolvedRecipe","Soup:1;Stew:1;Pie:1;Stir fry:1;Stir fry Griddle Pan:1;Roasted Vegetables:1;Burger:1;Salad:1;PastaPan:1;RicePan:1;PastaPot:1;RicePot:1;AAAHotDog:1;AAAChiliDog:1;AAAToast:1");
else end

if getActivatedMods():contains("SKLDairyModBeta") then
    TweakItem("Base.MilkJar","HotDrink:2;Evolved_CommonMallow:2;Evolved_LemonGrass:2;Evolved_BlackSage:2;Evolved_Ginseng:2;Evolved_Energizing:2;Evolved_Medicinal:2");
    TweakItem("Base.MilkWaterBottle","HotDrink:2;Evolved_CommonMallow:2;Evolved_LemonGrass:2;Evolved_BlackSage:2;Evolved_Ginseng:2;Evolved_Energizing:2;Evolved_Medicinal:2");
    TweakItem("Base.MilkPopBottle","HotDrink:2;Evolved_CommonMallow:2;Evolved_LemonGrass:2;Evolved_BlackSage:2;Evolved_Ginseng:2;Evolved_Energizing:2;Evolved_Medicinal:2");
else end

if getActivatedMods():contains("SKLDairyModBeta") and getActivatedMods():contains("WarOnBeans") then
    TweakItem("Base.MilkJar","EvolvedRecipe","HotDrink:2;Evolved_CommonMallow:2;Evolved_LemonGrass:2;Evolved_BlackSage:2;Evolved_Ginseng:2;Evolved_Energizing:2;Evolved_Medicinal:2;OatmealEvolved:2");
    TweakItem("Base.MilkWaterBottle","EvolvedRecipe","HotDrink:2;Evolved_CommonMallow:2;Evolved_LemonGrass:2;Evolved_BlackSage:2;Evolved_Ginseng:2;Evolved_Energizing:2;Evolved_Medicinal:2;OatmealEvolved:2");
    TweakItem("Base.MilkPopBottle","EvolvedRecipe","HotDrink:2;Evolved_CommonMallow:2;Evolved_LemonGrass:2;Evolved_BlackSage:2;Evolved_Ginseng:2;Evolved_Energizing:2;Evolved_Medicinal:2;OatmealEvolved:2");
else end
