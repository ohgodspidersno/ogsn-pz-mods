require("ItemTweaker_Copy_ogsn");
-- Plantain
TweakItem("Base.Plantain","HungerChange","-2");
TweakItem("Base.Plantain","Weight","0.1");
TweakItem("Base.Plantain","Type","Food");
TweakItem("Base.Plantain","DisplayName","Plantain");
TweakItem("Base.Plantain","Icon","PlantainPlantago");
TweakItem("Base.Plantain","Tooltip","Tooltip_Plantain");
TweakItem("Base.Plantain","Carbohydrates","6"); --24
TweakItem("Base.Plantain","Proteins","2");  --10
TweakItem("Base.Plantain","Lipids","1"); --9
TweakItem("Base.Plantain","Calories","55");--(9+10+24)*1.28 (PZ's weird coefficient) =
TweakItem("Base.Plantain","FoodType","Herbal");
TweakItem("Base.Plantain","EvolvedRecipe","Soup:2;Stew:2;Pie:2;Cake:2;Stir fry:2;Stir fry Griddle Pan:2;Roasted Vegetables:2;Burger:2;Salad:2;PastaPan:2;RicePan:2;PastaPot:2;RicePot:2;HotDrink:2;CommonMallowTeaEvolved:2;LemonGrassTeaEvolved:2;BlackSageTeaEvolved:2;GinsengTeaEvolved:2");
TweakItem("Base.Plantain","CantBeFrozen","False");
TweakItem("Base.Plantain","MinutesToCook","120");
TweakItem("Base.Plantain","MinutesToBurn","150");
TweakItem("Base.Plantain","OnCooked","CookRawHerbOGSN");
-- WildGarlic
TweakItem("Base.WildGarlic","HungerChange","-1");
TweakItem("Base.WildGarlic","Weight","0.1");
TweakItem("Base.WildGarlic","Type","Food");
TweakItem("Base.WildGarlic","DisplayName","Wild Garlic");
TweakItem("Base.WildGarlic","Icon","WildGarlic");
TweakItem("Base.WildGarlic","Tooltip","Tooltip_Garlic");
TweakItem("Base.WildGarlic","Proteins","1"); --5
TweakItem("Base.WildGarlic","Carbohydrates","2"); --8
TweakItem("Base.WildGarlic","Lipids","0"); -- 0
TweakItem("Base.WildGarlic","Calories","16"); -- (5+8)*1.28 (PZ's weird coefficient) = 16.64
TweakItem("Base.WildGarlic","Spice","True");
TweakItem("Base.WildGarlic","FoodType","Herbal");
TweakItem("Base.WildGarlic","EvolvedRecipe","Soup:1;Stew:1;Pie:1;Stir fry:1;Stir fry Griddle Pan:1;Roasted Vegetables:1;Burger:1;Salad:1;PastaPan:1;RicePan:1;PastaPot:1;RicePot:1;HotDrink:1;CommonMallowTeaEvolved:1;LemonGrassTeaEvolved:1;BlackSageTeaEvolved:1;GinsengTeaEvolved:1");
TweakItem("Base.WildGarlic","CantBeFrozen","False");
TweakItem("Base.WildGarlic","MinutesToCook","120");
TweakItem("Base.WildGarlic","MinutesToBurn","150");
TweakItem("Base.WildGarlic","OnCooked","CookRawHerbOGSN");
