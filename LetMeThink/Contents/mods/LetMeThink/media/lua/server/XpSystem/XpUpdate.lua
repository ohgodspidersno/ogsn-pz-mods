local versionNumber = getCore():getVersionNumber()
if string.find(versionNumber,"41.50") then
  require "XpSystem/xpUpdate_LetMeThink4150"
else
  require "XpSystem/xpUpdate_LetMeThink4151"
end

xpUpdate = xpUpdate or {};
