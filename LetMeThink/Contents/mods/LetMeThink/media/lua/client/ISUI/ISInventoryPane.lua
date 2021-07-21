local versionNumber = getCore():getVersionNumber()
if string.find(versionNumber,"41.50") then
  require "ISUI/ISInventoryPane_LetMeThink4150"
else
  require "ISUI/ISInventoryPane_LetMeThink4151"
end

ISInventoryPane = ISInventoryPane or {};
