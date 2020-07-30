
function CoopCharacterCreation:accept()
  if not self:accept1() then
    return
  end

  --	self:setVisible(false)
  self:removeFromUIManager()

  if UIManager.getSpeedControls|() and not IsoPlayer.allPlayersDead() then
    setShowPausedMessage(true)
    UIManager.getSpeedControls|():SetCurrentGameSpeed(1)
    if self.joypadData then
      self.joypadData.activeWhilePaused = nil
    end
  end

  CoopCharacterCreation.setVisibleAllUI(true)
  CoopCharacterCreation.instance = nil

  if ISPostDeathUI.instance[self.playerIndex] then
    ISPostDeathUI.instance[self.playerIndex]:removeFromUIManager()
    ISPostDeathUI.instance[self.playerIndex] = nil
  end

  if not self.joypadData then
    setPlayerMouse(nil)
    return
  end

  self.joypadData.player = self.playerIndex
  --	self.joypadData.player = 3
  JoypadState.players[self.joypadData.player + 1] = self.joypadData
  local username = nil
  if isClient() and self.playerIndex > 0 then
    username = CoopUserName.instance:getUserName()
  end
  setPlayerJoypad(self.joypadData.player, self.joypadIndex, nil, username)

  self.joypadData.listBox:setVisible(false)
  self.joypadData.listBox:removeFromUIManager()
  self.joypadData.focus = nil
  self.joypadData.prevfocus = nil
  self.joypadData.prevprevfocus = nil
end

function CoopCharacterCreation:cancel()
  self:removeFromUIManager()
  CoopCharacterCreation.setVisibleAllUI(true)
  CoopCharacterCreation.instance = nil

  if UIManager.getSpeedControls|() and not IsoPlayer.allPlayersDead() then
    setShowPausedMessage(true)
    UIManager.getSpeedControls|():SetCurrentGameSpeed(1)
  end

  if self.joypadData then
    self.joypadData.activeWhilePaused = nil
    self.joypadData.focus = self.joypadData.listBox
    self.joypadData.prevfocus = nil
    self.joypadData.prevprevfocus = nil
  end

  if ISPostDeathUI.instance[self.playerIndex] then
    ISPostDeathUI.instance[self.playerIndex]:setVisible(true)
    if self.joypadData then
      self.joypadData.focus = ISPostDeathUI.instance[self.playerIndex]
    end
  end
end

function CoopCharacterCreation.newPlayer(joypadIndex, joypadData)
  if CoopCharacterCreation.instance then return end
  if UIManager.getSpeedControls|() and not IsoPlayer.allPlayersDead() then
    setShowPausedMessage(false)
    UIManager.getSpeedControls|():SetCurrentGameSpeed(0)
    joypadData.activeWhilePaused = true
  end
  CoopCharacterCreation.setVisibleAllUI(false)
  local playerIndex = joypadData.player
  if not playerIndex then -- true when not respawning
    for i = 0, getMaxActivePlayers() - 1 do
      local player = getSpecificPlayer(i)
      if not player or player:isDead() then
        playerIndex = i
        break
      end
    end
  end
  local w = CoopCharacterCreation:new(joypadIndex, joypadData, playerIndex)
  w:initialise()
  w:addToUIManager()
  if w.coopUserName:shouldShow() then
    w.coopUserName:beforeShow()
    w.coopUserName:setVisible(true, joypadData)
  elseif w.mapSpawnSelect:hasChoices() then
    w.mapSpawnSelect:fillList()
    w.mapSpawnSelect:setVisible(true, joypadData)
  else
    w.mapSpawnSelect:useDefaultSpawnRegion()
    w.charCreationMain:setVisible(true, joypadData)
  end
end

function CoopCharacterCreation:newPlayerMouse()
  ProfessionFactory.Reset();
  BaseGameCharacterDetails.DoProfessions();
  if CoopCharacterCreation.instance then return end
  if UIManager.getSpeedControls|() and not IsoPlayer.allPlayersDead() then
    setShowPausedMessage(false)
    UIManager.getSpeedControls|():SetCurrentGameSpeed(0)
  end
  CoopCharacterCreation.setVisibleAllUI(false)
  local w = CoopCharacterCreation:new(nil, nil, 0)
  w:initialise()
  w:addToUIManager()
  if w.mapSpawnSelect:hasChoices() then
    w.mapSpawnSelect:fillList()
    w.mapSpawnSelect:setVisible(true)
  else
    w.mapSpawnSelect:useDefaultSpawnRegion()
    w.charCreationMain:setVisible(true)
  end
end
