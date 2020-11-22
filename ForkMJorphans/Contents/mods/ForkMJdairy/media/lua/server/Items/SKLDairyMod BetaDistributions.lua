require 'Items/Distributions'
require 'Items/ProceduralDistributions'

-- Procedural Lists
table.insert(ProceduralDistributions["list"]["FridgeOther"].items, "YogurtCulture");
table.insert(ProceduralDistributions["list"]["FridgeOther"].items, 2);

table.insert(ProceduralDistributions["list"]["GigamartBakingMisc"].items, "YogurtCulture");
table.insert(ProceduralDistributions["list"]["GigamartBakingMisc"].items, 2);
table.insert(ProceduralDistributions["list"]["GigamartBakingMisc"].items, "PowderedMilk");
table.insert(ProceduralDistributions["list"]["GigamartBakingMisc"].items, 3);
table.insert(ProceduralDistributions["list"]["GigamartBakingMisc"].junk, "YogurtCulture");
table.insert(ProceduralDistributions["list"]["GigamartBakingMisc"].junk, 2);
table.insert(ProceduralDistributions["list"]["GigamartBakingMisc"].junk, "PowderedMilk");
table.insert(ProceduralDistributions["list"]["GigamartBakingMisc"].junk, 3);

table.insert(ProceduralDistributions["list"]["GigamartPots"].items, "Strainer");
table.insert(ProceduralDistributions["list"]["GigamartPots"].items, 5);
table.insert(ProceduralDistributions["list"]["GigamartPots"].junk, "Strainer");
table.insert(ProceduralDistributions["list"]["GigamartPots"].junk, 2);

table.insert(ProceduralDistributions["list"]["KitchenPots"].items, "Strainer");
table.insert(ProceduralDistributions["list"]["KitchenPots"].items, 5);
table.insert(ProceduralDistributions["list"]["KitchenPots"].junk, "Strainer");
table.insert(ProceduralDistributions["list"]["KitchenPots"].junk, 2);

table.insert(ProceduralDistributions["list"]["KitchenBreakfast"].items, "PowderedMilk");
table.insert(ProceduralDistributions["list"]["KitchenBreakfast"].items, 3);
table.insert(ProceduralDistributions["list"]["KitchenBreakfast"].items, "YogurtCulture");
table.insert(ProceduralDistributions["list"]["KitchenBreakfast"].items, 2);
table.insert(ProceduralDistributions["list"]["KitchenBreakfast"].junk, "PowderedMilk");
table.insert(ProceduralDistributions["list"]["KitchenBreakfast"].junk, 2);
table.insert(ProceduralDistributions["list"]["KitchenBreakfast"].junk, "YogurtCulture");
table.insert(ProceduralDistributions["list"]["KitchenBreakfast"].junk, 1);

table.insert(ProceduralDistributions["list"]["KitchenBook"].items, "DairyCookingMag");
table.insert(ProceduralDistributions["list"]["KitchenBook"].items, 0.1);

-- Burger Kitchen
table.insert(Distributions["burgerkitchen"]["counter"].items, "Strainer");
table.insert(Distributions["burgerkitchen"]["counter"].items, 3);
table.insert(Distributions["burgerkitchen"]["counter"].junk, "Strainer");
table.insert(Distributions["burgerkitchen"]["counter"].junk, 3);

-- Zippee Store
table.insert(Distributions["zippeestore"]["counter"].items, "PowderedMilk");
table.insert(Distributions["zippeestore"]["counter"].items, 2);
table.insert(Distributions["zippeestore"]["crate"].items, "PowderedMilk");
table.insert(Distributions["zippeestore"]["crate"].items, 2);
table.insert(Distributions["zippeestore"]["shelvesmag"].items, "DairyCookingMag");
table.insert(Distributions["zippeestore"]["shelvesmag"].items, 0.2);

-- Grocery
table.insert(Distributions["grocery"]["counter"].items, "PowderedMilk");
table.insert(Distributions["grocery"]["counter"].items, 3);
table.insert(Distributions["grocery"]["shelvesmag"].items, "DairyCookingMag");
table.insert(Distributions["grocery"]["shelvesmag"].items, 0.2);

-- Gigamart Kitchen
table.insert(Distributions["gigamartkitchen"]["counter"].items, "PowderedMilk");
table.insert(Distributions["gigamartkitchen"]["counter"].items, 4);
table.insert(Distributions["gigamartkitchen"]["counter"].items, "Strainer");
table.insert(Distributions["gigamartkitchen"]["counter"].items, 5);
table.insert(Distributions["gigamartkitchen"]["counter"].items, "YogurtCulture");
table.insert(Distributions["gigamartkitchen"]["counter"].items, 2);

-- Gigamart
table.insert(Distributions["gigamart"]["counter"].items, "PowderedMilk");
table.insert(Distributions["gigamart"]["counter"].items, 2);
table.insert(Distributions["gigamart"]["shelvesmag"].items, "DairyCookingMag");
table.insert(Distributions["gigamart"]["shelvesmag"].items, 1);

-- Fossoil
table.insert(Distributions["fossoil"]["counter"].items, "PowderedMilk");
table.insert(Distributions["fossoil"]["counter"].items, 2);
table.insert(Distributions["fossoil"]["shelvesmag"].items, "DairyCookingMag");
table.insert(Distributions["fossoil"]["shelvesmag"].items, 0.2);
table.insert(Distributions["fossoil"]["crate"].items, "PowderedMilk");
table.insert(Distributions["fossoil"]["crate"].items, 2);

-- All (General)
table.insert(Distributions["all"]["postbox"].items, "DairyCookingMag");
table.insert(Distributions["all"]["postbox"].items, 0.2);
table.insert(Distributions["all"]["sidetable"].items, "DairyCookingMag");
table.insert(Distributions["all"]["sidetable"].items, 0.7);
table.insert(Distributions["all"]["fridge"].items, "YogurtCulture");
table.insert(Distributions["all"]["fridge"].items, 3);
table.insert(Distributions["all"]["shelves"].items, "DairyCookingMag");
table.insert(Distributions["all"]["shelves"].items, 1);

--Spiffo's
table.insert(Distributions["spiffoskitchen"]["counter"].items, "PowderedMilk");
table.insert(Distributions["spiffoskitchen"]["counter"].items, 3);
table.insert(Distributions["spiffoskitchen"]["counter"].items, "Strainer");
table.insert(Distributions["spiffoskitchen"]["counter"].items, 5);
table.insert(Distributions["spiffoskitchen"]["counter"].items, "YogurtCulture");
table.insert(Distributions["spiffoskitchen"]["counter"].items, 1);

--Kitchen Crepe
table.insert(Distributions["kitchen_crepe"]["fridge"].items, "YogurtCulture");
table.insert(Distributions["kitchen_crepe"]["fridge"].items, 3);
table.insert(Distributions["kitchen_crepe"]["counter"].items, "Strainer");
table.insert(Distributions["kitchen_crepe"]["counter"].items, 5);
table.insert(Distributions["kitchen_crepe"]["counter"].items, "PowderedMilk");
table.insert(Distributions["kitchen_crepe"]["counter"].items, 3);
table.insert(Distributions["kitchen_crepe"]["counter"].items, "YogurtCulture");
table.insert(Distributions["kitchen_crepe"]["counter"].items, 2);

--Pizza Whirled
table.insert(Distributions["pizzawhirled"]["wardrobe"].items, "Strainer");
table.insert(Distributions["pizzawhirled"]["wardrobe"].items, 1);
table.insert(Distributions["pizzawhirled"]["wardrobe"].items, "PowderedMilk");
table.insert(Distributions["pizzawhirled"]["wardrobe"].items, 2);

--Bookstore
table.insert(Distributions["bookstore"]["other"].items, "DairyCookingMag");
table.insert(Distributions["bookstore"]["other"].items, 1);

-- Cafe
table.insert(Distributions["cafe"]["counter"].items, "Strainer");
table.insert(Distributions["cafe"]["counter"].items, 1);
table.insert(Distributions["cafe"]["counter"].items, "PowderedMilk");
table.insert(Distributions["cafe"]["counter"].items, 4);
table.insert(Distributions["cafekitchen"]["all"].items, "Strainer");
table.insert(Distributions["cafekitchen"]["all"].items, 2);
table.insert(Distributions["cafekitchen"]["all"].items, "PowderedMilk");
table.insert(Distributions["cafekitchen"]["all"].items, 5);
table.insert(Distributions["cafekitchen"]["all"].items, "YogurtCulture");
table.insert(Distributions["cafekitchen"]["all"].items, 1);

--Pizza Kitchen
table.insert(Distributions["pizzakitchen"]["counter"].items, "Strainer");
table.insert(Distributions["pizzakitchen"]["counter"].items, 2);

--Post Office Storage
table.insert(Distributions["poststorage"]["all"].items, "DairyCookingMag");
table.insert(Distributions["poststorage"]["all"].items, 0.5);

--Restaurant Kitchen
table.insert(Distributions["restaurantkitchen"]["counter"].items, "Strainer");
table.insert(Distributions["restaurantkitchen"]["counter"].items, 5);
table.insert(Distributions["restaurantkitchen"]["counter"].items, "PowderedMilk");
table.insert(Distributions["restaurantkitchen"]["counter"].items, 3);
table.insert(Distributions["restaurantkitchen"]["counter"].items, "YogurtCulture");
table.insert(Distributions["restaurantkitchen"]["counter"].items, 2);

-- General Store
table.insert(Distributions["generalstorestorage"]["other"].items, "Strainer");
table.insert(Distributions["generalstorestorage"]["other"].items, 1);
table.insert(Distributions["generalstorestorage"]["other"].items, "PowderedMilk");
table.insert(Distributions["generalstorestorage"]["other"].items, 2);
table.insert(Distributions["generalstorestorage"]["other"].items, "YogurtCulture");
table.insert(Distributions["generalstorestorage"]["other"].items, 2);
table.insert(Distributions["generalstore"]["other"].items, "Strainer");
table.insert(Distributions["generalstore"]["other"].items, 1);
table.insert(Distributions["generalstore"]["other"].items, "PowderedMilk");
table.insert(Distributions["generalstore"]["other"].items, 2);
table.insert(Distributions["generalstore"]["other"].items, "YogurtCulture");
table.insert(Distributions["generalstore"]["other"].items, 2);

--Storage Unit
table.insert(Distributions["storageunit"]["all"].items, "Strainer");
table.insert(Distributions["storageunit"]["all"].items, 1);

--Corner Store
table.insert(Distributions["cornerstore"]["counter"].items, "PowderedMilk");
table.insert(Distributions["cornerstore"]["counter"].items, 2);
table.insert(Distributions["cornerstore"]["shelvesmag"].items, "DairyCookingMag");
table.insert(Distributions["cornerstore"]["shelvesmag"].items, 0.2);

--Houseware Store
table.insert(Distributions["housewarestore"]["shelves"].items, "Strainer");
table.insert(Distributions["housewarestore"]["shelves"].items, 3);

--Gas Store
table.insert(Distributions["gasstore"]["shelves"].items, "PowderedMilk");
table.insert(Distributions["gasstore"]["shelves"].items, 1);
table.insert(Distributions["gasstore"]["counter"].items, "PowderedMilk");
table.insert(Distributions["gasstore"]["counter"].items, 1);
table.insert(Distributions["gasstorage"]["metal_shelves"].items, "PowderedMilk");
table.insert(Distributions["gasstorage"]["metal_shelves"].items, 1);

--Survivor Bag
table.insert(Distributions["Bag_SurvivorBag"].items, "PowderedMilk");
table.insert(Distributions["Bag_SurvivorBag"].items, 25);

--Chef
table.insert(Distributions["Chef"]["counter"].items, "DairyCookingMag");
table.insert(Distributions["Chef"]["counter"].items, 2);

--Survivor Cache 1
table.insert(Distributions["SurvivorCache1"]["SurvivorCrate"].items, "PowderedMilk");
table.insert(Distributions["SurvivorCache1"]["SurvivorCrate"].items, 15);

--Survivor Cache 2
table.insert(Distributions["SurvivorCache2"]["SurvivorCrate"].items, "PowderedMilk");
table.insert(Distributions["SurvivorCache2"]["SurvivorCrate"].items, 15);
