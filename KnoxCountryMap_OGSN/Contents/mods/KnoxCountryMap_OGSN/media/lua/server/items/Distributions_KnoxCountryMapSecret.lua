require 'Items/SuburbsDistributions'
require 'Vehicles/VehicleDistributions'

-- SuburbsDistributions
table.insert(SuburbsDistributions["all"]["desk"].items, "Base.KnoxCountryMapSecret");
table.insert(SuburbsDistributions["all"]["desk"].items, 0.0005);

table.insert(SuburbsDistributions["Bag_WeaponBag"].items, "Base.KnoxCountryMapSecret");
table.insert(SuburbsDistributions["Bag_WeaponBag"].items, 1);

-- VehicleDistributions
table.insert(VehicleDistributions["Police"]["GloveBox"].items,"Base.KnoxCountryMapSecret");
table.insert(VehicleDistributions["Police"]["GloveBox"].items, 0.1);

table.insert(VehicleDistributions["Ranger"]["GloveBox"].items,"Base.KnoxCountryMapSecret");
table.insert(VehicleDistributions["Ranger"]["GloveBox"].items, 0.2);

table.insert(VehicleDistributions["Radio"]["GloveBox"].items,"Base.KnoxCountryMapSecret");
table.insert(VehicleDistributions["Radio"]["GloveBox"].items, 100);

if getActivatedMods():contains("MysteryMachineOGSN") then
  table.insert(VehicleDistributions["MysteryMachine"]["Glovebox"].items,"Base.KnoxCountryMapSecret");
  table.insert(VehicleDistributions["MysteryMachine"]["Glovebox"].items, 100);
end
-- table.insert(VehicleDistributions["GloveBox"].items, "filcher.PostcardLocal");
-- table.insert(VehicleDistributions["GloveBox"].items, 1);

-- policestorage = {
--         locker ={
