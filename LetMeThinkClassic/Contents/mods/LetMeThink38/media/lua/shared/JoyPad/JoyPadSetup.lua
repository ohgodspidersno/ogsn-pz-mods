JoypadState = {}
JoypadState.count = 0
JoypadState.players = {}
JoypadState.joypads = {}
JoypadState.uiActive = true;
JoypadState.forceActivate = nil;
JoypadState.ignoreActivateTime = 0

Joypad = {}
Joypad.AButton = 0;
Joypad.BButton = 1;
Joypad.XButton = 2;
Joypad.YButton = 3;
Joypad.LBumper = 4;
Joypad.RBumper = 5;
Joypad.Back = 6
Joypad.Start = 7
Joypad.Other = 8

joypad = {}
joypad.wantNoise = getDebug()
local noise = function(msg)
  if (joypad.wantNoise) then print('joypad: '..tostring(msg)) end
end

function getFocusForPlayer(player)
  if JoypadState.players[player + 1] == nil then return nil; end
  return JoypadState.players[player + 1].focus;
end

local function fillJoypadListBox(joypadData)
  local listBox = joypadData.listBox
  listBox:clear()
  listBox:setScrollHeight(0)
  if JoypadState.players[1] == nil then
    listBox:addItem(getText("IGUI_Controller_TakeOverPlayer"), { cmd = "takeover" });
  end
  if not isDemo() then
    listBox:addItem(getText("IGUI_Controller_AddNewPlayer"), { cmd = "addnew" });
    if Core.isLastStand() then
      local players = LastStandPlayerSelect:getAllSavedPlayers()
      for _, player in ipairs(players) do
        local inUse = false
        for playerNum = 0, getNumActivePlayers() - 1 do
          local playerObj = getSpecificPlayer(playerNum)
          if playerObj and not playerObj:isDead() then
            if playerObj:getDescriptor():getForename() == player.forename and playerObj:getDescriptor():getSurname() == player.surname then
              inUse = true
              break
            end
          end
        end
        if not inUse then
          local label = getText("IGUI_Controller_AddSavedPlayer", player.forename, player.surname)
          listBox:addItem(label, { cmd = "addsaved", player = player })
        end
      end
    else
      local players = IsoPlayer.getAllSavedPlayers()
      for n = 1, players:size() do
        local player = players:get(n - 1)
        if not player:isSaveFileInUse() and player:isSaveFileIPValid() then
          local label = getText("IGUI_Controller_AddSavedPlayer", player:getDescriptor():getForename(), player:getDescriptor():getSurname())
          listBox:addItem(label, { cmd = "addsaved", player = player })
        end
      end
    end
  end
  listBox:addItem(getText("UI_Cancel"), { cmd = "cancel" });
  listBox.selected = 1
  listBox:setHeight(math.min(listBox:getScrollHeight(), getCore():getScreenHeight()))
end

function JoypadState.getUserNameCallback(target, button, playerObj, joypadData)
  if button.internal == "OK" then
    local username = button.parent.entry:getText()
    if username and username ~= "" then
      for i = 0, getMaxActivePlayers() - 1 do
        local player = getSpecificPlayer(i)
        if not player or player:isDead() then
          joypadData.player = i
          break
        end
      end
      --joypadData.player = 3;
      JoypadState.players[joypadData.player + 1] = joypadData
      local joypadIndex = joypadData.id
      setPlayerJoypad(joypadData.player, joypadIndex, playerObj, username)
    else
      joypadData.focus = joypadData.listBox
      joypadData.cancelled = true
    end
  end
  if button.internal == "CANCEL" then
    joypadData.focus = joypadData.listBox
    joypadData.cancelled = true
  end
end

local function onPauseButtonPressed(joypadData)
  if UIManager.getSpeedControls() and not isClient() then
    if UIManager.getSpeedControls():getCurrentGameSpeed() == 0 or getGameTime():getTrueMultiplier() > 1 then
      if MainScreen.instance and MainScreen.instance.inGame and MainScreen.instance:getIsVisible() then
        -- return to game below
      elseif joypadData.pauseKeyTime and (joypadData.pauseKeyTime + 750 > Calendar.getInstance():getTimeInMillis()) then
        -- double-tap, go to main menu below
      else
        UIManager.getSpeedControls():ButtonClicked("Play")
        return
      end
    else
      joypadData.pauseKeyTime = Calendar.getInstance():getTimeInMillis()
      UIManager.getSpeedControls():ButtonClicked("Pause")
      return
    end
  end
  if MainScreen.instance and MainScreen.instance.inGame then
    ISUIHandler.setVisibleAllUI(MainScreen.instance:getIsVisible())
    MainScreen.instance:setVisible(not MainScreen.instance:getIsVisible())
    if MainScreen.instance:getIsVisible() then
      getCell():setDrag(nil, 0)
      setGameSpeed(0)
      setShowPausedMessage(false)
      JoypadState.saveAllFocus()
      joypadData.focus = MainScreen.instance
    else
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
  if button == Joypad.YButton and joypadData.player and getPlayerData(joypadData.player) and getSpecificPlayer(joypadData.player) then
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
    wheel:setVisible(true)
    setJoypadFocus(joypadData.player, wheel)
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
  end

end

function getJoypadFocus(playerID)
  local joypadData = JoypadState.players[playerID + 1];

  return joypadData.focus;
end

function setJoypadFocus(playerID, control)
  local joypadData = JoypadState.players[playerID + 1];

  if control ~= nil and control ~= joypadData.focus then
    noise("focus changed - bumping down prevs");
    if joypadData.focus then
      noise("current: "..joypadData.focus:toString());
    else
      noise("current: nil");
    end
    if joypadData.prevfocus then
      noise("prev: "..joypadData.prevfocus:toString());
    else
      noise("prev: nil");
    end

    joypadData.prevprevfocus = joypadData.prevfocus;
    joypadData.prevfocus = joypadData.focus;
  end
  joypadData.focus = control;

  --  updateJoypadFocus(joypadData);
end

function setPrevFocusForPlayer(playerID)
  local joypadData = JoypadState.players[playerID + 1];
  noise("set previous focus");
  noise("current:");
  noise(joypadData.focus);
  noise("prev:");
  noise(joypadData.prevfocus);
  joypadData.focus = joypadData.prevfocus;
  joypadData.prevfocus = joypadData.prevprevfocus;
  joypadData.prevprevfocus = nil;
  -- joypadData.lastfocus = nil;

  --  updateJoypadFocus(joypadData);
end


function setPrevPrevFocusForPlayer(playerID)
  local joypadData = JoypadState.players[playerID + 1];
  noise("set previous focus");
  noise("current:");
  noise(joypadData.focus);
  noise("prev:");
  noise(joypadData.prevfocus);
  joypadData.focus = joypadData.prevprevfocus;
  joypadData.prevfocus = nil;
  joypadData.prevprevfocus = nil;
  -- joypadData.lastfocus = nil;

  --  updateJoypadFocus(joypadData);
end

function updateJoypadFocus(joypadData)


  if joypadData.lastfocus ~= joypadData.focus then
    local lastfocus = joypadData.lastfocus
    joypadData.lastfocus = nil
    if joypadData.focus ~= nil then
      noise("focus in "..joypadData.focus:toString())
      joypadData.focus:onGainJoypadFocus(joypadData);
    end

    if lastfocus ~= nil then
      noise("focus out "..lastfocus:toString())
      lastfocus:onLoseJoypadFocus(joypadData);
    end

  end

  if joypadData.player ~= nil and getSpecificPlayer(joypadData.player) then
    if joypadData.focus ~= nil then
      joypadData.lastactualfocus = joypadData.focus;
      setPlayerMovementActive(joypadData.player, false);
    else
      setPlayerMovementActive(joypadData.player, true);
    end
    joypadData.lastfocus = joypadData.focus;

    if joypadData.focus == nil and getPlayerData(joypadData.player) then
      local buts = getButtonPrompts(joypadData.player);

      if buts ~= nil then
        buts:getBestAButtonAction(nil);
        buts:getBestBButtonAction(nil);
        buts:getBestYButtonAction(nil);
        buts:getBestXButtonAction(nil);
        buts:getBestLBButtonAction(nil);
        buts:getBestRBButtonAction(nil);
      end
    end
  else
    joypadData.lastfocus = joypadData.focus;
  end
end

function onJoypadPressUp(joypadIndex, joypadData)
  if joypadData.focus ~= nil then
    if joypadData.focus:getIsVisible() then
      joypadData.focus:onJoypadDirUp(joypadData);
    end
  elseif getCell():getDrag(joypadData.player) then
    getCell():getDrag(joypadData.player):onJoypadDirUp(joypadData);
  else
    local playerObj = getSpecificPlayer(joypadData.player)
    ItemBindingHandler.equipBestWeapon(playerObj, "Firearm")
  end
end
function onJoypadPressDown(joypadIndex, joypadData)
  if joypadData.focus ~= nil then
    if joypadData.focus:getIsVisible() then
      joypadData.focus:onJoypadDirDown(joypadData);
    end
  elseif getCell():getDrag(joypadData.player) then
    getCell():getDrag(joypadData.player):onJoypadDirDown(joypadData);
  end
end
function onJoypadPressLeft(joypadIndex, joypadData)
  if joypadData.focus ~= nil then
    if joypadData.focus:getIsVisible() then
      joypadData.focus:onJoypadDirLeft(joypadData);
    end
  elseif getCell():getDrag(joypadData.player) then
    getCell():getDrag(joypadData.player):onJoypadDirLeft(joypadData);
  else
    local playerObj = getSpecificPlayer(joypadData.player)
    ItemBindingHandler.equipBestWeapon(playerObj, "Swinging")
  end
end

function onJoypadPressRight(joypadIndex, joypadData)
  if joypadData.focus ~= nil then
    if joypadData.focus:getIsVisible() then
      joypadData.focus:onJoypadDirRight(joypadData);
    end
  elseif getCell():getDrag(joypadData.player) then
    getCell():getDrag(joypadData.player):onJoypadDirRight(joypadData);
  else
    local playerObj = getSpecificPlayer(joypadData.player)
    ItemBindingHandler.equipBestWeapon(playerObj, "Stab")
  end
end

local function translateButton(joypad, button)
  if button == getJoypadAButton(joypad) then return Joypad.AButton end
  if button == getJoypadBButton(joypad) then return Joypad.BButton end
  if button == getJoypadXButton(joypad) then return Joypad.XButton end
  if button == getJoypadYButton(joypad) then return Joypad.YButton end
  if button == getJoypadLBumper(joypad) then return Joypad.LBumper end
  if button == getJoypadRBumper(joypad) then return Joypad.RBumper end
  if button == getJoypadBackButton(joypad) then return Joypad.Back end
  if button == getJoypadStartButton(joypad) then return Joypad.Start end
  return Joypad.Other
end

function onJoypadRenderTick(ticks)
  if JoypadState.controllerTest then return end
  if getCore() and getCore():isDedicated() then return end
  local t = getTimestampMs()
  for i, v in pairs(JoypadState.joypads) do
    if isJoypadDown(i) then
      if not v.down then v.timedown = t; v.timedownproc = 0 end
      v.down = true
      v.dtdown = t - v.timedown
      v.dtprocdown = t - v.timedownproc
    else
      v.timedown = 0
      v.down = false
    end
    if isJoypadUp(i) then
      if not v.up then v.timeup = t; v.timeupproc = 0 end
      v.up = true
      v.dtup = t - v.timeup
      v.dtprocup = t - v.timeupproc
    else
      v.timeup = 0
      v.up = false
    end
    v.lastleft = v.left;
    v.left = isJoypadLeft(i);
    v.lastright = v.right;
    v.right = isJoypadRight(i);

    --print("DEBUG: v.down="..tostring(v.down).." v.dtdown="..tostring(v.dtdown).." v.timedown="..tostring(v.timedown).." v.dtprocdown="..tostring(v.dtprocdown))
    --print("DEBUG: v.up="..tostring(v.up).." v.dtup="..tostring(v.dtup).." v.timeup="..tostring(v.timeup).." v.dtprocup="..tostring(v.dtprocup))
    if v.down and v.dtprocdown > 300 then
      onJoypadPressDown(i, v);
      v.timedownproc = t
    elseif v.down and v.dtdown > 900 and v.dtprocdown > 110 then
      onJoypadPressDown(i, v);
      v.timedownproc = t
    elseif v.down and v.dtdown > 3000 and v.dtprocdown > 50 then
      onJoypadPressDown(i, v);
      v.timedownproc = t
    elseif not v.down and v.timedownproc ~= 0 then
      --onJoypadReleaseDown(i, v)
      v.timedownproc = 0
    end
    if v.up and v.dtprocup > 300 then
      onJoypadPressUp(i, v);
      v.timeupproc = t
    elseif v.up and v.dtup > 900 and v.dtprocup > 110 then
      onJoypadPressUp(i, v);
      v.timeupproc = t
    elseif v.up and v.dtup > 3000 and v.dtprocup > 50 then
      onJoypadPressUp(i, v);
      v.timeupproc = t
    elseif not v.up and v.timeupproc ~= 0 then
      --onJoypadReleaseUp(i, v)
      v.timeupproc = 0
    end
    if v.left and not v.lastleft then

      onJoypadPressLeft(i, v);
    end
    if v.right and not v.lastright then
      onJoypadPressRight(i, v);
    end

    for n = 0, getButtonCount(i) - 1 do
      if v.pressed[n] == nil then v.pressed[n] = true; end
      v.wasPressed[n] = v.pressed[n];
      v.pressed[n] = isJoypadPressed(i, n);
      if v.pressed[n] and not v.wasPressed[n] then
        local button = translateButton(v.id, n)
        onJoypadPressButton(i, v, button)
      end
    end

    local backButton = getJoypadBackButton(v.id)
    if v.player and getPlayerData(v.player) and v.wasPressed[backButton] and not v.pressed[backButton] then
      local wheel = getPlayerBackButtonWheel(v.player)
      if v.focus == wheel then
        wheel:onBackButtonReleased()
      end
    end

    updateJoypadFocus(v);
  end
end


function onJoypadActivate(id)
  if JoypadState.controllerTest then return end
  if getCore():getGameMode() == "Tutorial" then return end
  if getPlayer() == nil then
    return;
  end
  if JoypadState.joypads[id] == nil then
    if JoypadState.ignoreActivateTime > Calendar.getInstance():getTimeInMillis() then
      return
    end
    local joypadData = {}
    local listBox = ISScrollingListBox:new(0, 0, 200, 400);
    listBox:initialise();
    listBox:instantiate();
    listBox:setUIName("JoypadListbox"..id)
    listBox:setAnchorLeft(true);
    listBox:setAnchorRight(true);
    listBox:setAnchorTop(true);
    listBox:setAnchorBottom(true);
    listBox:setAlwaysOnTop(true)
    listBox.selected = 1;
    listBox:setVisible(true);
    joypadData.id = id;
    joypadData.pressed = {}
    joypadData.wasPressed = {}
    for n = 1, getButtonCount(id) do
      joypadData.pressed[n - 1] = isJoypadPressed(id, n - 1)
    end
    joypadData.focusList = LuaList:new();
    listBox:setController(id);
    joypadData.listBox = listBox
    joypadData.focus = joypadData.listBox;
    joypadData.timepressdown = 0
    joypadData.timepressup = 0
    JoypadState.joypads[id] = joypadData
    JoypadState.count = JoypadState.count + 1
    JoypadState[JoypadState.count] = joypadData
    fillJoypadListBox(joypadData)
    listBox:addToUIManager();
  end
end

function onJoypadActivateUI(id)
  if JoypadState.controllerTest then return end
  if JoypadState.uiActive and getPlayer() == nil then
    if JoypadState.joypads[id] == nil then
      if not MainScreen.instance then return end
      if not MainScreen.instance.bottomPanel:getIsVisible() then return end
      local joypadData = {}
      joypadData = {}
      joypadData.id = id
      joypadData.pressed = {}
      joypadData.wasPressed = {}
      for n = 1, getButtonCount(id) do
        joypadData.pressed[n - 1] = isJoypadPressed(id, n - 1)
      end
      joypadData.focusList = LuaList:new()
      JoypadState.joypads[id] = joypadData
      JoypadState.count = JoypadState.count + 1
      JoypadState[JoypadState.count] = joypadData
      joypadData.focus = MainScreen.instance
      updateJoypadFocus(joypadData)
      JoypadState.uiActive = false
    end
  end
end

function JoypadState.saveAllFocus()
  JoypadState.saveFocus = {}
  for i, joypadData in pairs(JoypadState.joypads) do
    JoypadState.saveFocus[i] = joypadData.focus
  end
end

function JoypadState.restoreAllFocus()
  for i, joypadData in pairs(JoypadState.joypads) do
    if JoypadState.saveFocus[i] and JoypadState.saveFocus[i]:getIsVisible() then
      joypadData.focus = JoypadState.saveFocus[i]
    else
      joypadData.focus = nil
    end
  end
  JoypadState.saveFocus = {}
end

function JoypadState.onPlayerDeath(playerObj)
  local playerNum = playerObj:getPlayerNum()
  local joypadData = JoypadState.players[playerNum + 1]
  if joypadData then
    noise('removing joypad player '..playerNum)
    joypadData.player = nil
    joypadData.focusList:clear()
    joypadData.focus = joypadData.listBox
    joypadData.lastfocus = nil
    joypadData.prevfocus = nil
    joypadData.prevprevfocus = nil
    joypadData.cancelled = true
  end
end

function JoypadState.onCoopJoinFailed(playerNum)
  local joypadData = JoypadState.players[playerNum + 1]
  if joypadData then
    joypadData.focus = joypadData.listBox
    joypadData.cancelled = true
  end
end

JoypadState.onGameStart = function()
  if getCore():getGameMode() == "Tutorial" then return end
  if JoypadState.forceActivate then
    noise("force activate")
    onJoypadActivate(JoypadState.forceActivate)
    JoypadState.forceActivate = nil
    updateJoypadFocus(JoypadState[1])
    onJoypadPressButton(JoypadState[1].id, JoypadState[1], Joypad.AButton)
  end
end

Events.OnJoypadActivate.Add(onJoypadActivate);
Events.OnJoypadActivateUI.Add(onJoypadActivateUI);
Events.OnRenderTick.Add(onJoypadRenderTick);
Events.OnGameStart.Add(JoypadState.onGameStart);
--Events.OnPlayerDeath.Add(JoypadState.onPlayerDeath);
Events.OnCoopJoinFailed.Add(JoypadState.onCoopJoinFailed)
