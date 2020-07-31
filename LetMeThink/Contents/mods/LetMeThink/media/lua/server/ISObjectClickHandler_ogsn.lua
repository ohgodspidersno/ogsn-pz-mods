
local ISObjectClickHandler_doClick_original = ISObjectClickHandler.doClick
ISObjectClickHandler.doClick = function (object, x, y, ...)
  local sq = object:getSquare();
  if instanceof(object, "IsoMovingObject") then
    sq = object:getCurrentSquare();
  end

  if not sq:isSeen(0) then
    return;
  end

  local playerObj = getSpecificPlayer(0)

  if isClient() and SafeHouse.isSafeHouse(sq, playerObj:getUsername(), true) and
  not getServerOptions():getBoolean("SafehouseAllowLoot") then
    return
  end

  if object:getContainer() and not playerObj:IsAiming() then
    if instanceof(object, "IsoThumpable") and object:isLockedToCharacter(playerObj) then
      return
    end
    local parent = object:getSquare();

    if parent ~= nil then
      local playerSq = playerObj:getCurrentSquare()
      if not playerSq or math.abs(playerSq:getX() - parent:getX()) > 1 or
      math.abs(playerSq:getY() - parent:getY()) > 1 or
      playerSq:getZ() ~= parent:getZ() or
      playerSq:isBlockedTo(parent) then
        -- out of range
      else
        --print("adding open container.")
        -- ISTimedActionQueue.add(ISOpenContainerTimedAction:new(getPlayer(), object:getContainer(), 20, x, y));
        if not object:getContainer():isExplored() then

          if not isClient() then
            ItemPicker.fillContainer(object:getContainer(), playerObj);
          else
            object:getContainer():requestServerItemsForContainer();
          end
          object:getContainer():setExplored(true);
        end
        local panel2 = getPlayerLoot(0);

        panel2:setNewContainer(object:getContainer());
        panel2:setVisible(true);
        panel2.lootAll:setVisible(true);
        panel2.collapseCounter = 0;
        if panel2.isCollapsed then
          panel2.isCollapsed = false;
          panel2:clearMaxDrawHeight();
          panel2.collapseCounter = -30;
        end
      end
    end
  end

  local isPaused = UIManager.getSpeedControls|() and UIManager.getSpeedControls|():getCurrentGameSpeed() == 0
  if not isPaused then
    ISObjectClickHandler_doClick_original(self, object, x, y, ...)
  end
  if getCore():getGameMode() ~= "Tutorial" and instanceof(object, "IsoWaveSignal") and playerObj:isAlive() and not playerObj:IsAiming() and
  playerObj:getCurrentSquare() and object:getSquare() and
  playerObj:DistToSquared(object:getX() + 0.5, object:getY() + 0.5) < 1.5 * 1.5 and
  not playerObj:getCurrentSquare():isSomethingTo(object:getSquare()) then
    ISRadioWindow.activate(playerObj, object)
  end
end
