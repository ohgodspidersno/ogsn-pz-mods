local versionNumber = getCore():getVersionNumber()
if string.find(versionNumber,"41.50") then
  require "XpSystem/ISUI/ISHealthPanel_LetMeThink4150"
else
  require "XpSystem/ISUI/ISHealthPanel_LetMeThink4151"
end

ISHealthPanel = ISHealthPanel or {};
