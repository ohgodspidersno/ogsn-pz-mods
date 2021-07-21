local versionNumber = getCore():getVersionNumber()
if string.find(versionNumber,"41.50") then
  require "ISUI/ISButtonPrompt_LetMeThink4150"
else
  require "ISUI/ISButtonPrompt_LetMeThink4151"
end

ISButtonPrompt = ISButtonPrompt or {};


 
