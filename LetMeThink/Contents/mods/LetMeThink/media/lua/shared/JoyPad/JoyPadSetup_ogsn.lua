
local function onPauseButtonPressed(joypadData)
  if UIManager.getSpeedControls|() and not isClient() then
    if UIManager.getSpeedControls|():getCurrentGameSpeed() == 0 or getGameTime():getTrueMultiplier() > 1 then
      if MainScreen.instance and MainScreen.instance.inGame and MainScreen.instance:getIsVisible() then
        -- return to game below
      elseif joypadData.pauseKeyTime and (joypadData.pauseKeyTime + 750 > Calendar.getInstance():getTimeInMillis()) then
        -- double-tap, go to main menu below
      else
        UIManager.getSpeedControls|():ButtonClicked("Play")
        return
      end
    else
      joypadData.pauseKeyTime = Calendar.getInstance():getTimeInMillis()
      UIManager.getSpeedControls|():ButtonClicked("Pause")
      return
    end
  end
  if MainScreen.instance and MainScreen.instance.inGame then
    ISUIHandler.setVisibleAllUI(MainScreen.instance:getIsVisible())
    if MainScreen.instance:getIsVisible() then
      MainScreen.instance:setVisible(false)
      MainScreen.instance:removeFromUIManager()
    else
      MainScreen.instance:setVisible(true)
      MainScreen.instance:addToUIManager()
    end
    if MainScreen.instance:getIsVisible() then
      getCell():setDrag(nil, 0)
      setGameSpeed(0)
      setShowPausedMessage(false)
      JoypadState.saveAllFocus()
      joypadData.focus = MainScreen.instance
      MainScreen.instance:onEnterFromGame()
    else
      MainScreen.instance:onReturnToGame()
      setGameSpeed(1);
      setShowPausedMessage(true)
      JoypadState.restoreAllFocus()
    end
  end
end

function onJoypadPressButton(joypadIndex, joypadData, button)
  if MainScreen.instance and MainScreen.instance.inGame and MainScreen.instance:getIsVisible() then
    if button == Joypad.Start and joypadData.focus == MainScreen.instance then
      onPauseButtonPressed(joypadData)
    elseif joypadData.focus then
      joypadData.focus:onJoypadDown(button, joypadData)
    end
    return
  end

  if not joypadData.activeWhilePaused and UIManager.getSpeedControls|() and UIManager.getSpeedControls|():getCurrentGameSpeed() == 0 and button ~= Joypad.Start and button ~= Joypad.Back then
    return;
  end

  if joypadData.player and getCell() and getCell():getDrag(joypadData.player) then
    getCell():getDrag(joypadData.player):onJoypadPressButton(joypadIndex, joypadData, button);
    return;
  end

  if button == Joypad.AButton and joypadData.cancelled and not IsoPlayer.allPlayersDead() then
    -- The listBox was previously shown, but the user chose "Cancel"
    noise('showing listBox again')
    joypadData.cancelled = nil
    joypadData.focus = joypadData.listBox
    fillJoypadListBox(joypadData)
    joypadData.listBox:setVisible(true)
    joypadData.listBox:addToUIManager()
    return
  end

  if button == Joypad.AButton and joypadData.focus and joypadData.focus == joypadData.listBox and joypadData.focus:getIsVisible() then
    local item = joypadData.listBox.items[joypadData.listBox.selected].item
    if item.cmd == "takeover" then
      if not (getSpecificPlayer(0) and getSpecificPlayer(0):isAlive()) then return end
      joypadData.player = 0;
      JoypadState.players[1] = joypadData;
      setPlayerJoypad(0, joypadIndex, getSpecificPlayer(0), nil);
      createPlayerData(0);

      getPlayerInventory(0):setController(joypadIndex);
      getPlayerLoot(0):setController(joypadIndex);
    elseif item.cmd == "addnew" then
      CoopCharacterCreation.newPlayer(joypadIndex, joypadData)
      return
    elseif item.cmd == "addsaved" then
      if isClient() then
        joypadData.listBox:setVisible(false)
        joypadData.listBox:removeFromUIManager()
        local x = (getCore():getScreenWidth() - 260) / 2
        local y = (getCore():getScreenHeight() - 120) / 2
        local username = item.player:getModData().username or ("Player" .. joypadData.player)
        local modal = ISTextBox:new(x, y, 260, 120, getText("UI_servers_username"), username, nil, JoypadState.getUserNameCallback, 0, item.player, joypadData)
        modal:initialise()
        modal:addToUIManager()
        joypadData.focus = modal
        return
      end
      for i = 0, getMaxActivePlayers() - 1 do
        local player = getSpecificPlayer(i)
        if not player or player:isDead() then
          joypadData.player = i
          break
        end
      end
      --joypadData.player = 3;
      JoypadState.players[joypadData.player + 1] = joypadData;
      if Core.isLastStand() then
        local desc = LastStandPlayerSelect:createSurvivorDescFromData(item.player)
        getWorld():setLuaPlayerDesc(desc)
        for i, v in ipairs(item.player.traits) do
          getWorld():addLuaTrait(v)
        end
        item.player = nil
      end
      setPlayerJoypad(joypadData.player, joypadIndex, item.player, nil);
    elseif item.cmd == "cancel" then
      joypadData.listBox:setVisible(false)
      joypadData.listBox:removeFromUIManager()
      joypadData.cancelled = true
      return
    end
    joypadData.listBox:setVisible(false);
    joypadData.listBox:removeFromUIManager();
    joypadData.focus = nil;

    if(joypadData.player == nil) then
      noise("ERROR: PLAYER # NOT SET FOR JOYPAD");
    end
  end


  local justOpened = false;
  if not JoypadState.disableYInventory and button == Joypad.YButton and joypadData.player and getPlayerData(joypadData.player) and getSpecificPlayer(joypadData.player) then
    -- do inventory stuff. naughty...
    local loot = getPlayerLoot(joypadData.player);
    local inv = getPlayerInventory(joypadData.player);
    if joypadData.focus == nil and getButtonPrompts(joypadData.player):isLootIcon() then
      joypadData.focus = loot;
      justOpened = true;

    elseif joypadData.focus == nil then
      joypadData.focus = inv;
      justOpened = true;
    end

    if getSpecificPlayer(joypadData.player):isAsleep() then
      justOpened = false;
    end

    if joypadData.focus ~= nil and justOpened then
      setJoypadFocus(joypadData.player, joypadData.focus);
      joypadData.focus:setVisible(true);
      getSpecificPlayer(joypadData.player):setBannedAttacking(true);
    else
      getSpecificPlayer(joypadData.player):setBannedAttacking(false);
    end

    updateJoypadFocus(joypadData);
  end

  if button == Joypad.Back and joypadData.focus == nil and joypadData.player and getSpecificPlayer(joypadData.player) then
    local wheel = getPlayerBackButtonWheel(joypadData.player)
    wheel:addCommands()
    wheel:addToUIManager(true)
    wheel:setVisible(true)
    setJoypadFocus(joypadData.player, wheel)
    getSpecificPlayer(joypadData.player):setJoypadIgnoreAimUntilCentered(true)
    return
  end

  if button == Joypad.Start and joypadData.focus == nil and joypadData.player and getSpecificPlayer(joypadData.player) then
    onPauseButtonPressed(joypadData)
    return
  end

  if joypadData.focus ~= nil and not justOpened then
    joypadData.focus:onJoypadDown(button, joypadData);
  elseif joypadData.focus == nil and joypadData.player and getPlayerData(joypadData.player) then
    local buts = getButtonPrompts(joypadData.player);

    if button == Joypad.AButton then
      buts:onAPress();
    end
    if button == Joypad.BButton then
      buts:onBPress();
    end
    if button == Joypad.XButton then
      buts:onXPress();
    end
    if button == Joypad.YButton then
      buts:onYPress();
    end
    if button == Joypad.LBumper then
      buts:onLBPress();
    end
    if button == Joypad.RBumper then
      buts:onRBPress();
    end
  end
end
