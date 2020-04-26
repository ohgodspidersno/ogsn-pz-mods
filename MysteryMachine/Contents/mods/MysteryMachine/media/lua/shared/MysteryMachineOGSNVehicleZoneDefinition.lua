if VehicleZoneDistribution then -- check if the table exists for backwards compatibility

  VehicleZoneDistribution.police.chanceToSpawnNormal = 70;
  VehicleZoneDistribution.fire.vehicles["Base.MysteryMachine"] = {index = -1, spawnChance = 1};
  VehicleZoneDistribution.ranger.vehicles["Base.MysteryMachine"] = {index = 0, spawnChance = 1};
  VehicleZoneDistribution.mccoy.vehicles["Base.MysteryMachine"] = {index = 1, spawnChance = 1};
  VehicleZoneDistribution.postal.vehicles["Base.MysteryMachine"] = {index = 2, spawnChance = 1};
  VehicleZoneDistribution.spiffo.vehicles["Base.MysteryMachine"] = {index = -1, spawnChance = 1};
  VehicleZoneDistribution.ambulance.vehicles["Base.MysteryMachine"] = {index = -1, spawnChance = 1};
  VehicleZoneDistribution.radio.vehicles["Base.MysteryMachine"] = {index = -1, spawnChance = 1};
  VehicleZoneDistribution.fossoil.vehicles["Base.MysteryMachine"] = {index = 0, spawnChance = 1};

end
