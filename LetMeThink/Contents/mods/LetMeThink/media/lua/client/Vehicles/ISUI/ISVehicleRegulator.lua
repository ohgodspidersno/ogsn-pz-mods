local versionNumber = getCore():getVersionNumber()
if string.find(versionNumber,"41.50") then
  require "Vehicles/ISUI/ISVehicleRegulator_LetMeThink4150"
else
  require "Vehicles/ISUI/ISVehicleRegulator_LetMeThink4151"
end

ISVehicleRegulator = ISVehicleRegulator or {};
