require 'Items/Distributions'
require 'Items/ProceduralDistributions'

--[[
ORIGINAL DISTRO CODE BY OH GOD SPIDERS NO (https://steamcommunity.com/id/OhGodSpidersNo)

COMMENTS AND CODE MODIFICATIONS BY PARANOID&AFRAID
--]]

SuburbsDistributions = SuburbsDistributions or {}
ProceduralDistributions = ProceduralDistributions or {}

-- Reinsert maps into the "MagazineRackMaps" and MagzineRackMixed" ProcDistro tables.

function stockIWBUMS()

--[[ Nonapplicable due to all magazines and maps being pushed into the aforementioned loot tables.
  table.insert(SuburbsDistributions["zippeestore"]["shelvesmag"].items, "Base.KnoxCountryMap");
  table.insert(SuburbsDistributions["zippeestore"]["shelvesmag"].items, 1);

  table.insert(SuburbsDistributions["fossoil"]["shelvesmag"].items, "Base.KnoxCountryMap");
  table.insert(SuburbsDistributions["fossoil"]["shelvesmag"].items, 1);

  table.insert(SuburbsDistributions["cornerstore"]["shelvesmag"].items, "Base.KnoxCountryMap");
  table.insert(SuburbsDistributions["cornerstore"]["shelvesmag"].items, 1);

  table.insert(SuburbsDistributions["grocery"]["shelvesmag"].items, "Base.KnoxCountryMap");
  table.insert(SuburbsDistributions["grocery"]["shelvesmag"].items, 1);

  table.insert(SuburbsDistributions["all"]["shelvesmag"].items, "Base.KnoxCountryMap");
  table.insert(SuburbsDistributions["all"]["shelvesmag"].items, 1);

  table.insert(SuburbsDistributions["gigamart"]["shelvesmag"].items, "Base.KnoxCountryMap");
  table.insert(SuburbsDistributions["gigamart"]["shelvesmag"].items, 1);
--]]

  -- Reinserted map into the appropriate distro tables.
  table.insert(ProceduralDistributions["list"]["MagazineRackMaps"].items, "Base.KnoxCountryMap");
  table.insert(ProceduralDistributions["list"]["MagazineRackMaps"].items, 1);

  table.insert(ProceduralDistributions["list"]["MagazineRackMixed"].items, "Base.KnoxCountryMap");
  table.insert(ProceduralDistributions["list"]["MagazineRackMixed"].items, 1);

  -- Everything else should be fine.
  table.insert(SuburbsDistributions["all"]["inventorymale"].items, "Base.KnoxCountryMap");
  table.insert(SuburbsDistributions["all"]["inventorymale"].items, 0.1);

  table.insert(SuburbsDistributions["all"]["inventoryfemale"].items, "Base.KnoxCountryMap");
  table.insert(SuburbsDistributions["all"]["inventoryfemale"].items, 0.1);

  table.insert(SuburbsDistributions["all"]["sidetable"].items, "Base.KnoxCountryMap");
  table.insert(SuburbsDistributions["all"]["sidetable"].items, 0.01);

  table.insert(SuburbsDistributions["Bag_SurvivorBag"].items, "Base.KnoxCountryMap");
  table.insert(SuburbsDistributions["Bag_SurvivorBag"].items, 30);

  table.insert(VehicleDistributions["GloveBox"].items, "Base.KnoxCountryMap");
  table.insert(VehicleDistributions["GloveBox"].items, 5);
end

function stockClassic()
  -- zippeestore>shelvesmag
  table.insert(SuburbsDistributions["zippeestore"]["shelvesmag"].items, "Base.KnoxCountryMap");
  table.insert(SuburbsDistributions["zippeestore"]["shelvesmag"].items, 1);

  -- fossoil>shelvesmag
  table.insert(SuburbsDistributions["fossoil"]["shelvesmag"].items, "Base.KnoxCountryMap");
  table.insert(SuburbsDistributions["fossoil"]["shelvesmag"].items, 1);

  -- cornerstore>shelvesmag
  table.insert(SuburbsDistributions["cornerstore"]["shelvesmag"].items, "Base.KnoxCountryMap");
  table.insert(SuburbsDistributions["cornerstore"]["shelvesmag"].items, 1);

  -- grocery>shelvesmag
  table.insert(SuburbsDistributions["grocery"]["shelvesmag"].items, "Base.KnoxCountryMap");
  table.insert(SuburbsDistributions["grocery"]["shelvesmag"].items, 1);

  -- all>shelvesmag
  table.insert(SuburbsDistributions["all"]["shelvesmag"].items, "Base.KnoxCountryMap");
  table.insert(SuburbsDistributions["all"]["shelvesmag"].items, 1);

  -- all>inventorymale
  table.insert(SuburbsDistributions["all"]["inventorymale"].items, "Base.KnoxCountryMap");
  table.insert(SuburbsDistributions["all"]["inventorymale"].items, 0.1);

  -- all>inventoryfemale
  table.insert(SuburbsDistributions["all"]["inventoryfemale"].items, "Base.KnoxCountryMap");
  table.insert(SuburbsDistributions["all"]["inventoryfemale"].items, 0.1);

  -- all>sidetable
  table.insert(SuburbsDistributions["all"]["sidetable"].items, "Base.KnoxCountryMap");
  table.insert(SuburbsDistributions["all"]["sidetable"].items, 0.01);

  -- bedroom>sidetable
  table.insert(SuburbsDistributions["bedroom"]["sidetable"].items, "Base.KnoxCountryMap");
  table.insert(SuburbsDistributions["bedroom"]["sidetable"].items, 0.01);

  -- all>desk
  table.insert(SuburbsDistributions["all"]["desk"].items, "Base.KnoxCountryMap");
  table.insert(SuburbsDistributions["all"]["desk"].items, 0.1);
end

if string.match(getCore():getVersionNumber(), "41")
  then stockStuff = stockIWBUMS;
  else stockStuff = stockClassic;
end;

stockStuff()
