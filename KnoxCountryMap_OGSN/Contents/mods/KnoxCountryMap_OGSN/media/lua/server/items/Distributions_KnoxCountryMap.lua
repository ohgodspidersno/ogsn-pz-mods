require 'Items/Distributions'
require 'Items/ProceduralDistributions'
require 'Vehicles/VehicleDistributions'

--[[
ORIGINAL DISTRO CODE BY OH GOD SPIDERS NO (https://steamcommunity.com/id/OhGodSpidersNo)

COMMENTS AND CODE MODIFICATIONS BY PARANOID&AFRAID
--]]

SuburbsDistributions = SuburbsDistributions or {}
ProceduralDistributions = ProceduralDistributions or {}
VehicleDistributions = VehicleDistributions or {}


local function stockVehicles()
  table.insert(VehicleDistributions.GloveBox.items, "Base.KnoxCountryMap")
  table.insert(VehicleDistributions.GloveBox.items, 5)
end

local function stockIWBUMS()
  table.insert(ProceduralDistributions["list"]["MagazineRackMaps"].items, "Base.KnoxCountryMap")
  table.insert(ProceduralDistributions["list"]["MagazineRackMaps"].items, 10)
  table.insert(ProceduralDistributions["list"]["MagazineRackMaps"].items, "Base.KnoxCountryMap")
  table.insert(ProceduralDistributions["list"]["MagazineRackMaps"].items, 10)
  table.insert(ProceduralDistributions["list"]["StoreShelfMechanics"].items, "Base.KnoxCountryMap")
  table.insert(ProceduralDistributions["list"]["StoreShelfMechanics"].items, 1)
  table.insert(ProceduralDistributions["list"]["CrateMechanics"].items, "Base.KnoxCountryMap")
  table.insert(ProceduralDistributions["list"]["CrateMechanics"].items, 1)
end



local function stockClassic()
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

stockVehicles();
if string.match(getCore():getVersionNumber(), "41")
  then stockIWBUMS();
  else stockClassic();
end;
