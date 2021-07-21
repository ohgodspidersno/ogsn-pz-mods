local versionNumber = getCore():getVersionNumber()
if string.find(versionNumber,"41.50") then
  require "ISUI/ISFirearmRadialMenu_LetMeThink4150"
else
  require "ISUI/ISFirearmRadialMenu_LetMeThink4151"
end

ISFirearmRadialMenu = ISFirearmRadialMenu or {};
