require 'Vehicles/VehicleDistributions'
require 'Items/Distributions';

Distributions = Distributions or {}

-- Distributions
table.insert(Distributions['all']['desk'].items, 'Base.KnoxCountryMapSecret');
table.insert(Distributions['all']['desk'].items, 0.0005);

table.insert(Distributions['Bag_WeaponBag'].items, 'Base.KnoxCountryMapSecret');
table.insert(Distributions['Bag_WeaponBag'].items, 1);

-- VehicleDistributions
VehicleDistributions.GloveBoxSecretMapRare = VehicleDistributions.GloveBox
table.insert(VehicleDistributions['GloveBoxSecretMapRare'].items,'Base.KnoxCountryMapSecret');
table.insert(VehicleDistributions['GloveBoxSecretMapRare'].items, 1);

VehicleDistributions.GloveBoxSecretMapOnly = {rolls = 1, items = {'KnoxCountryMapSecret', 100,},}

VehicleDistributions.Police.GloveBox = VehicleDistributions.GloveBoxSecretMapRare
VehicleDistributions.Ranger.GloveBox = VehicleDistributions.GloveBoxSecretMapRare
VehicleDistributions.Fire.GloveBox = VehicleDistributions.GloveBoxSecretMapRare

VehicleDistributions.Radio.GloveBox = VehicleDistributions.GloveBoxSecretMapOnly
