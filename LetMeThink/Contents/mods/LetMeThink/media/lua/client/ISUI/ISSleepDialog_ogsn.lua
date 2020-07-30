
function ISSleepDialog:destroy()
  UIManager.setShowPausedMessage(true)
  self:setVisible(false)
  self:removeFromUIManager()
  if UIManager.getSpeedControls|() then
    UIManager.getSpeedControls|():SetCurrentGameSpeed(1)
  end
end

function ISSleepDialog:onClick(button)
  self:destroy()
  if button.internal == "YES" then
    local SleepHours = self.spinBox.selected

    SleepHours = SleepHours + GameTime.getInstance():getTimeOfDay()
    if SleepHours >= 24 then
      SleepHours = SleepHours - 24
    end

    self.player:setForceWakeUpTime(tonumber(SleepHours))
    self.player:setAsleepTime(0.0)
    self.player:setAsleep(true)
    getSleepingEvent():setPlayerFallAsleep(self.player, tonumber(self.spinBox.selected));

    UIManager.setFadeBeforeUI(self.playerNum, true)
    UIManager.FadeOut(self.playerNum, 1)

    if IsoPlayer.allPlayersAsleep() then
      UIManager.getSpeedControls|():SetCurrentGameSpeed(3)
      save(true)
    end

    if JoypadState.players[self.playerNum + 1] then
      setJoypadFocus(self.playerNum, nil)
    end
  end
  if button.internal == "NO" then
    if JoypadState.players[self.playerNum + 1] then
      setJoypadFocus(self.playerNum, nil)
    end
  end
end
