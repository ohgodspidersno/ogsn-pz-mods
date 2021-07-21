local versionNumber = getCore():getVersionNumber()
if string.find(versionNumber,"41.50") then
  require "ISUI/ISInventoryPage_LetMeThink4150"
else
  require "ISUI/ISInventoryPage_LetMeThink4151"
end

ISInventoryPage = ISInventoryPage or {};
