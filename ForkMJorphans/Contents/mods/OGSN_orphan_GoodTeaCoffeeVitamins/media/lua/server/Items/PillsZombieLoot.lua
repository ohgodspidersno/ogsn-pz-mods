require 'Items/Distributions'

SuburbsDistributions = SuburbsDistributions or {}
-- Zombie Male
table.insert(SuburbsDistributions["all"]["inventorymale"].items, "Base.PillsVitamins");
table.insert(SuburbsDistributions["all"]["inventorymale"].items, 0.03);
-- Zombie Female
table.insert(SuburbsDistributions["all"]["inventoryfemale"].items, "Base.PillsVitamins");
table.insert(SuburbsDistributions["all"]["inventoryfemale"].items, 0.03);
