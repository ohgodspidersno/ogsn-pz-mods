require 'Items/Distributions'
require 'Items/ProceduralDistributions'
require 'Vehicles/VehicleDistributions'

SuburbsDistributions = SuburbsDistributions or {}
ProceduralDistributions = ProceduralDistributions or {}
VehicleDistributions = VehicleDistributions or {}

local function stockIWBUMS()
  -- rethinking this, maybe later
end

-- Distributions
local function stockClassic()
  table.insert(SuburbsDistributions['all']['desk'].items, 'Base.KnoxCountryMapSecret');
  table.insert(SuburbsDistributions['all']['desk'].items, 0.0005);
  table.insert(SuburbsDistributions['Bag_WeaponBag'].items, 'Base.KnoxCountryMapSecret');
  table.insert(SuburbsDistributions['Bag_WeaponBag'].items, 1);
end

-- VehicleDistributions
local function stockVehicles()
  VehicleDistributions.GloveBoxSecretMapRare = VehicleDistributions.GloveBox
  table.insert(VehicleDistributions['GloveBoxSecretMapRare'].items,'Base.KnoxCountryMapSecret');
  table.insert(VehicleDistributions['GloveBoxSecretMapRare'].items, 1);
  VehicleDistributions.GloveBoxSecretMapOnly = {rolls = 1, items = {'KnoxCountryMapSecret', 100,},}
  VehicleDistributions.Police.GloveBox = VehicleDistributions.GloveBoxSecretMapRare
  VehicleDistributions.Ranger.GloveBox = VehicleDistributions.GloveBoxSecretMapRare
  VehicleDistributions.Fire.GloveBox = VehicleDistributions.GloveBoxSecretMapRare
  VehicleDistributions.Radio.GloveBox = VehicleDistributions.GloveBoxSecretMapOnly
end

stockVehicles();
if string.match(getCore():getVersionNumber(), "41")
  then stockIWBUMS();
  else stockClassic();
end;
