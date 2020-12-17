
-- modded version
function self.createMenu( _playerNum, _object, _objects, _x, _y, _test )
  print('In the modded version')
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


-- original version
function self.createMenu( _playerNum, _object, _objects, _x, _y, _test )
  print('Now In original version of ISMenuContextWorld.createMenu')
  local playerObj = getSpecificPlayer(_playerNum);
  if playerObj:isDead() or playerObj:isAsleep() or UIManager.getSpeedControls():getCurrentGameSpeed() == 0 then return end
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
