require 'Items/Distributions'
require 'Items/ProceduralDistributions'
ProceduralDistributions = ProceduralDistributions or {}
SuburbsDistributions = SuburbsDistributions or {}

local function stockIWBUMS()
  -- YogurtCulture
  table.insert(ProceduralDistributions["list"]["CrepeKitchenFridge"].items, "YogurtCulture");
  table.insert(ProceduralDistributions["list"]["CrepeKitchenFridge"].items, 4);
  table.insert(ProceduralDistributions["list"]["FridgeOther"].items, "YogurtCulture");
  table.insert(ProceduralDistributions["list"]["FridgeOther"].items, 4);
  table.insert(ProceduralDistributions["list"]["RestaurantKitchenFridge"].items, "YogurtCulture");
  table.insert(ProceduralDistributions["list"]["RestaurantKitchenFridge"].items, 4);
  -- PowderedMilk
  table.insert(ProceduralDistributions["list"]["CrateCannedFood"].items, "PowderedMilk");
  table.insert(ProceduralDistributions["list"]["CrateCannedFood"].items, 6);
  table.insert(ProceduralDistributions["list"]["GigamartCannedFood"].items, "PowderedMilk");
  table.insert(ProceduralDistributions["list"]["GigamartCannedFood"].items, 6);
  table.insert(ProceduralDistributions["list"]["KitchenCannedFood"].items, "PowderedMilk");
  table.insert(ProceduralDistributions["list"]["KitchenCannedFood"].items, 6);
  -- DairyCookingMag
  table.insert(ProceduralDistributions["list"]["BookstoreBooks"].items, "DairyCookingMag");
  table.insert(ProceduralDistributions["list"]["BookstoreBooks"].items, 2);
  table.insert(ProceduralDistributions["list"]["CrateMagazines"].items, "DairyCookingMag");
  table.insert(ProceduralDistributions["list"]["CrateMagazines"].items, 1);
  table.insert(ProceduralDistributions["list"]["KitchenBook"].items, "DairyCookingMag");
  table.insert(ProceduralDistributions["list"]["KitchenBook"].items, 4);
  table.insert(ProceduralDistributions["list"]["LibraryBooks"].items, "DairyCookingMag");
  table.insert(ProceduralDistributions["list"]["LibraryBooks"].items, 1);
  table.insert(ProceduralDistributions["list"]["LivingRoomShelf"].items, "DairyCookingMag");
  table.insert(ProceduralDistributions["list"]["LivingRoomShelf"].items, 0.1);
  table.insert(ProceduralDistributions["list"]["LivingRoomShelfNoTapes"].items, "DairyCookingMag");
  table.insert(ProceduralDistributions["list"]["LivingRoomShelfNoTapes"].items, 0.1);
  table.insert(ProceduralDistributions["list"]["MagazineRackMixed"].items, "DairyCookingMag");
  table.insert(ProceduralDistributions["list"]["MagazineRackMixed"].items, 0.5);
  table.insert(ProceduralDistributions["list"]["PostOfficeMagazines"].items, "DairyCookingMag");
  table.insert(ProceduralDistributions["list"]["PostOfficeMagazines"].items, 1);
  table.insert(ProceduralDistributions["list"]["ShelfGeneric"].items, "DairyCookingMag");
  table.insert(ProceduralDistributions["list"]["ShelfGeneric"].items, 0.1);
  -- Strainer
  table.insert(ProceduralDistributions["list"]["GigamartPots"].items, "Strainer");
  table.insert(ProceduralDistributions["list"]["GigamartPots"].items, 6);
  table.insert(ProceduralDistributions["list"]["StoreKitchenPots"].items, "Strainer");
  table.insert(ProceduralDistributions["list"]["StoreKitchenPots"].items, 6);
  table.insert(ProceduralDistributions["list"]["KitchenPots"].items, "Strainer");
  table.insert(ProceduralDistributions["list"]["KitchenPots"].items, 3);
end

local function stockClassic()
  -- Burger Kitchen
  table.insert(SuburbsDistributions["burgerkitchen"]["counter"].items, "Strainer");
  table.insert(SuburbsDistributions["burgerkitchen"]["counter"].items, 3);
  table.insert(SuburbsDistributions["burgerkitchen"]["counter"].junk, "Strainer");
  table.insert(SuburbsDistributions["burgerkitchen"]["counter"].junk, 3);
  -- Zippee Store
  table.insert(SuburbsDistributions["zippeestore"]["counter"].items, "PowderedMilk");
  table.insert(SuburbsDistributions["zippeestore"]["counter"].items, 2);
  table.insert(SuburbsDistributions["zippeestore"]["crate"].items, "PowderedMilk");
  table.insert(SuburbsDistributions["zippeestore"]["crate"].items, 2);
  table.insert(SuburbsDistributions["zippeestore"]["shelvesmag"].items, "DairyCookingMag");
  table.insert(SuburbsDistributions["zippeestore"]["shelvesmag"].items, 0.2);
  -- Grocery
  table.insert(SuburbsDistributions["grocery"]["counter"].items, "PowderedMilk");
  table.insert(SuburbsDistributions["grocery"]["counter"].items, 3);
  table.insert(SuburbsDistributions["grocery"]["shelvesmag"].items, "DairyCookingMag");
  table.insert(SuburbsDistributions["grocery"]["shelvesmag"].items, 0.2);
  -- Gigamart Kitchen
  table.insert(SuburbsDistributions["gigamartkitchen"]["counter"].items, "PowderedMilk");
  table.insert(SuburbsDistributions["gigamartkitchen"]["counter"].items, 4);
  table.insert(SuburbsDistributions["gigamartkitchen"]["counter"].items, "Strainer");
  table.insert(SuburbsDistributions["gigamartkitchen"]["counter"].items, 5);
  table.insert(SuburbsDistributions["gigamartkitchen"]["counter"].items, "YogurtCulture");
  table.insert(SuburbsDistributions["gigamartkitchen"]["counter"].items, 2);
  -- Gigamart
  table.insert(SuburbsDistributions["gigamart"]["counter"].items, "PowderedMilk");
  table.insert(SuburbsDistributions["gigamart"]["counter"].items, 2);
  table.insert(SuburbsDistributions["gigamart"]["shelvesmag"].items, "DairyCookingMag");
  table.insert(SuburbsDistributions["gigamart"]["shelvesmag"].items, 1);
  -- Fossoil
  table.insert(SuburbsDistributions["fossoil"]["counter"].items, "PowderedMilk");
  table.insert(SuburbsDistributions["fossoil"]["counter"].items, 2);
  table.insert(SuburbsDistributions["fossoil"]["shelvesmag"].items, "DairyCookingMag");
  table.insert(SuburbsDistributions["fossoil"]["shelvesmag"].items, 0.2);
  table.insert(SuburbsDistributions["fossoil"]["crate"].items, "PowderedMilk");
  table.insert(SuburbsDistributions["fossoil"]["crate"].items, 2);
  -- All (General)
  table.insert(SuburbsDistributions["all"]["postbox"].items, "DairyCookingMag");
  table.insert(SuburbsDistributions["all"]["postbox"].items, 0.2);
  table.insert(SuburbsDistributions["all"]["sidetable"].items, "DairyCookingMag");
  table.insert(SuburbsDistributions["all"]["sidetable"].items, 0.7);
  table.insert(SuburbsDistributions["all"]["fridge"].items, "YogurtCulture");
  table.insert(SuburbsDistributions["all"]["fridge"].items, 3);
  table.insert(SuburbsDistributions["all"]["shelves"].items, "DairyCookingMag");
  table.insert(SuburbsDistributions["all"]["shelves"].items, 1);
  --Spiffo's
  table.insert(SuburbsDistributions["spiffoskitchen"]["counter"].items, "PowderedMilk");
  table.insert(SuburbsDistributions["spiffoskitchen"]["counter"].items, 3);
  table.insert(SuburbsDistributions["spiffoskitchen"]["counter"].items, "Strainer");
  table.insert(SuburbsDistributions["spiffoskitchen"]["counter"].items, 5);
  table.insert(SuburbsDistributions["spiffoskitchen"]["counter"].items, "YogurtCulture");
  table.insert(SuburbsDistributions["spiffoskitchen"]["counter"].items, 1);
  --Kitchen Crepe
  table.insert(SuburbsDistributions["kitchen_crepe"]["fridge"].items, "YogurtCulture");
  table.insert(SuburbsDistributions["kitchen_crepe"]["fridge"].items, 3);
  table.insert(SuburbsDistributions["kitchen_crepe"]["counter"].items, "Strainer");
  table.insert(SuburbsDistributions["kitchen_crepe"]["counter"].items, 5);
  table.insert(SuburbsDistributions["kitchen_crepe"]["counter"].items, "PowderedMilk");
  table.insert(SuburbsDistributions["kitchen_crepe"]["counter"].items, 3);
  table.insert(SuburbsDistributions["kitchen_crepe"]["counter"].items, "YogurtCulture");
  table.insert(SuburbsDistributions["kitchen_crepe"]["counter"].items, 2);
  --Pizza Whirled
  table.insert(SuburbsDistributions["pizzawhirled"]["wardrobe"].items, "Strainer");
  table.insert(SuburbsDistributions["pizzawhirled"]["wardrobe"].items, 1);
  table.insert(SuburbsDistributions["pizzawhirled"]["wardrobe"].items, "PowderedMilk");
  table.insert(SuburbsDistributions["pizzawhirled"]["wardrobe"].items, 2);
  --Bookstore
  table.insert(SuburbsDistributions["bookstore"]["other"].items, "DairyCookingMag");
  table.insert(SuburbsDistributions["bookstore"]["other"].items, 1);
  -- Cafe
  table.insert(SuburbsDistributions["cafe"]["counter"].items, "Strainer");
  table.insert(SuburbsDistributions["cafe"]["counter"].items, 1);
  table.insert(SuburbsDistributions["cafe"]["counter"].items, "PowderedMilk");
  table.insert(SuburbsDistributions["cafe"]["counter"].items, 4);
  table.insert(SuburbsDistributions["cafekitchen"]["all"].items, "Strainer");
  table.insert(SuburbsDistributions["cafekitchen"]["all"].items, 2);
  table.insert(SuburbsDistributions["cafekitchen"]["all"].items, "PowderedMilk");
  table.insert(SuburbsDistributions["cafekitchen"]["all"].items, 5);
  table.insert(SuburbsDistributions["cafekitchen"]["all"].items, "YogurtCulture");
  table.insert(SuburbsDistributions["cafekitchen"]["all"].items, 1);
  --Pizza Kitchen
  table.insert(SuburbsDistributions["pizzakitchen"]["counter"].items, "Strainer");
  table.insert(SuburbsDistributions["pizzakitchen"]["counter"].items, 2);
  --Post Office Storage
  table.insert(SuburbsDistributions["poststorage"]["all"].items, "DairyCookingMag");
  table.insert(SuburbsDistributions["poststorage"]["all"].items, 0.5);
  --Restaurant Kitchen
  table.insert(SuburbsDistributions["restaurantkitchen"]["counter"].items, "Strainer");
  table.insert(SuburbsDistributions["restaurantkitchen"]["counter"].items, 5);
  table.insert(SuburbsDistributions["restaurantkitchen"]["counter"].items, "PowderedMilk");
  table.insert(SuburbsDistributions["restaurantkitchen"]["counter"].items, 3);
  table.insert(SuburbsDistributions["restaurantkitchen"]["counter"].items, "YogurtCulture");
  table.insert(SuburbsDistributions["restaurantkitchen"]["counter"].items, 2);
  -- General Store
  table.insert(SuburbsDistributions["generalstorestorage"]["other"].items, "Strainer");
  table.insert(SuburbsDistributions["generalstorestorage"]["other"].items, 1);
  table.insert(SuburbsDistributions["generalstorestorage"]["other"].items, "PowderedMilk");
  table.insert(SuburbsDistributions["generalstorestorage"]["other"].items, 2);
  table.insert(SuburbsDistributions["generalstorestorage"]["other"].items, "YogurtCulture");
  table.insert(SuburbsDistributions["generalstorestorage"]["other"].items, 2);
  table.insert(SuburbsDistributions["generalstore"]["other"].items, "Strainer");
  table.insert(SuburbsDistributions["generalstore"]["other"].items, 1);
  table.insert(SuburbsDistributions["generalstore"]["other"].items, "PowderedMilk");
  table.insert(SuburbsDistributions["generalstore"]["other"].items, 2);
  table.insert(SuburbsDistributions["generalstore"]["other"].items, "YogurtCulture");
  table.insert(SuburbsDistributions["generalstore"]["other"].items, 2);
  --Storage Unit
  table.insert(SuburbsDistributions["storageunit"]["all"].items, "Strainer");
  table.insert(SuburbsDistributions["storageunit"]["all"].items, 1);
  --Corner Store
  table.insert(SuburbsDistributions["cornerstore"]["counter"].items, "PowderedMilk");
  table.insert(SuburbsDistributions["cornerstore"]["counter"].items, 2);
  table.insert(SuburbsDistributions["cornerstore"]["shelvesmag"].items, "DairyCookingMag");
  table.insert(SuburbsDistributions["cornerstore"]["shelvesmag"].items, 0.2);
  --Houseware Store
  table.insert(SuburbsDistributions["housewarestore"]["shelves"].items, "Strainer");
  table.insert(SuburbsDistributions["housewarestore"]["shelves"].items, 3);
  --Gas Store
  table.insert(SuburbsDistributions["gasstore"]["shelves"].items, "PowderedMilk");
  table.insert(SuburbsDistributions["gasstore"]["shelves"].items, 1);
  table.insert(SuburbsDistributions["gasstore"]["counter"].items, "PowderedMilk");
  table.insert(SuburbsDistributions["gasstore"]["counter"].items, 1);
  table.insert(SuburbsDistributions["gasstorage"]["metal_shelves"].items, "PowderedMilk");
  table.insert(SuburbsDistributions["gasstorage"]["metal_shelves"].items, 1);
  --Survivor Bag
  table.insert(SuburbsDistributions["Bag_SurvivorBag"].items, "PowderedMilk");
  table.insert(SuburbsDistributions["Bag_SurvivorBag"].items, 25);
  --Chef
  table.insert(SuburbsDistributions["Chef"]["counter"].items, "DairyCookingMag");
  table.insert(SuburbsDistributions["Chef"]["counter"].items, 2);
  --Survivor Cache 1
  table.insert(SuburbsDistributions["SurvivorCache1"]["SurvivorCrate"].items, "PowderedMilk");
  table.insert(SuburbsDistributions["SurvivorCache1"]["SurvivorCrate"].items, 15);
  --Survivor Cache 2
  table.insert(SuburbsDistributions["SurvivorCache2"]["SurvivorCrate"].items, "PowderedMilk");
  table.insert(SuburbsDistributions["SurvivorCache2"]["SurvivorCrate"].items, 15);
end

if string.match(getCore():getVersionNumber(), "41")
  then stockIWBUMS();
  else stockClassic();
end;
