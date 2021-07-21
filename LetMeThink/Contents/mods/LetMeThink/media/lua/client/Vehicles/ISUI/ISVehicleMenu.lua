local versionNumber = getCore():getVersionNumber()
if string.find(versionNumber,"41.50") then
  require "Vehicles/ISUI/ISVehicleMenu_LetMeThink4150"
else
  require "Vehicles/ISUI/ISVehicleMenu_LetMeThink4151"
end

ISVehicleMenu = ISVehicleMenu or {};
