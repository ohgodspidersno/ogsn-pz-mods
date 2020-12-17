-- require "Map/CGlobalObjectSystem"
-- CCampfireSystem = CGlobalObjectSystem:derive("CCampfireSystem")
--
-- function CCampfireSystem:new()
-- 	local o = CGlobalObjectSystem.new(self, "campfire")
-- 	return o
-- end

require 'Context/ISMenuContextWorld'
ISMenuContextWorld_original = ISMenuContextWorld

function ISMenuContextWorld.new()
  local self = ISMenuContextWorld_original.new();
  self.createMenu_original = self.createMenu
  function self.createMenu_new( _playerNum, _object, _objects, _x, _y, _test )
        -- rest goes here
  end

  function self.createMenu( _playerNum, _object, _objects, _x, _y, _test )
    if UIManager.getSpeedControls():getCurrentGameSpeed() ~= 0 then
        self.createMenu_original( _playerNum, _object, _objects, _x, _y, _test )
    else
        self.createMenu_new( _playerNum, _object, _objects, _x, _y, _test )
    end
  end
end
