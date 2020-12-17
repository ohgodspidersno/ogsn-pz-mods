require 'Context/ISMenuContextWorld'
ISMenuContextWorldOGSN = ISMenuContextWorld -- create impostor object
ISMenuContextWorldOGSN.originalCreateMenu = ISMenuContextWorld.createMenu -- teach it the original object's "createMenu" skill

function ISMenuContextWorldOGSN.newCreateMenu( _playerNum, _object, _objects, _x, _y, _test )-- teach it it's own new skill called "newCreateMenu"
  print('In the modded version') -- in this case it's basically the same as the original except it doesn't check if it's paused
  local playerObj = getSpecificPlayer(_playerNum);
  if playerObj:isDead() or playerObj:isAsleep() then return end
  self.reset(_playerNum);
  local context;
  if not _test then
    context = ISWorldObjectContextMenu.createMenu( _playerNum, _objects, _x, _y ) or ISContextMenu.get( _playerNum, _x, _y );
    context:setVisible(true);
  else
    local test = ISWorldObjectContextMenu.createMenu( _playerNum, _objects, _x, _y, _test );
    if test then
      return true;
    end
    context = ISContextMenu.get( _playerNum, _x, _y );
    context:setVisible(false);
  end

  getCell():setDrag(nil, _playerNum);

  local contextData = self.getContextData(_playerNum);

  contextData.context = context;
  contextData.playerNum = _playerNum;
  contextData.player = playerObj;
  contextData.playerRoom = playerObj:getCurrentSquare():getRoom();
  contextData.inventory = playerObj:getInventory();
  contextData.object = _object;
  contextData.objects = _objects;
  contextData.test = _test;

  if JoypadState.players[_playerNum + 1] then
    contextData.isJoypad = true;
    contextData.playerData = getPlayerData(_playerNum);
  end

  contextData.objects = self.getAllObjects(contextData);

  if not JoypadState.players[_playerNum + 1] then
    local wx, wy = ISCoordConversion.ToWorld( _x * getCore():getZoom(contextData.playerNum), _y * getCore():getZoom(contextData.playerNum), contextData.player:getZ() );
    self.getObjectsSquare( contextData, getCell():getGridSquare(wx, wy, contextData.player:getZ()) );
  end

  self.printDebug(contextData);

  for index, element in self.elements.indexIterator() do
    local test = element.createMenu( contextData );
    if _test and test then
      return true;
    end
  end

  if _test then return false end

  if context.numOptions == 1 then
    context:setVisible(false);
  end
  return context;
end

ISMenuContextWorld.createMenu( _playerNum, _object, _objects, _x, _y, _test ) -- Now we tell the original object to rewrite its creatMenu skill...

if UIManager.getSpeedControls():getCurrentGameSpeed() == 0 then
  ISMenuContextWorldOGSN.newCreateMenu( _playerNum, _object, _objects, _x, _y, _test ) -- if it's paused we tell it to let the impostor do our new modified version
else
  ISMenuContextWorldOGSN.originalCreateMenu( _playerNum, _object, _objects, _x, _y, _test ) -- otherwise we tell it to let the impostor do the original version
end
