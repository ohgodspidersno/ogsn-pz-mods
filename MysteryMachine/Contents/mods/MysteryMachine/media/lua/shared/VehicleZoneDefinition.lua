if VehicleZoneDistribution then
  -- mysterymachine zone
  VehicleZoneDistribution.mysterymachine = {};
  VehicleZoneDistribution.mysterymachine.vehicles = {};
  VehicleZoneDistribution.mysterymachine.vehicles["Base.VanMysterymachine"] = {index = -1, spawnChance = 100};
  VehicleZoneDistribution.mysterymachine.specialCar = true;

  -- also may rarely appear in other zones
  VehicleZoneDistribution.spiffo.vehicles["Base.VanMysterymachine"] = {index = -1, spawnChance = 1};
  VehicleZoneDistribution.radio.vehicles["Base.VanMysterymachine"] = {index = -1, spawnChance = 1};
end
