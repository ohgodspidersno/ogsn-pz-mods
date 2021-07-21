local versionNumber = getCore():getVersionNumber()
if string.find(versionNumber,"41.50") then
  require "ISUI/ISBackButtonWheel_LetMeThink4150"
else
  require "ISUI/ISBackButtonWheel_LetMeThink4151"
end

ISBackButtonWheel = ISBackButtonWheel or {};
