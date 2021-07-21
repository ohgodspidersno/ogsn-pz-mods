--***********************************************************
--**                    THE INDIE STONE                    **
--**				  Author: turbotutone				   **
--***********************************************************
local versionNumber = getCore():getVersionNumber()
if string.find(versionNumber,"41.50") then
  print("version number is 41.50, loading ISMenuContextWorld_LetMeThink4150")
  require "Context/ISMenuContextWorld_LetMeThink4150"
else
  print("version number is 41.51, loading ISMenuContextWorld_LetMeThink4151")
  require "Context/ISMenuContextWorld_LetMeThink4151"
end

ISMenuContextWorld = ISMenuContextWorld or {};
