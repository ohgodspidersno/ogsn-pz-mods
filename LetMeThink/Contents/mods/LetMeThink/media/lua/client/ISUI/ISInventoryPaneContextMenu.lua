local versionNumber = getCore():getVersionNumber()
if string.find(versionNumber,"41.50") then
  require "ISUI/ISInventoryPaneContextMenu_LetMeThink4150"
else
  require "ISUI/ISInventoryPaneContextMenu_LetMeThink4151"
end

ISInventoryPaneContextMenu = ISInventoryPaneContextMenu or {};
