local versionNumber = getCore():getVersionNumber()
if string.find(versionNumber,"41.50") then
  require "ISUI/ISEmoteRadialMenu_LetMeThink4150"
else
  require "ISUI/ISEmoteRadialMenu_LetMeThink4151"
end

ISEmoteRadialMenu = ISEmoteRadialMenu or {};
