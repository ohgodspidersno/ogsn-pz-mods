local versionNumber = getCore():getVersionNumber()
if string.find(versionNumber,"41.50") then
  require "ISUI/ISDPadWheels_LetMeThink4150"
else
  require "ISUI/ISDPadWheels_LetMeThink4151"
end

ISDPadWheels = ISDPadWheels or {};
