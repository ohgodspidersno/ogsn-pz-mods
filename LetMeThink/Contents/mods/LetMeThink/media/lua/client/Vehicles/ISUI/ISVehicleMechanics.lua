local versionNumber = getCore():getVersionNumber()
if string.find(versionNumber,"41.50") then
  require "Vehicles/ISUI/ISVehicleMechanics_LetMeThink4150"
else
  require "Vehicles/ISUI/ISVehicleMechanics_LetMeThink4151"
end

ISVehicleMechanics = ISVehicleMechanics or {};
