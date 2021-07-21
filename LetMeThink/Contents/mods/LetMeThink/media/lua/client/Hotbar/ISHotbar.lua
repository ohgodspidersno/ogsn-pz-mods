local versionNumber = getCore():getVersionNumber()
if string.find(versionNumber,"41.50") then
  require "Hotbar/ISHotbar_LetMeThink4150"
else
  require "Hotbar/ISHotbar_LetMeThink4151"
end

ISHotbar = ISHotbar or {};
