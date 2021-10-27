require 'Items/Distributions'
require 'Items/ProceduralDistributions'

--[[
ORIGINAL DISTRO CODE BY OH GOD SPIDERS NO (https://steamcommunity.com/id/OhGodSpidersNo)

COMMENTS AND CODE MODIFICATIONS BY PARANOID&AFRAID
--]]

SuburbsDistributions = SuburbsDistributions or {}
ProceduralDistributions = ProceduralDistributions or {}

--[[
The magazines were pushed into ProcDistro tables, so the mod's magazines
will have to be reinserted into the relevent ProcDistro tables.
--]]

--[[
table.insert(SuburbsDistributions["zippeestore"]["counter"].items, "FMJ.LockPickingMag");
table.insert(SuburbsDistributions["zippeestore"]["counter"].items, 0.2);
table.insert(SuburbsDistributions["zippeestore"]["counter"].items, "FMJ.LockPickingMag2");
table.insert(SuburbsDistributions["zippeestore"]["counter"].items, 0.2);
table.insert(SuburbsDistributions["zippeestore"]["shelvesmag"].items, "FMJ.LockPickingMag");
table.insert(SuburbsDistributions["zippeestore"]["shelvesmag"].items, 0.2);
table.insert(SuburbsDistributions["zippeestore"]["shelvesmag"].items, "FMJ.LockPickingMag2");
table.insert(SuburbsDistributions["zippeestore"]["shelvesmag"].items, 0.2);
table.insert(SuburbsDistributions["zippeestore"]["crate"].items, "FMJ.LockPickingMag");
table.insert(SuburbsDistributions["zippeestore"]["crate"].items, 0.2);
table.insert(SuburbsDistributions["zippeestore"]["crate"].items, "FMJ.LockPickingMag2");
table.insert(SuburbsDistributions["zippeestore"]["crate"].items, 0.2);
--]]

--[[
table.insert(SuburbsDistributions["fossoil"]["counter"].items, "FMJ.LockPickingMag");
table.insert(SuburbsDistributions["fossoil"]["counter"].items, 0.2);
table.insert(SuburbsDistributions["fossoil"]["counter"].items, "FMJ.LockPickingMag2");
table.insert(SuburbsDistributions["fossoil"]["counter"].items, 0.2);
table.insert(SuburbsDistributions["fossoil"]["shelvesmag"].items, "FMJ.LockPickingMag");
table.insert(SuburbsDistributions["fossoil"]["shelvesmag"].items, 0.2);
table.insert(SuburbsDistributions["fossoil"]["shelvesmag"].items, "FMJ.LockPickingMag2");
table.insert(SuburbsDistributions["fossoil"]["shelvesmag"].items, 0.2);
--]]

--[[ 41.51+ UPDATE
Every magazine shelf now generates its loot from the ProcDistro lua,
so by adding the lockpicking mags to the relevent tables, it should be able to cover most bases.
--]]
table.insert(ProceduralDistributions["list"]["MagazineRackMixed"].items, "FMJ.LockPickingMag");
table.insert(ProceduralDistributions["list"]["MagazineRackMixed"].items, 0.2);
table.insert(ProceduralDistributions["list"]["MagazineRackMixed"].items, "FMJ.LockPickingMag2");
table.insert(ProceduralDistributions["list"]["MagazineRackMixed"].items, 0.2);
table.insert(ProceduralDistributions["list"]["MagazineRackMixed"].items, "FMJ.LockPickingMag");
table.insert(ProceduralDistributions["list"]["MagazineRackMixed"].items, 0.2);
table.insert(ProceduralDistributions["list"]["MagazineRackMixed"].items, "FMJ.LockPickingMag2");
table.insert(ProceduralDistributions["list"]["MagazineRackMixed"].items, 0.2);

-- Most of the "all" entries are untouched.
-- table.insert(SuburbsDistributions["all"]["postbox"].items, "FMJ.LockPickingMag");
-- table.insert(SuburbsDistributions["all"]["postbox"].items, 0.2);
-- table.insert(SuburbsDistributions["all"]["postbox"].items, "FMJ.LockPickingMag2");
-- table.insert(SuburbsDistributions["all"]["postbox"].items, 0.2);

--[[ Nonapplicable due to the new ProcDistro system.
table.insert(SuburbsDistributions["all"]["shelvesmag"].items, "FMJ.LockPickingMag");
table.insert(SuburbsDistributions["all"]["shelvesmag"].items, 0.2);
table.insert(SuburbsDistributions["all"]["shelvesmag"].items, "FMJ.LockPickingMag2");
table.insert(SuburbsDistributions["all"]["shelvesmag"].items, 0.2);
--]]

-- See line #57.
-- table.insert(SuburbsDistributions["all"]["desk"].items, "FMJ.LockPickingMag");
-- table.insert(SuburbsDistributions["all"]["desk"].items, 0.2);
-- table.insert(SuburbsDistributions["all"]["desk"].items, "FMJ.LockPickingMag2");
-- table.insert(SuburbsDistributions["all"]["desk"].items, 0.2);
-- table.insert(SuburbsDistributions["all"]["sidetable"].items, "FMJ.LockPickingMag");
-- table.insert(SuburbsDistributions["all"]["sidetable"].items, 0.1);
-- table.insert(SuburbsDistributions["all"]["sidetable"].items, "FMJ.LockPickingMag2");
-- table.insert(SuburbsDistributions["all"]["sidetable"].items, 0.1);
-- table.insert(SuburbsDistributions["all"]["officedrawers"].items, "FMJ.LockPickingMag");
-- table.insert(SuburbsDistributions["all"]["officedrawers"].items, 0.1);
-- table.insert(SuburbsDistributions["all"]["officedrawers"].items, "FMJ.LockPickingMag2");
-- table.insert(SuburbsDistributions["all"]["officedrawers"].items, 0.1);
-- table.insert(SuburbsDistributions["all"]["shelves"].items, "FMJ.LockPickingMag");
-- table.insert(SuburbsDistributions["all"]["shelves"].items, 0.2);
-- table.insert(SuburbsDistributions["all"]["shelves"].items, "FMJ.LockPickingMag2");
-- table.insert(SuburbsDistributions["all"]["shelves"].items, 0.2);

--[[ 41.51+ UPDATE
Both the "shed" and "garagestorage" table now call the same ProcDistro table for tool loot.
--]]

--[[
table.insert(SuburbsDistributions["shed"]["other"].items, "FMJ.LockPickingMag");
table.insert(SuburbsDistributions["shed"]["other"].items, 0.5);
table.insert(SuburbsDistributions["shed"]["other"].items, "FMJ.LockPickingMag2");
table.insert(SuburbsDistributions["shed"]["other"].items, 0.5);
table.insert(SuburbsDistributions["garagestorage"]["other"].items, "FMJ.LockPickingMag");
table.insert(SuburbsDistributions["garagestorage"]["other"].items, 0.2);
table.insert(SuburbsDistributions["garagestorage"]["other"].items, "FMJ.LockPickingMag2");
table.insert(SuburbsDistributions["garagestorage"]["other"].items, 0.2);
--]]

table.insert(ProceduralDistributions["list"]["GarageTools"].items, "FMJ.LockPickingMag");
table.insert(ProceduralDistributions["list"]["GarageTools"].items, 0.5);
table.insert(ProceduralDistributions["list"]["GarageTools"].items, "FMJ.LockPickingMag2");
table.insert(ProceduralDistributions["list"]["GarageTools"].items, 0.5);

-- table.insert(ProceduralDistributions["list"]["CrateHardware"].items, "FMJ.LockPickingMag");
-- table.insert(ProceduralDistributions["list"]["CrateHardware"].items, 0.2);
-- table.insert(ProceduralDistributions["list"]["CrateHardware"].items, "FMJ.LockPickingMag2");
-- table.insert(ProceduralDistributions["list"]["CrateHardware"].items, 0.2);

--[[ Nonapplicable due to the new ProcDistro system. See line #89.
table.insert(SuburbsDistributions["garage"]["metal_shelves"].items, "FMJ.LockPickingMag");
table.insert(SuburbsDistributions["garage"]["metal_shelves"].items, 0.2);
table.insert(SuburbsDistributions["garage"]["metal_shelves"].items, "FMJ.LockPickingMag2");
table.insert(SuburbsDistributions["garage"]["metal_shelves"].items, 0.2);
--]]

--[[ Nonapplicable due to the new ProcDistro system.
table.insert(SuburbsDistributions["bookstore"]["other"].items, "FMJ.LockPickingMag");
table.insert(SuburbsDistributions["bookstore"]["other"].items, 0.5);
table.insert(SuburbsDistributions["bookstore"]["other"].items, "FMJ.LockPickingMag2");
table.insert(SuburbsDistributions["bookstore"]["other"].items, 0.5);
--]]

-- Bookstore shelves now procedurally generate loot from the "BookstoreBooks" table.
table.insert(ProceduralDistributions["list"]["BookstoreBooks"].items, "FMJ.LockPickingMag");
table.insert(ProceduralDistributions["list"]["BookstoreBooks"].items, 0.5);
table.insert(ProceduralDistributions["list"]["BookstoreBooks"].items, "FMJ.LockPickingMag2");
table.insert(ProceduralDistributions["list"]["BookstoreBooks"].items, 0.5);

--[[ Nonapplicable due to new ProcDistro system.
table.insert(SuburbsDistributions["poststorage"]["all"].items, "FMJ.LockPickingMag");
table.insert(SuburbsDistributions["poststorage"]["all"].items, 0.5);
table.insert(SuburbsDistributions["poststorage"]["all"].items, "FMJ.LockPickingMag2");
table.insert(SuburbsDistributions["poststorage"]["all"].items, 0.5);
--]]

-- Now should spawn the magazines from the "PostOfficeMagazines" table.
table.insert(ProceduralDistributions["list"]["PostOfficeMagazines"].items, "FMJ.LockPickingMag");
table.insert(ProceduralDistributions["list"]["PostOfficeMagazines"].items, 0.5);
table.insert(ProceduralDistributions["list"]["PostOfficeMagazines"].items, "FMJ.LockPickingMag2");
table.insert(ProceduralDistributions["list"]["PostOfficeMagazines"].items, 0.5);

-- table.insert(SuburbsDistributions["storageunit"]["all"].items, "FMJ.LockPickingMag");
-- table.insert(SuburbsDistributions["storageunit"]["all"].items, 0.2);
-- table.insert(SuburbsDistributions["storageunit"]["all"].items, "FMJ.LockPickingMag2");
-- table.insert(SuburbsDistributions["storageunit"]["all"].items, 0.2);

--[[ See line #45.
table.insert(SuburbsDistributions["cornerstore"]["shelvesmag"].items, "FMJ.LockPickingMag");
table.insert(SuburbsDistributions["cornerstore"]["shelvesmag"].items, 0.2);
table.insert(SuburbsDistributions["cornerstore"]["shelvesmag"].items, "FMJ.LockPickingMag2");
table.insert(SuburbsDistributions["cornerstore"]["shelvesmag"].items, 0.2);
--]]

--[[ Nonapplicable due to the new ProcDistro system.
table.insert(SuburbsDistributions["camping"]["shelves"].items, "FMJ.LockPickingMag");
table.insert(SuburbsDistributions["camping"]["shelves"].items, 0.2);
table.insert(SuburbsDistributions["camping"]["shelves"].items, "FMJ.LockPickingMag2");
table.insert(SuburbsDistributions["camping"]["shelves"].items, 0.2);
--]]

-- Camping stores now generate their literature loot via the ProcDistro table "CampingStoreBooks".
table.insert(ProceduralDistributions["list"]["CampingStoreBooks"].items, "FMJ.LockPickingMag");
table.insert(ProceduralDistributions["list"]["CampingStoreBooks"].items, 0.2);
table.insert(ProceduralDistributions["list"]["CampingStoreBooks"].items, "FMJ.LockPickingMag2");
table.insert(ProceduralDistributions["list"]["CampingStoreBooks"].items, 0.2);

-- Bag loot distribution remains the same.
-- table.insert(SuburbsDistributions["Bag_InmateEscapedBag"].items, "FMJ.LockPickingMag");
-- table.insert(SuburbsDistributions["Bag_InmateEscapedBag"].items, 3);
-- table.insert(SuburbsDistributions["Bag_InmateEscapedBag"].items, "FMJ.LockPickingMag2");
-- table.insert(SuburbsDistributions["Bag_InmateEscapedBag"].items, 3);
-- table.insert(SuburbsDistributions["Bag_SurvivorBag"].items, "FMJ.LockPickingMag");
-- table.insert(SuburbsDistributions["Bag_SurvivorBag"].items, 0.5);
-- table.insert(SuburbsDistributions["Bag_SurvivorBag"].items, "FMJ.LockPickingMag2");
-- table.insert(SuburbsDistributions["Bag_SurvivorBag"].items, 0.5);

--[[ Nonapplicable due to the new ProcDistro system. See line #89.
table.insert(SuburbsDistributions["shed"]["other"].items, "FMJ.BobbyPin");
table.insert(SuburbsDistributions["shed"]["other"].items, 2.5);
table.insert(SuburbsDistributions["shed"]["other"].items, "FMJ.BobbyPin");
table.insert(SuburbsDistributions["shed"]["other"].items, 2.5);
-]]

table.insert(ProceduralDistributions["list"]["GarageTools"].items, "FMJ.BobbyPin");
table.insert(ProceduralDistributions["list"]["GarageTools"].items, 2.5);
table.insert(ProceduralDistributions["list"]["GarageTools"].items, "FMJ.BobbyPin");
table.insert(ProceduralDistributions["list"]["GarageTools"].items, 2.5);

-- Formerly ["garage"]["crate"] --
-- table.insert(ProceduralDistributions["list"]["CrateHardware"].items, "FMJ.BobbyPin");
-- table.insert(ProceduralDistributions["list"]["CrateHardware"].items, 2.5);
-- table.insert(ProceduralDistributions["list"]["CrateHardware"].items, "FMJ.BobbyPin");
-- table.insert(ProceduralDistributions["list"]["CrateHardware"].items, 2.5);

-- See line #57
-- table.insert(SuburbsDistributions["all"]["crate"].items, "FMJ.BobbyPin");
-- table.insert(SuburbsDistributions["all"]["crate"].items, 2.5);
-- table.insert(SuburbsDistributions["all"]["metal_shelves"].items, "FMJ.BobbyPin");
-- table.insert(SuburbsDistributions["all"]["metal_shelves"].items, 2.5);
-- table.insert(SuburbsDistributions["all"]["other"].items, "FMJ.BobbyPin");
-- table.insert(SuburbsDistributions["all"]["other"].items, 2.5);
