
function ISUIWriteJournal:destroy()
  UIManager.setShowPausedMessage(true);
  self:setVisible(false);
  self:removeFromUIManager();
  if UIManager.getSpeedControls|() then
    UIManager.getSpeedControls|():SetCurrentGameSpeed(1);
  end
  if JoypadState.players[self.playerNum + 1] then
    local inv = getPlayerInventory(self.playerNum)
    setJoypadFocus(self.playerNum, inv:isReallyVisible() and inv or nil)
  end
end
