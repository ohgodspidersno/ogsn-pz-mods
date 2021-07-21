local versionNumber = getCore():getVersionNumber()
if string.find(versionNumber,"41.50") then
  require "ISUI/ISWorldObjectContextMenu_LetMeThink4150"
else
  require "ISUI/ISWorldObjectContextMenu_LetMeThink4151"
end

ISWorldObjectContextMenu = ISWorldObjectContextMenu or {};
