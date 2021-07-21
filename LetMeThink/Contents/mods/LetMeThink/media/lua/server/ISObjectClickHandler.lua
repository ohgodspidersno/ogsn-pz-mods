local versionNumber = getCore():getVersionNumber()
if string.find(versionNumber,"41.50") then
  require "ISObjectClickHandler_LetMeThink4150"
else
  require "ISObjectClickHandler_LetMeThink4151"
end

ISObjectClickHandler = ISObjectClickHandler or {};
